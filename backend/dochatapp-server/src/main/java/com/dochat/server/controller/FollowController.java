package com.dochat.server.controller;

import com.dochat.server.dto.ApiResponse;
import com.dochat.server.dto.PageResponse;
import com.dochat.server.dto.PostResponse;
import com.dochat.server.service.FollowService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/users")
public class FollowController {

    private final FollowService followService;

    public FollowController(FollowService followService) {
        this.followService = followService;
    }

    @PostMapping("/{userId}/follow")
    public ResponseEntity<ApiResponse<Map<String, Object>>> toggleFollow(
            @AuthenticationPrincipal String currentUserId,
            @PathVariable String userId) {
        try {
            Map<String, Object> result = followService.toggleFollow(currentUserId, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/following")
    public ResponseEntity<ApiResponse<PageResponse<Map<String, Object>>>> getFollowing(
            @AuthenticationPrincipal String currentUserId,
            @RequestParam String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        try {
            PageResponse<Map<String, Object>> result = followService.getFollowing(userId, page, size);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/followers")
    public ResponseEntity<ApiResponse<PageResponse<Map<String, Object>>>> getFollowers(
            @AuthenticationPrincipal String currentUserId,
            @RequestParam String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        try {
            PageResponse<Map<String, Object>> result = followService.getFollowers(userId, page, size);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/{userId}/posts")
    public ResponseEntity<ApiResponse<PageResponse<PostResponse>>> getUserPosts(
            @AuthenticationPrincipal String currentUserId,
            @PathVariable String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        try {
            PageResponse<PostResponse> result = followService.getUserPosts(userId, page, size);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }
}
