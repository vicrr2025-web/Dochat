package com.dochat.server.controller;

import com.dochat.server.dto.*;
import com.dochat.server.model.House;
import com.dochat.server.model.HouseAppointment;
import com.dochat.server.model.HouseEvaluation;
import com.dochat.server.model.HouseFavorite;
import com.dochat.server.model.HouseVip;
import com.dochat.server.service.HouseService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/house")
public class HouseController {

    private final HouseService houseService;

    public HouseController(HouseService houseService) {
        this.houseService = houseService;
    }

    @GetMapping("/new")
    public ResponseEntity<ApiResponse<HouseListResponse>> getNewHouses(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String region) {
        try {
            HouseListResponse result = houseService.getNewHouses(page, size, region);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7001, e.getMessage()));
        }
    }

    @GetMapping("/second")
    public ResponseEntity<ApiResponse<HouseListResponse>> getSecondHouses(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            HouseListResponse result = houseService.getSecondHouses(page, size);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7001, e.getMessage()));
        }
    }

    @GetMapping("/rent")
    public ResponseEntity<ApiResponse<HouseListResponse>> getRentHouses(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String subType) {
        try {
            HouseListResponse result = houseService.getRentHouses(page, size, subType);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7001, e.getMessage()));
        }
    }

    @GetMapping("/commercial")
    public ResponseEntity<ApiResponse<HouseListResponse>> getCommercialHouses(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String subType) {
        try {
            HouseListResponse result = houseService.getCommercialHouses(page, size, subType);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7001, e.getMessage()));
        }
    }

    @GetMapping("/detail")
    public ResponseEntity<ApiResponse<House>> getHouseDetail(
            @AuthenticationPrincipal String userId,
            @RequestParam String houseId) {
        try {
            House result = houseService.getHouseDetail(houseId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7001, e.getMessage()));
        }
    }

    @PostMapping("/publish")
    public ResponseEntity<ApiResponse<House>> publishHouse(
            @AuthenticationPrincipal String userId,
            @RequestBody HouseRequest request) {
        try {
            House result = houseService.publishHouse(userId, request);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7007, e.getMessage()));
        }
    }

    @PostMapping("/favorite")
    public ResponseEntity<ApiResponse<HouseFavorite>> addFavorite(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, String> body) {
        try {
            String houseId = body.get("houseId");
            HouseFavorite result = houseService.addFavorite(userId, houseId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            String msg = e.getMessage();
            int code = msg.startsWith("7002") ? 7002 : 7001;
            return ResponseEntity.badRequest().body(ApiResponse.error(code, msg));
        }
    }

    @DeleteMapping("/favorite")
    public ResponseEntity<ApiResponse<Void>> removeFavorite(
            @AuthenticationPrincipal String userId,
            @RequestParam String houseId) {
        try {
            houseService.removeFavorite(userId, houseId);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            String msg = e.getMessage();
            int code = msg.startsWith("7003") ? 7003 : 7001;
            return ResponseEntity.badRequest().body(ApiResponse.error(code, msg));
        }
    }

    @PostMapping("/appointment")
    public ResponseEntity<ApiResponse<HouseAppointment>> createAppointment(
            @AuthenticationPrincipal String userId,
            @RequestBody AppointmentRequest request) {
        try {
            HouseAppointment result = houseService.createAppointment(userId, request);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            String msg = e.getMessage();
            int code = 7008;
            if (msg.startsWith("7005")) code = 7005;
            else if (msg.startsWith("7006")) code = 7006;
            else if (msg.startsWith("7001")) code = 7001;
            return ResponseEntity.badRequest().body(ApiResponse.error(code, msg));
        }
    }

    @GetMapping("/appointments")
    public ResponseEntity<ApiResponse<List<HouseAppointment>>> getAppointments(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String type) {
        try {
            List<HouseAppointment> result = houseService.getAppointments(userId, type);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7004, e.getMessage()));
        }
    }

    @PostMapping("/calculator/mortgage")
    public ResponseEntity<ApiResponse<Map<String, Object>>> calculateMortgage(
            @AuthenticationPrincipal String userId,
            @RequestBody CalculatorRequest request) {
        try {
            Map<String, Object> result = houseService.calculateMortgage(request);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7001, e.getMessage()));
        }
    }

    @PostMapping("/calculator/tax")
    public ResponseEntity<ApiResponse<Map<String, Object>>> calculateTax(
            @AuthenticationPrincipal String userId,
            @RequestBody CalculatorRequest request) {
        try {
            Map<String, Object> result = houseService.calculateTax(request);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7001, e.getMessage()));
        }
    }

    @PostMapping("/valuation")
    public ResponseEntity<ApiResponse<HouseEvaluation>> evaluateHouse(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, String> body) {
        try {
            String houseInfo = body.get("houseInfo");
            HouseEvaluation result = houseService.evaluateHouse(userId, houseInfo);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7010, e.getMessage()));
        }
    }

    @PostMapping("/vip")
    public ResponseEntity<ApiResponse<HouseVip>> upgradeVip(
            @AuthenticationPrincipal String userId) {
        try {
            HouseVip result = houseService.upgradeVip(userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7009, e.getMessage()));
        }
    }

    @PostMapping("/renovation/estimate")
    public ResponseEntity<ApiResponse<HouseEvaluation>> renovationEstimate(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, String> body) {
        try {
            String houseInfo = body.get("houseInfo");
            HouseEvaluation result = houseService.renovationEstimate(userId, houseInfo);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7001, e.getMessage()));
        }
    }

    @GetMapping("/renovation/companies")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getRenovationCompanies(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            List<Map<String, Object>> result = houseService.getRenovationCompanies(page, size);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7001, e.getMessage()));
        }
    }

    @GetMapping("/community")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getCommunityInfo(
            @AuthenticationPrincipal String userId,
            @RequestParam String houseId) {
        try {
            Map<String, Object> result = houseService.getCommunityInfo(houseId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7001, e.getMessage()));
        }
    }

    @PostMapping("/chat")
    public ResponseEntity<ApiResponse<Map<String, Object>>> sendChatMessage(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, String> body) {
        try {
            String houseId = body.get("houseId");
            String content = body.get("content");
            Map<String, Object> result = houseService.sendChatMessage(userId, houseId, content);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(7001, e.getMessage()));
        }
    }
}
