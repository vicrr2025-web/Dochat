package com.dochat.server.controller;

import com.dochat.server.dto.ApiResponse;
import com.dochat.server.dto.DisputeRequest;
import com.dochat.server.dto.PageResponse;
import com.dochat.server.dto.TradeCreateRequest;
import com.dochat.server.dto.TradeResponse;
import com.dochat.server.service.GuaranteeService;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/guarantee")
public class GuaranteeController {

    private final GuaranteeService guaranteeService;

    public GuaranteeController(GuaranteeService guaranteeService) {
        this.guaranteeService = guaranteeService;
    }

    @PostMapping("/create")
    public ResponseEntity<ApiResponse<TradeResponse>> createTrade(
            @AuthenticationPrincipal String userId,
            @RequestBody TradeCreateRequest request) {
        try {
            TradeResponse result = guaranteeService.createTrade(userId, request);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7001, e.getMessage()));
        }
    }

    @GetMapping("/{tradeId}")
    public ResponseEntity<ApiResponse<TradeResponse>> getTradeDetail(
            @AuthenticationPrincipal String userId,
            @PathVariable String tradeId) {
        try {
            TradeResponse result = guaranteeService.getTradeDetail(tradeId, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7002, e.getMessage()));
        }
    }

    @PutMapping("/{tradeId}/confirm")
    public ResponseEntity<ApiResponse<TradeResponse>> confirmTrade(
            @AuthenticationPrincipal String userId,
            @PathVariable String tradeId) {
        try {
            TradeResponse result = guaranteeService.confirmTrade(tradeId, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7003, e.getMessage()));
        }
    }

    @PutMapping("/{tradeId}/freeze")
    public ResponseEntity<ApiResponse<TradeResponse>> freezeFunds(
            @AuthenticationPrincipal String userId,
            @PathVariable String tradeId) {
        try {
            TradeResponse result = guaranteeService.freezeFunds(tradeId, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7004, e.getMessage()));
        }
    }

    @PostMapping("/{tradeId}/verify")
    public ResponseEntity<ApiResponse<TradeResponse>> initiateVerify(
            @AuthenticationPrincipal String userId,
            @PathVariable String tradeId) {
        try {
            TradeResponse result = guaranteeService.initiateVerify(tradeId, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7005, e.getMessage()));
        }
    }

    @PostMapping("/{tradeId}/verify/submit")
    public ResponseEntity<ApiResponse<TradeResponse>> submitVerify(
            @AuthenticationPrincipal String userId,
            @PathVariable String tradeId) {
        try {
            TradeResponse result = guaranteeService.submitVerify(tradeId, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7006, e.getMessage()));
        }
    }

    @PutMapping("/{tradeId}/release")
    public ResponseEntity<ApiResponse<TradeResponse>> releaseFunds(
            @AuthenticationPrincipal String userId,
            @PathVariable String tradeId) {
        try {
            TradeResponse result = guaranteeService.releaseFunds(tradeId, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7007, e.getMessage()));
        }
    }

    @GetMapping("/list")
    public ResponseEntity<ApiResponse<PageResponse<TradeResponse>>> getTradeList(
            @AuthenticationPrincipal String userId,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        try {
            Page<TradeResponse> tradePage = guaranteeService.getTradeList(userId, status, page, size);
            PageResponse<TradeResponse> pageResponse = new PageResponse<>(
                    tradePage.getContent(),
                    tradePage.getTotalPages(),
                    tradePage.getTotalElements(),
                    page);
            return ResponseEntity.ok(ApiResponse.success(pageResponse));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7008, e.getMessage()));
        }
    }

    @PostMapping("/{tradeId}/dispute")
    public ResponseEntity<ApiResponse<Map<String, Object>>> createDispute(
            @AuthenticationPrincipal String userId,
            @PathVariable String tradeId,
            @RequestBody DisputeRequest request) {
        try {
            Map<String, Object> result = guaranteeService.createDispute(tradeId, userId, request);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7009, e.getMessage()));
        }
    }

    @GetMapping("/{tradeId}/dispute")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getDispute(
            @AuthenticationPrincipal String userId,
            @PathVariable String tradeId) {
        try {
            Map<String, Object> result = guaranteeService.getDispute(tradeId, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7010, e.getMessage()));
        }
    }

    @GetMapping("/{tradeId}/chat")
    public ResponseEntity<ApiResponse<Map<String, String>>> getOrCreateChat(
            @AuthenticationPrincipal String userId,
            @PathVariable String tradeId) {
        try {
            Map<String, String> result = guaranteeService.getOrCreateChat(tradeId, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7011, e.getMessage()));
        }
    }
}
