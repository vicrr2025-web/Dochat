package com.dochat.server.controller;

import com.dochat.server.dto.ApiResponse;
import com.dochat.server.dto.MessageResponse;
import com.dochat.server.dto.PageResponse;
import com.dochat.server.dto.SendMessageRequest;
import com.dochat.server.service.MessageService;
import com.dochat.server.service.SseService;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.Map;

@RestController
@RequestMapping("/api/v1")
public class MessageController {

    private final MessageService messageService;
    private final SseService sseService;

    public MessageController(MessageService messageService, SseService sseService) {
        this.messageService = messageService;
        this.sseService = sseService;
    }

    @PostMapping("/messages")
    public ResponseEntity<ApiResponse<MessageResponse>> sendMessage(
            @AuthenticationPrincipal String userId,
            @RequestBody SendMessageRequest request) {
        MessageResponse result = messageService.sendMessage(
                request.getSessionId(), userId, request);
        return ResponseEntity.ok(ApiResponse.success(result));
    }

    @GetMapping("/messages")
    public ResponseEntity<ApiResponse<PageResponse<MessageResponse>>> getMessages(
            @AuthenticationPrincipal String userId,
            @RequestParam String sessionId,
            @RequestParam(required = false) String before,
            @RequestParam(defaultValue = "20") int size) {
        PageResponse<MessageResponse> result = messageService.getMessages(
                sessionId, before, size);
        return ResponseEntity.ok(ApiResponse.success(result));
    }

    @PutMapping("/messages/{id}/revoke")
    public ResponseEntity<ApiResponse<MessageResponse>> revokeMessage(
            @AuthenticationPrincipal String userId,
            @PathVariable String id) {
        MessageResponse result = messageService.revokeMessage(id, userId);
        return ResponseEntity.ok(ApiResponse.success(result));
    }

    @PutMapping("/messages/read")
    public ResponseEntity<ApiResponse<Void>> markRead(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, String> body) {
        String sessionId = body.get("sessionId");
        String lastMessageId = body.get("lastMessageId");
        messageService.markRead(sessionId, userId, lastMessageId);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @GetMapping("/messages/search")
    public ResponseEntity<ApiResponse<PageResponse<MessageResponse>>> searchMessages(
            @AuthenticationPrincipal String userId,
            @RequestParam String keyword,
            @RequestParam(required = false) String sessionId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PageResponse<MessageResponse> result = messageService.searchMessages(
                keyword, sessionId, page, size);
        return ResponseEntity.ok(ApiResponse.success(result));
    }

    @PostMapping("/messages/upload")
    public ResponseEntity<ApiResponse<Map<String, String>>> uploadFile(
            @AuthenticationPrincipal String userId,
            @RequestParam("file") MultipartFile file) {
        Map<String, String> result = messageService.uploadFile(file);
        return ResponseEntity.ok(ApiResponse.success(result));
    }

    @GetMapping(value = "/sessions/{sessionId}/subscribe",
            produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter subscribe(
            @AuthenticationPrincipal String userId,
            @PathVariable String sessionId) {
        return sseService.subscribe(sessionId, userId);
    }
}
