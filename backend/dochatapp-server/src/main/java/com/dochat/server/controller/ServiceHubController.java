package com.dochat.server.controller;

import com.dochat.server.dto.ApiResponse;
import com.dochat.server.dto.BadgeResponse;
import com.dochat.server.dto.BadgeUpdateRequest;
import com.dochat.server.service.ServiceHubService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/services")
public class ServiceHubController {

    private final ServiceHubService serviceHubService;

    public ServiceHubController(ServiceHubService serviceHubService) {
        this.serviceHubService = serviceHubService;
    }

    @GetMapping("/badges")
    public ResponseEntity<ApiResponse<List<BadgeResponse>>> getBadges(
            @AuthenticationPrincipal String userId) {
        try {
            List<BadgeResponse> result = serviceHubService.getBadges(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PostMapping("/badges/update")
    public ResponseEntity<ApiResponse<BadgeResponse>> updateBadge(
            @AuthenticationPrincipal String userId,
            @RequestBody BadgeUpdateRequest request) {
        try {
            BadgeResponse result = serviceHubService.updateBadge(userId, request);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }
}
