package com.dochat.server.controller;

import com.dochat.server.dto.*;
import com.dochat.server.model.*;
import com.dochat.server.service.ExpressService;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.Map;

@RestController
@RequestMapping("/api/express")
public class ExpressController {

    private final ExpressService expressService;

    public ExpressController(ExpressService expressService) {
        this.expressService = expressService;
    }

    @PostMapping("/order")
    public ResponseEntity<ApiResponse<ExpressOrder>> createOrder(
            @AuthenticationPrincipal String userId,
            @RequestBody ExpressOrderRequest request) {
        try {
            ExpressOrder order = expressService.createOrder(userId, request);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/orders")
    public ResponseEntity<ApiResponse<Page<ExpressOrder>>> getOrders(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "user") String role,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            Page<ExpressOrder> orders = expressService.getOrders(userId, role, page, size);
            return ResponseEntity.ok(ApiResponse.success(orders));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/detail")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getOrderDetail(
            @AuthenticationPrincipal String userId,
            @RequestParam String orderId) {
        try {
            Map<String, Object> detail = expressService.getOrderDetail(userId, orderId);
            return ResponseEntity.ok(ApiResponse.success(detail));
        } catch (ExpressService.ExpressServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PutMapping("/accept")
    public ResponseEntity<ApiResponse<ExpressOrder>> acceptOrder(
            @AuthenticationPrincipal String userId,
            @RequestParam String orderId) {
        try {
            ExpressOrder order = expressService.acceptOrder(userId, orderId);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (ExpressService.ExpressServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PostMapping("/location")
    public ResponseEntity<ApiResponse<ExpressLocation>> updateLocation(
            @AuthenticationPrincipal String userId,
            @RequestParam String orderId,
            @RequestParam BigDecimal lat,
            @RequestParam BigDecimal lng) {
        try {
            ExpressLocation location = expressService.updateLocation(userId, orderId, lat, lng);
            return ResponseEntity.ok(ApiResponse.success(location));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PutMapping("/complete")
    public ResponseEntity<ApiResponse<ExpressOrder>> completeOrder(
            @AuthenticationPrincipal String userId,
            @RequestParam String orderId,
            @RequestParam BigDecimal actualPrice) {
        try {
            ExpressOrder order = expressService.completeOrder(userId, orderId, actualPrice);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (ExpressService.ExpressServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PostMapping("/estimate")
    public ResponseEntity<ApiResponse<Map<String, Object>>> estimatePrice(
            @AuthenticationPrincipal String userId,
            @RequestBody EstimateRequest request) {
        try {
            Map<String, Object> result = expressService.estimatePrice(request);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PostMapping("/driver/register")
    public ResponseEntity<ApiResponse<ExpressDriver>> registerDriver(
            @AuthenticationPrincipal String userId,
            @RequestBody DriverRegisterRequest request) {
        try {
            ExpressDriver driver = expressService.registerDriver(userId, request);
            return ResponseEntity.ok(ApiResponse.success(driver));
        } catch (ExpressService.ExpressServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/driver/income")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getDriverIncome(
            @AuthenticationPrincipal String userId) {
        try {
            Map<String, Object> income = expressService.getDriverIncome(userId);
            return ResponseEntity.ok(ApiResponse.success(income));
        } catch (ExpressService.ExpressServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PostMapping("/driver/withdraw")
    public ResponseEntity<ApiResponse<ExpressWithdrawal>> withdraw(
            @AuthenticationPrincipal String userId,
            @RequestParam BigDecimal amount,
            @RequestParam String bankAccount) {
        try {
            ExpressWithdrawal withdrawal = expressService.withdraw(userId, amount, bankAccount);
            return ResponseEntity.ok(ApiResponse.success(withdrawal));
        } catch (ExpressService.ExpressServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PutMapping("/driver/status")
    public ResponseEntity<ApiResponse<ExpressDriver>> updateDriverStatus(
            @AuthenticationPrincipal String userId,
            @RequestParam String status) {
        try {
            ExpressDriver driver = expressService.updateDriverStatus(userId, status);
            return ResponseEntity.ok(ApiResponse.success(driver));
        } catch (ExpressService.ExpressServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PutMapping("/cancel")
    public ResponseEntity<ApiResponse<ExpressOrder>> cancelOrder(
            @AuthenticationPrincipal String userId,
            @RequestParam String orderId) {
        try {
            ExpressOrder order = expressService.cancelOrder(userId, orderId);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (ExpressService.ExpressServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(ApiResponse.error(10001, e.getMessage()));
        }
    }

    @PostMapping("/dispute")
    public ResponseEntity<ApiResponse<ExpressDispute>> createDispute(
            @AuthenticationPrincipal String userId,
            @RequestBody ExpressDisputeRequest request) {
        try {
            ExpressDispute dispute = expressService.createDispute(userId, request);
            return ResponseEntity.ok(ApiResponse.success(dispute));
        } catch (ExpressService.ExpressServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PostMapping("/dispute/evidence")
    public ResponseEntity<ApiResponse<ExpressDispute>> submitEvidence(
            @AuthenticationPrincipal String userId,
            @RequestParam String disputeId,
            @RequestParam String evidence) {
        try {
            ExpressDispute dispute = expressService.submitEvidence(userId, disputeId, evidence);
            return ResponseEntity.ok(ApiResponse.success(dispute));
        } catch (ExpressService.ExpressServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/dispute/jury")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getJuryStatus(
            @AuthenticationPrincipal String userId,
            @RequestParam String disputeId) {
        try {
            Map<String, Object> jury = expressService.getJuryStatus(disputeId);
            return ResponseEntity.ok(ApiResponse.success(jury));
        } catch (ExpressService.ExpressServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }
}
