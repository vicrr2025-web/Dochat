package com.dochat.server.controller;

import com.dochat.server.dto.*;
import com.dochat.server.model.*;
import com.dochat.server.service.DatingService;
import org.springframework.data.domain.*;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/love")
public class DatingController {

    private final DatingService datingService;

    public DatingController(DatingService datingService) {
        this.datingService = datingService;
    }

    @PostMapping("/profile")
    public ResponseEntity<ApiResponse<DatingProfile>> createOrUpdateProfile(
            @AuthenticationPrincipal String userId,
            @RequestBody ProfileRequest request) {
        try {
            DatingProfile profile = datingService.createOrUpdateProfile(userId, request);
            return ResponseEntity.ok(ApiResponse.success(profile));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6001, e.getMessage()));
        }
    }

    @GetMapping("/profile")
    public ResponseEntity<ApiResponse<DatingProfile>> getProfile(
            @AuthenticationPrincipal String userId) {
        try {
            DatingProfile profile = datingService.getProfile(userId);
            return ResponseEntity.ok(ApiResponse.success(profile));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6001, e.getMessage()));
        }
    }

    @GetMapping("/recommend")
    public ResponseEntity<ApiResponse<Page<DatingProfile>>> getRecommendations(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            Page<DatingProfile> result = datingService.getRecommendations(userId, PageRequest.of(page, size));
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6001, e.getMessage()));
        }
    }

    @PostMapping("/like")
    public ResponseEntity<ApiResponse<Map<String, Object>>> like(
            @AuthenticationPrincipal String userId,
            @RequestBody LikeRequest request) {
        try {
            Map<String, Object> result = datingService.like(userId, request.getToUserId());
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6002, e.getMessage()));
        }
    }

    @PostMapping("/superlike")
    public ResponseEntity<ApiResponse<Map<String, Object>>> superLike(
            @AuthenticationPrincipal String userId,
            @RequestBody LikeRequest request) {
        try {
            Map<String, Object> result = datingService.superLike(userId, request.getToUserId());
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6005, e.getMessage()));
        }
    }

    @GetMapping("/match")
    public ResponseEntity<ApiResponse<?>> getMatchStatus(
            @AuthenticationPrincipal String userId) {
        try {
            var matches = datingService.getMatchStatus(userId);
            return ResponseEntity.ok(ApiResponse.success(matches));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6002, e.getMessage()));
        }
    }

    @PostMapping("/note")
    public ResponseEntity<ApiResponse<DatingNote>> sendNote(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, String> body) {
        try {
            String toUserId = body.get("toUserId");
            String content = body.get("content");
            DatingNote note = datingService.sendNote(userId, toUserId, content);
            return ResponseEntity.ok(ApiResponse.success(note));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6003, e.getMessage()));
        }
    }

    @GetMapping("/notes")
    public ResponseEntity<ApiResponse<?>> getNotes(
            @AuthenticationPrincipal String userId) {
        try {
            var notes = datingService.getNotes(userId);
            return ResponseEntity.ok(ApiResponse.success(notes));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6003, e.getMessage()));
        }
    }

    @PostMapping("/auth/real")
    public ResponseEntity<ApiResponse<Map<String, Object>>> authReal(
            @AuthenticationPrincipal String userId) {
        try {
            Map<String, Object> result = datingService.authReal(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6004, e.getMessage()));
        }
    }

    @PostMapping("/auth/work")
    public ResponseEntity<ApiResponse<Map<String, Object>>> authWork(
            @AuthenticationPrincipal String userId) {
        try {
            Map<String, Object> result = datingService.authWork(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6004, e.getMessage()));
        }
    }

    @PostMapping("/auth/edu")
    public ResponseEntity<ApiResponse<Map<String, Object>>> authEdu(
            @AuthenticationPrincipal String userId) {
        try {
            Map<String, Object> result = datingService.authEdu(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6004, e.getMessage()));
        }
    }

    @PostMapping("/feed")
    public ResponseEntity<ApiResponse<DatingFeed>> createFeed(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, String> body) {
        try {
            String content = body.get("content");
            String images = body.get("images");
            DatingFeed feed = datingService.createFeed(userId, content, images);
            return ResponseEntity.ok(ApiResponse.success(feed));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6001, e.getMessage()));
        }
    }

    @GetMapping("/feed")
    public ResponseEntity<ApiResponse<Page<DatingFeed>>> getFeeds(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            Page<DatingFeed> result = datingService.getFeeds(PageRequest.of(page, size));
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6001, e.getMessage()));
        }
    }

    @PostMapping("/feed/{feedId}/like")
    public ResponseEntity<ApiResponse<Map<String, Object>>> toggleFeedLike(
            @AuthenticationPrincipal String userId,
            @PathVariable String feedId) {
        try {
            Map<String, Object> result = datingService.toggleFeedLike(feedId, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6001, e.getMessage()));
        }
    }

    @PostMapping("/feed/{feedId}/comment")
    public ResponseEntity<ApiResponse<Map<String, Object>>> addFeedComment(
            @AuthenticationPrincipal String userId,
            @PathVariable String feedId,
            @RequestBody Map<String, String> body) {
        try {
            String content = body.get("content");
            Map<String, Object> result = datingService.addFeedComment(feedId, userId, content);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6001, e.getMessage()));
        }
    }

    @PostMapping("/live/start")
    public ResponseEntity<ApiResponse<DatingLive>> startLive(
            @AuthenticationPrincipal String userId) {
        try {
            DatingLive live = datingService.startLive(userId);
            return ResponseEntity.ok(ApiResponse.success(live));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6007, e.getMessage()));
        }
    }

    @PostMapping("/live/end")
    public ResponseEntity<ApiResponse<DatingLive>> endLive(
            @AuthenticationPrincipal String userId) {
        try {
            DatingLive live = datingService.endLive(userId);
            return ResponseEntity.ok(ApiResponse.success(live));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6007, e.getMessage()));
        }
    }

    @PostMapping("/gift")
    public ResponseEntity<ApiResponse<Map<String, Object>>> sendGift(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, String> body) {
        try {
            String toUserId = body.get("toUserId");
            String giftType = body.get("giftType");
            Map<String, Object> result = datingService.sendGift(userId, toUserId, giftType);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6008, e.getMessage()));
        }
    }

    @PostMapping("/recharge")
    public ResponseEntity<ApiResponse<Map<String, Object>>> recharge(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, Integer> body) {
        try {
            int amount = body.getOrDefault("amount", 0);
            Map<String, Object> result = datingService.recharge(userId, amount);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6005, e.getMessage()));
        }
    }

    @PostMapping("/vip")
    public ResponseEntity<ApiResponse<Map<String, Object>>> upgradeVip(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, Integer> body) {
        try {
            int months = body.getOrDefault("months", 1);
            Map<String, Object> result = datingService.upgradeVip(userId, months);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6005, e.getMessage()));
        }
    }

    @PostMapping("/superboost")
    public ResponseEntity<ApiResponse<Map<String, Object>>> superBoost(
            @AuthenticationPrincipal String userId) {
        try {
            Map<String, Object> result = datingService.superBoost(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6005, e.getMessage()));
        }
    }

    @PostMapping("/charm/withdraw")
    public ResponseEntity<ApiResponse<Map<String, Object>>> charmWithdraw(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, Integer> body) {
        try {
            int amount = body.getOrDefault("amount", 0);
            Map<String, Object> result = datingService.charmWithdraw(userId, amount);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6010, e.getMessage()));
        }
    }
}
