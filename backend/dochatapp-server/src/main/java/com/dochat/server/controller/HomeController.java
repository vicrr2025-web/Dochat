package com.dochat.server.controller;

import com.dochat.server.dto.*;
import com.dochat.server.model.*;
import com.dochat.server.service.HomeService;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/home")
public class HomeController {

    private final HomeService homeService;

    public HomeController(HomeService homeService) {
        this.homeService = homeService;
    }

    @GetMapping("/service")
    public ResponseEntity<ApiResponse<Page<com.dochat.server.model.HomeService>>> getServices(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String categoryId) {
        try {
            Page<com.dochat.server.model.HomeService> services = homeService.getServices(page, size, categoryId);
            return ResponseEntity.ok(ApiResponse.success(services));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/service/detail")
    public ResponseEntity<ApiResponse<com.dochat.server.model.HomeService>> getServiceDetail(
            @RequestParam String serviceId) {
        try {
            com.dochat.server.model.HomeService service = homeService.getServiceDetail(serviceId);
            return ResponseEntity.ok(ApiResponse.success(service));
        } catch (HomeService.HomeServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PostMapping("/order")
    public ResponseEntity<ApiResponse<HomeOrder>> createOrder(
            @AuthenticationPrincipal String userId,
            @RequestBody HomeOrderRequest request) {
        try {
            HomeOrder order = homeService.createOrder(userId, request);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/orders")
    public ResponseEntity<ApiResponse<Page<HomeOrder>>> getOrders(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "user") String role,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            Page<HomeOrder> orders = homeService.getOrders(userId, role, page, size);
            return ResponseEntity.ok(ApiResponse.success(orders));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PutMapping("/order/accept")
    public ResponseEntity<ApiResponse<HomeOrder>> acceptOrder(
            @AuthenticationPrincipal String userId,
            @RequestParam String orderId) {
        try {
            HomeOrder order = homeService.acceptOrder(userId, orderId);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (HomeService.HomeServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PutMapping("/order/start")
    public ResponseEntity<ApiResponse<HomeOrder>> startService(
            @AuthenticationPrincipal String userId,
            @RequestParam String orderId) {
        try {
            HomeOrder order = homeService.startService(userId, orderId);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (HomeService.HomeServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PutMapping("/order/complete")
    public ResponseEntity<ApiResponse<HomeOrder>> completeService(
            @AuthenticationPrincipal String userId,
            @RequestParam String orderId) {
        try {
            HomeOrder order = homeService.completeService(userId, orderId);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (HomeService.HomeServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PutMapping("/order/verify")
    public ResponseEntity<ApiResponse<HomeOrder>> verifyOrder(
            @AuthenticationPrincipal String userId,
            @RequestParam String orderId) {
        try {
            HomeOrder order = homeService.verifyOrder(userId, orderId);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (HomeService.HomeServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PostMapping("/worker/register")
    public ResponseEntity<ApiResponse<HomeWorker>> registerWorker(
            @AuthenticationPrincipal String userId,
            @RequestBody HomeWorkerRegisterRequest request) {
        try {
            HomeWorker worker = homeService.registerWorker(userId, request);
            return ResponseEntity.ok(ApiResponse.success(worker));
        } catch (HomeService.HomeServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/workers")
    public ResponseEntity<ApiResponse<Page<HomeWorker>>> getWorkers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "") String skill) {
        try {
            Page<HomeWorker> workers = homeService.getWorkers(page, size, skill);
            return ResponseEntity.ok(ApiResponse.success(workers));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/worker/credit")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getWorkerCredit(
            @RequestParam String workerId) {
        try {
            Map<String, Object> credit = homeService.getWorkerCredit(workerId);
            return ResponseEntity.ok(ApiResponse.success(credit));
        } catch (HomeService.HomeServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PostMapping("/dispute")
    public ResponseEntity<ApiResponse<HomeDispute>> createDispute(
            @AuthenticationPrincipal String userId,
            @RequestParam String orderId,
            @RequestParam String reason) {
        try {
            HomeDispute dispute = homeService.createDispute(userId, orderId, reason);
            return ResponseEntity.ok(ApiResponse.success(dispute));
        } catch (HomeService.HomeServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @PostMapping("/dispute/evidence")
    public ResponseEntity<ApiResponse<HomeDispute>> submitEvidence(
            @AuthenticationPrincipal String userId,
            @RequestParam String disputeId,
            @RequestParam String evidence) {
        try {
            HomeDispute dispute = homeService.submitEvidence(userId, disputeId, evidence);
            return ResponseEntity.ok(ApiResponse.success(dispute));
        } catch (HomeService.HomeServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }

    @GetMapping("/dispute/jury")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getJuryStatus(
            @RequestParam String disputeId) {
        try {
            Map<String, Object> jury = homeService.getJuryStatus(disputeId);
            return ResponseEntity.ok(ApiResponse.success(jury));
        } catch (HomeService.HomeServiceException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getCode(), e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()));
        }
    }
}
