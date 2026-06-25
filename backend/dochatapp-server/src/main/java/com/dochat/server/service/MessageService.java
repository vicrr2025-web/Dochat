package com.dochat.server.service;

import com.dochat.server.dto.MessageResponse;
import com.dochat.server.dto.PageResponse;
import com.dochat.server.dto.SendMessageRequest;
import com.dochat.server.model.Message;
import com.dochat.server.model.Session;
import com.dochat.server.model.SessionMember;
import com.dochat.server.repository.MessageRepository;
import com.dochat.server.repository.SessionMemberRepository;
import com.dochat.server.repository.SessionRepository;
import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class MessageService {

    private static final Logger log = LoggerFactory.getLogger(MessageService.class);
    private static final Gson GSON = new Gson();
    private static final DateTimeFormatter MONTH_FMT = DateTimeFormatter.ofPattern("yyyy-MM");

    private final MessageRepository messageRepository;
    private final SessionRepository sessionRepository;
    private final SessionMemberRepository sessionMemberRepository;
    private final SseService sseService;
    private final StringRedisTemplate redisTemplate;

    @Value("${app.upload.dir:uploads}")
    private String uploadDir;

    public MessageService(MessageRepository messageRepository,
                          SessionRepository sessionRepository,
                          SessionMemberRepository sessionMemberRepository,
                          SseService sseService,
                          StringRedisTemplate redisTemplate) {
        this.messageRepository = messageRepository;
        this.sessionRepository = sessionRepository;
        this.sessionMemberRepository = sessionMemberRepository;
        this.sseService = sseService;
        this.redisTemplate = redisTemplate;
    }

    @Transactional
    public MessageResponse sendMessage(String sessionId, String senderId, SendMessageRequest request) {
        Session session = sessionRepository.findBySessionId(sessionId)
                .orElseThrow(() -> new RuntimeException("会话不存在"));

        String messageId = "m_" + UUID.randomUUID().toString().replace("-", "").substring(0, 16);

        Message message = new Message();
        message.setMessageId(messageId);
        message.setSessionId(sessionId);
        message.setSenderId(senderId);
        message.setType(request.getType() != null ? request.getType() : "text");
        message.setContent(request.getContent());
        message.setMediaUrl(request.getMediaUrl());
        message.setMediaDuration(request.getMediaDuration());
        message.setFileName(request.getFileName());
        message.setFileSize(request.getFileSize());
        message.setStatus("sent");
        message.setSentAt(LocalDateTime.now());
        message = messageRepository.save(message);

        // Update session last message
        session.setLastMessage(buildLastMessageSummary(request));
        session.setLastMessageType(request.getType());
        session.setLastTime(message.getSentAt());
        sessionRepository.save(session);

        // Increment unread count for all members except sender
        List<SessionMember> members = sessionMemberRepository.findBySessionId(sessionId);
        for (SessionMember member : members) {
            if (!member.getUserId().equals(senderId)) {
                member.setUnreadCount(member.getUnreadCount() + 1);
                sessionMemberRepository.save(member);
            }
        }

        // Publish to Redis Pub/Sub for SSE push
        Map<String, Object> eventData = buildMessageEventMap(message);
        redisTemplate.convertAndSend("chat:" + sessionId, GSON.toJson(eventData));

        // Deliver via SSE to online users
        sseService.sendEvent(sessionId, "message", eventData);

        log.debug("Message {} sent in session {}", messageId, sessionId);
        return toMessageResponse(message);
    }

    public PageResponse<MessageResponse> getMessages(String sessionId, String beforeMessageId, int size) {
        List<Message> messages;
        if (beforeMessageId == null || beforeMessageId.isEmpty()) {
            messages = messageRepository.findBySessionIdOrderBySentAtDesc(
                    sessionId, PageRequest.of(0, size));
        } else {
            messages = messageRepository.findBySessionIdAndBefore(
                    sessionId, beforeMessageId, PageRequest.of(0, size));
        }

        List<MessageResponse> list = messages.stream()
                .map(this::toMessageResponse)
                .collect(Collectors.toList());

        long total = messages.size();
        return new PageResponse<>(list, 0, total, 0);
    }

    @Transactional
    public MessageResponse revokeMessage(String messageId, String userId) {
        Message message = messageRepository.findByMessageId(messageId)
                .orElseThrow(() -> new RuntimeException("消息不存在"));

        if (!message.getSenderId().equals(userId)) {
            throw new RuntimeException("只能撤回自己发送的消息");
        }

        if (message.getSentAt().plusHours(24).isBefore(LocalDateTime.now())) {
            throw new RuntimeException("消息已超过24小时，无法撤回");
        }

        message.setIsRecalled(true);
        message.setStatus("revoked");
        message.setRecalledAt(LocalDateTime.now());
        messageRepository.save(message);

        Map<String, Object> eventData = new HashMap<>();
        eventData.put("messageId", messageId);
        eventData.put("sessionId", message.getSessionId());
        eventData.put("isRecalled", true);
        sseService.sendEvent(message.getSessionId(), "revoke", eventData);

        log.debug("Message {} revoked by {}", messageId, userId);
        return toMessageResponse(message);
    }

    @Transactional
    public void markRead(String sessionId, String userId, String lastMessageId) {
        Message lastMsg = messageRepository.findByMessageId(lastMessageId).orElse(null);
        if (lastMsg == null) {
            log.warn("Message {} not found for markRead", lastMessageId);
            return;
        }

        SessionMember member = sessionMemberRepository
                .findByUserIdAndSessionId(userId, sessionId)
                .orElse(null);
        if (member != null) {
            member.setUnreadCount(0);
            sessionMemberRepository.save(member);
        }

        Map<String, Object> eventData = new HashMap<>();
        eventData.put("userId", userId);
        eventData.put("lastMessageId", lastMessageId);
        sseService.sendEvent(sessionId, "read", eventData);

        log.debug("Messages marked as read in session {} for user {} up to {}",
                sessionId, userId, lastMessageId);
    }

    public PageResponse<MessageResponse> searchMessages(String keyword, String sessionId,
                                                         int page, int size) {
        Page<Message> messagePage;
        if (sessionId != null && !sessionId.isEmpty()) {
            messagePage = messageRepository.findBySessionIdAndContentContainingIgnoreCase(
                    sessionId, keyword, PageRequest.of(page, size));
        } else {
            messagePage = messageRepository.searchByKeyword(keyword, PageRequest.of(page, size));
        }

        List<MessageResponse> list = messagePage.getContent().stream()
                .map(this::toMessageResponse)
                .collect(Collectors.toList());

        return new PageResponse<>(list, messagePage.getTotalPages(),
                messagePage.getTotalElements(), page);
    }

    public Map<String, String> uploadFile(MultipartFile file) {
        if (file.isEmpty()) {
            throw new RuntimeException("文件为空");
        }

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) {
            throw new RuntimeException("文件名无效");
        }

        if (originalFilename.contains("..") || originalFilename.contains("/") || originalFilename.contains("\\")) {
            throw new RuntimeException("文件名包含非法字符");
        }

        String ext = "";
        int dotIndex = originalFilename.lastIndexOf('.');
        if (dotIndex > 0) {
            ext = originalFilename.substring(dotIndex + 1).toLowerCase();
        }

        boolean isImage = ext.matches("png|jpg|jpeg|gif|webp");
        boolean isDoc = ext.matches("pdf|doc|docx|xls|xlsx|txt|zip");
        if (!isImage && !isDoc) {
            throw new RuntimeException("不支持的文件类型");
        }

        long maxSize = isImage ? 5 * 1024 * 1024 : 50 * 1024 * 1024;
        if (file.getSize() > maxSize) {
            throw new RuntimeException(isImage ? "图片不能超过5MB" : "文件不能超过50MB");
        }

        String monthDir = LocalDateTime.now().format(MONTH_FMT);
        String storedName = UUID.randomUUID().toString().replace("-", "") + "." + ext;
        Path dir = Paths.get(uploadDir, monthDir);
        try {
            Files.createDirectories(dir);
            Path dest = dir.resolve(storedName);
            file.transferTo(dest.toFile());

            String url = "/uploads/" + monthDir + "/" + storedName;
            log.info("File uploaded: {} -> {}", originalFilename, dest);
            return Map.of("url", url, "fileName", originalFilename);
        } catch (IOException e) {
            log.error("File upload failed", e);
            throw new RuntimeException("文件上传失败: " + e.getMessage());
        }
    }

    private Map<String, Object> buildMessageEventMap(Message m) {
        Map<String, Object> map = new HashMap<>();
        map.put("messageId", m.getMessageId());
        map.put("sessionId", m.getSessionId());
        map.put("senderId", m.getSenderId());
        map.put("type", m.getType());
        map.put("content", m.getContent());
        map.put("mediaUrl", m.getMediaUrl() != null ? m.getMediaUrl() : "");
        map.put("mediaDuration", m.getMediaDuration() != null ? m.getMediaDuration() : 0);
        map.put("fileName", m.getFileName() != null ? m.getFileName() : "");
        map.put("fileSize", m.getFileSize() != null ? m.getFileSize() : 0L);
        map.put("status", m.getStatus());
        map.put("isRecalled", false);
        map.put("sentAt", m.getSentAt().toString());
        return map;
    }

    private MessageResponse toMessageResponse(Message m) {
        MessageResponse r = new MessageResponse();
        r.setMessageId(m.getMessageId());
        r.setSessionId(m.getSessionId());
        r.setSenderId(m.getSenderId());
        r.setType(m.getType());
        r.setContent(m.getContent());
        r.setMediaUrl(m.getMediaUrl());
        r.setMediaDuration(m.getMediaDuration());
        r.setFileName(m.getFileName());
        r.setFileSize(m.getFileSize());
        r.setStatus(m.getStatus());
        r.setIsRecalled(m.getIsRecalled());
        r.setSentAt(m.getSentAt());
        return r;
    }

    private String buildLastMessageSummary(SendMessageRequest request) {
        String type = request.getType();
        if (type == null) return "";
        return switch (type) {
            case "text" -> request.getContent() != null && request.getContent().length() > 50
                    ? request.getContent().substring(0, 50) + "..." : request.getContent();
            case "voice" -> "[语音]";
            case "image" -> "[图片]";
            case "file" -> "[文件] " + request.getFileName();
            case "system" -> request.getContent();
            default -> "";
        };
    }
}
