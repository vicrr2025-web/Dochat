package com.dochat.server.controller;

import com.dochat.server.dto.ApiResponse;
import com.dochat.server.dto.FriendRequestResponse;
import com.dochat.server.dto.FriendResponse;
import com.dochat.server.service.FriendService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/friends")
public class FriendController {

    private final FriendService friendService;

    public FriendController(FriendService friendService) {
        this.friendService = friendService;
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<Map<String, Object>>> searchUser(
            @AuthenticationPrincipal String userId,
            @RequestParam String phone) {
        try {
            Map<String, Object> result = friendService.searchUser(phone);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PostMapping("/requests")
    public ResponseEntity<ApiResponse<FriendRequestResponse>> sendRequest(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, String> body) {
        try {
            String targetUserId = body.get("targetUserId");
            String message = body.getOrDefault("message", "");
            FriendRequestResponse result = friendService.sendRequest(userId, targetUserId, message);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/requests/pending")
    public ResponseEntity<ApiResponse<List<FriendRequestResponse>>> getPendingRequests(
            @AuthenticationPrincipal String userId) {
        try {
            List<FriendRequestResponse> result = friendService.getPendingRequests(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PutMapping("/requests/{id}/accept")
    public ResponseEntity<ApiResponse<FriendRequestResponse>> acceptRequest(
            @AuthenticationPrincipal String userId,
            @PathVariable Long id) {
        try {
            FriendRequestResponse result = friendService.acceptRequest(id, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PutMapping("/requests/{id}/reject")
    public ResponseEntity<ApiResponse<Void>> rejectRequest(
            @AuthenticationPrincipal String userId,
            @PathVariable Long id) {
        try {
            friendService.rejectRequest(id);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<FriendResponse>>> getFriends(
            @AuthenticationPrincipal String userId) {
        try {
            List<FriendResponse> result = friendService.getFriends(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @DeleteMapping("/{friendId}")
    public ResponseEntity<ApiResponse<Void>> removeFriend(
            @AuthenticationPrincipal String userId,
            @PathVariable String friendId) {
        try {
            friendService.removeFriend(userId, friendId);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }
}
