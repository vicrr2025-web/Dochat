package com.dochat.server.controller;

import com.dochat.server.dto.*;
import com.dochat.server.model.*;
import com.dochat.server.service.JobService;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/job")
public class JobController {

    private final JobService jobService;

    public JobController(JobService jobService) {
        this.jobService = jobService;
    }

    // ==================== 1. Resume ====================

    @PostMapping("/resume")
    public ResponseEntity<ApiResponse<JobResume>> createOrUpdateResume(
            @AuthenticationPrincipal String userId,
            @RequestBody ResumeRequest request) {
        try {
            JobResume resume = jobService.createOrUpdateResume(userId, request);
            return ResponseEntity.ok(ApiResponse.success(resume));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8001, e.getMessage()));
        }
    }

    @GetMapping("/resume")
    public ResponseEntity<ApiResponse<JobResume>> getResume(
            @AuthenticationPrincipal String userId) {
        try {
            JobResume resume = jobService.getResume(userId);
            return ResponseEntity.ok(ApiResponse.success(resume));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8001, e.getMessage()));
        }
    }

    // ==================== 2. Positions ====================

    @GetMapping("/positions")
    public ResponseEntity<ApiResponse<Page<JobPosition>>> searchPositions(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String industry,
            @RequestParam(required = false) Integer salaryMin) {
        try {
            Page<JobPosition> positions = jobService.searchPositions(
                    page, size, keyword, city, industry, salaryMin);
            return ResponseEntity.ok(ApiResponse.success(positions));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8002, e.getMessage()));
        }
    }

    // ==================== 3. Apply ====================

    @PostMapping("/apply")
    public ResponseEntity<ApiResponse<JobApplication>> applyPosition(
            @AuthenticationPrincipal String userId,
            @RequestParam String positionId,
            @RequestParam(required = false) String greeting) {
        try {
            JobApplication application = jobService.applyPosition(userId, positionId, greeting);
            return ResponseEntity.ok(ApiResponse.success(application));
        } catch (Exception e) {
            String msg = e.getMessage();
            if (msg != null && msg.startsWith("8003")) {
                return ResponseEntity.badRequest().body(ApiResponse.error(8003, msg));
            }
            return ResponseEntity.badRequest().body(ApiResponse.error(8002, msg));
        }
    }

    // ==================== 4. Publish ====================

    @PostMapping("/publish")
    public ResponseEntity<ApiResponse<JobPosition>> publishPosition(
            @AuthenticationPrincipal String userId,
            @RequestBody PositionRequest request) {
        try {
            JobPosition position = jobService.publishPosition(userId, request);
            return ResponseEntity.ok(ApiResponse.success(position));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8004, e.getMessage()));
        }
    }

    // ==================== 5. Candidates ====================

    @GetMapping("/candidates")
    public ResponseEntity<ApiResponse<List<JobResume>>> getCandidates(
            @AuthenticationPrincipal String userId,
            @RequestParam String positionId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        try {
            List<JobResume> candidates = jobService.getCandidates(positionId, page, size);
            return ResponseEntity.ok(ApiResponse.success(candidates));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8006, e.getMessage()));
        }
    }

    // ==================== 6. Favorite ====================

    @PostMapping("/favorite")
    public ResponseEntity<ApiResponse<Map<String, Object>>> toggleFavoriteResume(
            @AuthenticationPrincipal String userId,
            @RequestParam String resumeId) {
        try {
            Map<String, Object> result = jobService.toggleFavoriteResume(userId, resumeId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8006, e.getMessage()));
        }
    }

    // ==================== 7. Greeting ====================

    @PostMapping("/greeting")
    public ResponseEntity<ApiResponse<Map<String, Object>>> sendGreeting(
            @AuthenticationPrincipal String userId,
            @RequestParam String toUserId,
            @RequestParam String content) {
        try {
            Map<String, Object> result = jobService.sendGreeting(userId, toUserId, content);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8002, e.getMessage()));
        }
    }

    // ==================== 8. Messages ====================

    @GetMapping("/messages")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getMessages(
            @AuthenticationPrincipal String userId) {
        try {
            List<Map<String, Object>> messages = jobService.getMessages(userId);
            return ResponseEntity.ok(ApiResponse.success(messages));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8002, e.getMessage()));
        }
    }

    // ==================== 9. Company Auth ====================

    @PostMapping("/company/auth")
    public ResponseEntity<ApiResponse<JobCompany>> companyAuth(
            @AuthenticationPrincipal String userId,
            @RequestParam String name,
            @RequestParam String licenseUrl,
            @RequestParam(required = false) String industry,
            @RequestParam(required = false) String scale,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String description) {
        try {
            JobCompany company = jobService.companyAuth(
                    userId, name, licenseUrl, industry, scale, address, description);
            return ResponseEntity.ok(ApiResponse.success(company));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8004, e.getMessage()));
        }
    }

    // ==================== 10. Interview ====================

    @PostMapping("/interview")
    public ResponseEntity<ApiResponse<JobInterview>> scheduleInterview(
            @AuthenticationPrincipal String userId,
            @RequestParam String applicationId,
            @RequestParam String interviewTime,
            @RequestParam(required = false) String location,
            @RequestParam(required = false, defaultValue = "offline") String type,
            @RequestParam(required = false) String remark) {
        try {
            LocalDateTime time = LocalDateTime.parse(interviewTime);
            JobInterview interview = jobService.scheduleInterview(
                    userId, applicationId, time, location, type, remark);
            return ResponseEntity.ok(ApiResponse.success(interview));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8007, e.getMessage()));
        }
    }

    @GetMapping("/interviews")
    public ResponseEntity<ApiResponse<List<JobInterview>>> getInterviews(
            @AuthenticationPrincipal String userId) {
        try {
            List<JobInterview> interviews = jobService.getInterviews(userId);
            return ResponseEntity.ok(ApiResponse.success(interviews));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8007, e.getMessage()));
        }
    }

    // ==================== 11. VIP ====================

    @PostMapping("/vip")
    public ResponseEntity<ApiResponse<JobVip>> upgradeVip(
            @AuthenticationPrincipal String userId,
            @RequestParam(required = false, defaultValue = "candidate") String role) {
        try {
            JobVip vip = jobService.upgradeVip(userId, role);
            return ResponseEntity.ok(ApiResponse.success(vip));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8008, e.getMessage()));
        }
    }

    // ==================== 12. Boost ====================

    @PostMapping("/boost")
    public ResponseEntity<ApiResponse<Map<String, Object>>> buyBoost(
            @AuthenticationPrincipal String userId,
            @RequestParam String positionId) {
        try {
            Map<String, Object> result = jobService.buyBoost(userId, positionId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8005, e.getMessage()));
        }
    }

    // ==================== 13. AI Invite ====================

    @PostMapping("/ai/invite")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> aiBatchInvite(
            @AuthenticationPrincipal String userId,
            @RequestParam String positionId,
            @RequestParam List<String> resumeIds) {
        try {
            List<Map<String, Object>> result = jobService.aiBatchInvite(userId, positionId, resumeIds);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8002, e.getMessage()));
        }
    }

    // ==================== 14. Expert Service ====================

    @PostMapping("/expert")
    public ResponseEntity<ApiResponse<Map<String, Object>>> buyExpertService(
            @AuthenticationPrincipal String userId,
            @RequestParam String serviceType) {
        try {
            Map<String, Object> result = jobService.buyExpertService(userId, serviceType);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(8008, e.getMessage()));
        }
    }
}
