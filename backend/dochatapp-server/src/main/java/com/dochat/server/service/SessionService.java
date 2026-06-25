package com.dochat.server.service;

import com.dochat.server.dto.CreateSessionRequest;
import com.dochat.server.dto.PageResponse;
import com.dochat.server.dto.SessionResponse;
import com.dochat.server.model.Session;
import com.dochat.server.model.SessionMember;
import com.dochat.server.model.User;
import com.dochat.server.repository.SessionMemberRepository;
import com.dochat.server.repository.SessionRepository;
import com.dochat.server.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class SessionService {

    private static final Logger log = LoggerFactory.getLogger(SessionService.class);

    private final SessionRepository sessionRepository;
    private final SessionMemberRepository sessionMemberRepository;
    private final UserRepository userRepository;

    public SessionService(SessionRepository sessionRepository,
                          SessionMemberRepository sessionMemberRepository,
                          UserRepository userRepository) {
        this.sessionRepository = sessionRepository;
        this.sessionMemberRepository = sessionMemberRepository;
        this.userRepository = userRepository;
    }

    public PageResponse<SessionResponse> getSessions(Long userIdDb, int page, int size) {
        User user = userRepository.findById(userIdDb)
                .orElseThrow(() -> new RuntimeException("用户不存在"));
        String userId = user.getUserId();

        Pageable pageable = PageRequest.of(page, size);
        List<Session> sessions = sessionRepository.findSessionsByMemberUserId(userId, pageable);
        long total = sessionRepository.countByMemberUserId(userId);

        List<SessionResponse> list = sessions.stream()
                .map(s -> toSessionResponse(s, userId))
                .collect(Collectors.toList());

        int totalPages = (int) Math.ceil((double) total / size);
        return new PageResponse<>(list, totalPages, total, page);
    }

    @Transactional
    public SessionResponse createSession(Long userIdDb, CreateSessionRequest request) {
        User user = userRepository.findById(userIdDb)
                .orElseThrow(() -> new RuntimeException("用户不存在"));
        String userId = user.getUserId();
        String targetUserId = request.getTargetUserId();

        User targetUser = userRepository.findByUserId(targetUserId)
                .orElseThrow(() -> new RuntimeException("目标用户不存在"));

        if (userId.equals(targetUserId)) {
            throw new RuntimeException("不能和自己创建会话");
        }

        // Check if a single chat session already exists between these two users
        List<String> commonSessionIds = sessionMemberRepository
                .findCommonSessionIds(userId, targetUserId);
        for (String sid : commonSessionIds) {
            Session s = sessionRepository.findBySessionId(sid).orElse(null);
            if (s != null && "single".equals(s.getType())) {
                log.debug("Existing single session found: {}", sid);
                return toSessionResponse(s, userId);
            }
        }

        // Create new session
        String sessionId = "s_" + UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        Session session = new Session();
        session.setSessionId(sessionId);
        session.setType("single");
        session.setName(targetUser.getNickname());
        session.setAvatar(targetUser.getAvatar());
        session.setLastTime(LocalDateTime.now());
        session = sessionRepository.save(session);

        SessionMember member1 = new SessionMember();
        member1.setSessionId(sessionId);
        member1.setUserId(userId);
        sessionMemberRepository.save(member1);

        SessionMember member2 = new SessionMember();
        member2.setSessionId(sessionId);
        member2.setUserId(targetUserId);
        sessionMemberRepository.save(member2);

        log.info("Created single session {} between {} and {}", sessionId, userId, targetUserId);
        return toSessionResponse(session, userId);
    }

    public void pinSession(String sessionId, boolean pinned) {
        Session session = sessionRepository.findBySessionId(sessionId)
                .orElseThrow(() -> new RuntimeException("会话不存在"));
        session.setIsPinned(pinned);
        sessionRepository.save(session);
        log.debug("Session {} pinned={}", sessionId, pinned);
    }

    public void muteSession(String sessionId, boolean muted, Long durationSeconds) {
        Session session = sessionRepository.findBySessionId(sessionId)
                .orElseThrow(() -> new RuntimeException("会话不存在"));
        session.setIsMuted(muted);
        if (muted && durationSeconds != null && durationSeconds > 0) {
            session.setMuteExpire(LocalDateTime.now().plusSeconds(durationSeconds));
        } else {
            session.setMuteExpire(null);
        }
        sessionRepository.save(session);
        log.debug("Session {} muted={} duration={}s", sessionId, muted, durationSeconds);
    }

    @Transactional
    public void deleteSession(String sessionId) {
        Session session = sessionRepository.findBySessionId(sessionId)
                .orElseThrow(() -> new RuntimeException("会话不存在"));
        sessionRepository.delete(session);
        log.info("Session {} deleted", sessionId);
    }

    private SessionResponse toSessionResponse(Session session, String userId) {
        SessionMember member = sessionMemberRepository
                .findByUserIdAndSessionId(userId, session.getSessionId())
                .orElse(null);
        SessionResponse r = new SessionResponse();
        r.setSessionId(session.getSessionId());
        r.setType(session.getType());
        r.setName(session.getName());
        r.setAvatar(session.getAvatar());
        r.setLastMessage(session.getLastMessage());
        r.setLastMessageType(session.getLastMessageType());
        r.setLastTime(session.getLastTime());
        r.setUnreadCount(member != null ? member.getUnreadCount() : 0);
        r.setIsPinned(session.getIsPinned());
        r.setIsMuted(session.getIsMuted());
        return r;
    }
}
