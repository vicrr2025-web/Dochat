package com.dochat.server.controller;

import com.dochat.server.dto.ApiResponse;
import com.dochat.server.dto.GeoFenceRequest;
import com.dochat.server.dto.GeoFenceResponse;
import com.dochat.server.model.GeoFence;
import com.dochat.server.service.GeoFenceService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/geofences")
public class GeoFenceController {

    private final GeoFenceService geoFenceService;

    public GeoFenceController(GeoFenceService geoFenceService) {
        this.geoFenceService = geoFenceService;
    }

    @PostMapping
    public ResponseEntity<ApiResponse<GeoFenceResponse>> createFence(
            @AuthenticationPrincipal String userId,
            @RequestBody GeoFenceRequest request) {
        try {
            GeoFence fence = geoFenceService.createFence(userId,
                    request.getName(), request.getLatitude(), request.getLongitude(),
                    request.getRadius(), request.getTargetUserId());
            GeoFenceResponse response = toResponse(fence);
            return ResponseEntity.ok(ApiResponse.success(response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<GeoFenceResponse>>> getFences(
            @AuthenticationPrincipal String userId) {
        try {
            List<GeoFence> fences = geoFenceService.getFences(userId);
            List<GeoFenceResponse> responses = fences.stream()
                    .map(this::toResponse).toList();
            return ResponseEntity.ok(ApiResponse.success(responses));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteFence(
            @AuthenticationPrincipal String userId,
            @PathVariable Long id) {
        try {
            geoFenceService.deleteFence(id, userId);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    private GeoFenceResponse toResponse(GeoFence fence) {
        GeoFenceResponse resp = new GeoFenceResponse();
        resp.setFenceId(fence.getId());
        resp.setName(fence.getName());
        resp.setLatitude(fence.getLatitude());
        resp.setLongitude(fence.getLongitude());
        resp.setRadius(fence.getRadius());
        resp.setIsActive(fence.getIsActive());
        resp.setTargetUserId(fence.getTargetUserId());
        resp.setCreatedAt(fence.getCreatedAt());
        return resp;
    }
}
