package com.dochat.server.controller;

import com.dochat.server.dto.ApiResponse;
import com.dochat.server.dto.PageResponse;
import com.dochat.server.dto.PostRequest;
import com.dochat.server.dto.PostResponse;
import com.dochat.server.service.PostService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/posts")
public class PostController {

    private final PostService postService;

    public PostController(PostService postService) {
        this.postService = postService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<PostResponse>>> getFeed(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "recommend") String feed,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        try {
            PageResponse<PostResponse> result = postService.getFeed(feed, userId, page, size);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PostMapping
    public ResponseEntity<ApiResponse<PostResponse>> createPost(
            @AuthenticationPrincipal String userId,
            @Valid @RequestBody PostRequest request) {
        try {
            PostResponse result = postService.createPost(userId, request);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/{postId}")
    public ResponseEntity<ApiResponse<PostResponse>> getPost(
            @AuthenticationPrincipal String userId,
            @PathVariable String postId) {
        try {
            PostResponse result = postService.getPost(postId, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @DeleteMapping("/{postId}")
    public ResponseEntity<ApiResponse<Void>> deletePost(
            @AuthenticationPrincipal String userId,
            @PathVariable String postId) {
        try {
            postService.deletePost(postId, userId);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PostMapping("/{postId}/like")
    public ResponseEntity<ApiResponse<Map<String, Object>>> toggleLike(
            @AuthenticationPrincipal String userId,
            @PathVariable String postId) {
        try {
            Map<String, Object> result = postService.toggleLike(postId, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PutMapping("/draft")
    public ResponseEntity<ApiResponse<Void>> saveDraft(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, Object> body) {
        try {
            PostRequest request = new PostRequest();
            request.setContent((String) body.get("content"));
            request.setMediaType((String) body.get("mediaType"));
            @SuppressWarnings("unchecked")
            List<String> urls = (List<String>) body.get("mediaUrls");
            request.setMediaUrls(urls);
            if (body.get("mediaDuration") != null) {
                request.setMediaDuration(((Number) body.get("mediaDuration")).intValue());
            }
            request.setLocation((String) body.get("location"));
            request.setVisibility((String) body.get("visibility"));
            String draftPostId = (String) body.get("postId");
            postService.saveDraft(userId, request, draftPostId);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/drafts")
    public ResponseEntity<ApiResponse<List<PostResponse>>> getDrafts(
            @AuthenticationPrincipal String userId) {
        try {
            List<PostResponse> result = postService.getDrafts(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }
}
