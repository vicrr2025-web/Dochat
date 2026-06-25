package com.dochat.server.controller;

import com.dochat.server.dto.ApiResponse;
import com.dochat.server.dto.LocationResponse;
import com.dochat.server.dto.TrajectoryPoint;
import com.dochat.server.service.LocationService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/location")
public class LocationController {

    private final LocationService locationService;

    public LocationController(LocationService locationService) {
        this.locationService = locationService;
    }

    @PostMapping("/upload")
    public ResponseEntity<ApiResponse<Void>> uploadLocation(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, Object> body) {
        try {
            double lat = ((Number) body.get("lat")).doubleValue();
            double lng = ((Number) body.get("lng")).doubleValue();
            Float accuracy = body.containsKey("accuracy") ? ((Number) body.get("accuracy")).floatValue() : null;
            Integer battery = body.containsKey("battery") ? ((Number) body.get("battery")).intValue() : null;
            Boolean isCharging = body.containsKey("isCharging") ? (Boolean) body.get("isCharging") : null;

            locationService.uploadLocation(userId, lat, lng, accuracy, battery, isCharging);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/current")
    public ResponseEntity<ApiResponse<LocationResponse>> getCurrentLocation(
            @AuthenticationPrincipal String userId) {
        try {
            LocationResponse result = locationService.getCurrentLocation(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/friends")
    public ResponseEntity<ApiResponse<Map<String, LocationResponse>>> getFriendLocations(
            @AuthenticationPrincipal String userId) {
        try {
            Map<String, LocationResponse> result = locationService.getFriendLocations(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/{friendId}/trajectory")
    public ResponseEntity<ApiResponse<List<TrajectoryPoint>>> getTrajectory(
            @AuthenticationPrincipal String userId,
            @PathVariable String friendId,
            @RequestParam String start,
            @RequestParam String end) {
        try {
            LocalDateTime startTime = LocalDateTime.parse(start);
            LocalDateTime endTime = LocalDateTime.parse(end);
            List<TrajectoryPoint> result = locationService.getTrajectory(userId, friendId, startTime, endTime);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PutMapping("/sharing")
    public ResponseEntity<ApiResponse<Void>> toggleSharing(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, Boolean> body) {
        try {
            boolean enabled = body.getOrDefault("enabled", false);
            locationService.toggleLocationSharing(userId, enabled);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }
}
