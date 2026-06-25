package com.dochat.server.controller;

import com.dochat.server.dto.*;
import com.dochat.server.service.SettingsService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/user")
public class SettingsController {

    private final SettingsService settingsService;

    public SettingsController(SettingsService settingsService) {
        this.settingsService = settingsService;
    }

    @GetMapping("/profile")
    public ResponseEntity<ApiResponse<ProfileResponse>> getProfile(
            @AuthenticationPrincipal String userId) {
        try {
            ProfileResponse result = settingsService.getProfile(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6001, e.getMessage()));
        }
    }

    @PutMapping("/profile")
    public ResponseEntity<ApiResponse<ProfileResponse>> updateProfile(
            @AuthenticationPrincipal String userId,
            @RequestBody ProfileUpdateRequest request) {
        try {
            ProfileResponse result = settingsService.updateProfile(userId, request);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6002, e.getMessage()));
        }
    }

    @PutMapping("/password")
    public ResponseEntity<ApiResponse<Void>> changePassword(
            @AuthenticationPrincipal String userId,
            @RequestBody PasswordChangeRequest request) {
        try {
            settingsService.changePassword(userId, request);
            return ResponseEntity.ok(ApiResponse.success("密码修改成功", null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6003, e.getMessage()));
        }
    }

    @PostMapping("/verify")
    public ResponseEntity<ApiResponse<Map<String, Object>>> verifyIdentity(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, String> body) {
        try {
            Map<String, Object> result = settingsService.verifyIdentity(
                    userId,
                    body.get("realName"),
                    body.get("idNumber"),
                    body.get("faceId")
            );
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6004, e.getMessage()));
        }
    }

    @GetMapping("/verify/status")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getVerifyStatus(
            @AuthenticationPrincipal String userId) {
        try {
            Map<String, Object> result = settingsService.getVerifyStatus(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6005, e.getMessage()));
        }
    }

    @GetMapping("/devices")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getDevices(
            @AuthenticationPrincipal String userId) {
        try {
            List<Map<String, Object>> result = settingsService.getDevices(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6006, e.getMessage()));
        }
    }

    @DeleteMapping("/devices/{deviceId}")
    public ResponseEntity<ApiResponse<Void>> removeDevice(
            @AuthenticationPrincipal String userId,
            @PathVariable String deviceId) {
        try {
            settingsService.removeDevice(deviceId);
            return ResponseEntity.ok(ApiResponse.success("设备已移除", null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6007, e.getMessage()));
        }
    }

    @DeleteMapping("/devices/others")
    public ResponseEntity<ApiResponse<Void>> removeOtherDevices(
            @AuthenticationPrincipal String userId,
            @RequestParam String currentDeviceId) {
        try {
            settingsService.removeOtherDevices(userId, currentDeviceId);
            return ResponseEntity.ok(ApiResponse.success("其他设备已移除", null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6008, e.getMessage()));
        }
    }

    @GetMapping("/storage")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getStorage(
            @AuthenticationPrincipal String userId) {
        try {
            Map<String, Object> result = settingsService.getStorage(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6009, e.getMessage()));
        }
    }

    @GetMapping("/privacy")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getPrivacy(
            @AuthenticationPrincipal String userId) {
        try {
            Map<String, Object> result = settingsService.getPrivacy(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6010, e.getMessage()));
        }
    }

    @PutMapping("/privacy")
    public ResponseEntity<ApiResponse<Map<String, Object>>> updatePrivacy(
            @AuthenticationPrincipal String userId,
            @RequestBody PrivacyUpdateRequest request) {
        try {
            Map<String, Object> result = settingsService.updatePrivacy(userId, request);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6010, e.getMessage()));
        }
    }

    @GetMapping("/blacklist")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getBlacklist(
            @AuthenticationPrincipal String userId) {
        try {
            List<Map<String, Object>> result = settingsService.getBlacklist(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(6010, e.getMessage()));
        }
    }
}
