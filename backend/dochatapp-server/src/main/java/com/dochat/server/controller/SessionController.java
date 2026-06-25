package com.dochat.server.controller;

import com.dochat.server.dto.ApiResponse;
import com.dochat.server.dto.CreateSessionRequest;
import com.dochat.server.dto.PageResponse;
import com.dochat.server.dto.SessionResponse;
import com.dochat.server.model.User;
import com.dochat.server.repository.UserRepository;
import com.dochat.server.service.SessionService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/sessions")
public class SessionController {

    private final SessionService sessionService;
    private final UserRepository userRepository;

    public SessionController(SessionService sessionService, UserRepository userRepository) {
        this.sessionService = sessionService;
        this.userRepository = userRepository;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<SessionResponse>>> getSessions(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("用户不存在"));
        PageResponse<SessionResponse> result = sessionService.getSessions(user.getId(), page, size);
        return ResponseEntity.ok(ApiResponse.success(result));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<SessionResponse>> createSession(
            @AuthenticationPrincipal String userId,
            @RequestBody CreateSessionRequest request) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("用户不存在"));
        SessionResponse result = sessionService.createSession(user.getId(), request);
        return ResponseEntity.ok(ApiResponse.success(result));
    }

    @PutMapping("/{id}/pin")
    public ResponseEntity<ApiResponse<Void>> pinSession(
            @AuthenticationPrincipal String userId,
            @PathVariable String id,
            @RequestBody Map<String, Boolean> body) {
        boolean pinned = body.getOrDefault("pinned", false);
        sessionService.pinSession(id, pinned);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @PutMapping("/{id}/mute")
    public ResponseEntity<ApiResponse<Void>> muteSession(
            @AuthenticationPrincipal String userId,
            @PathVariable String id,
            @RequestBody Map<String, Object> body) {
        boolean muted = (boolean) body.getOrDefault("muted", false);
        Object durationObj = body.get("duration");
        Long duration = null;
        if (durationObj instanceof Number) {
            duration = ((Number) durationObj).longValue();
        }
        sessionService.muteSession(id, muted, duration);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteSession(
            @AuthenticationPrincipal String userId,
            @PathVariable String id) {
        sessionService.deleteSession(id);
        return ResponseEntity.ok(ApiResponse.success(null));
    }
}
