package com.dochat.server.controller;

import com.dochat.server.dto.*;
import com.dochat.server.model.*;
import com.dochat.server.service.MallService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/mall")
public class MallController {

    private final MallService mallService;

    public MallController(MallService mallService) {
        this.mallService = mallService;
    }

    // ==================== Product ====================

    @PostMapping("/products/publish")
    public ResponseEntity<ApiResponse<MallProduct>> publishProduct(
            @AuthenticationPrincipal String userId,
            @RequestBody ProductRequest request) {
        try {
            MallProduct product = mallService.publishProduct(userId, request);
            return ResponseEntity.ok(ApiResponse.success(product));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5001, e.getMessage()));
        }
    }

    @PostMapping("/products/idle")
    public ResponseEntity<ApiResponse<MallProduct>> publishIdleProduct(
            @AuthenticationPrincipal String userId,
            @RequestBody ProductRequest request) {
        try {
            MallProduct product = mallService.publishIdleProduct(userId, request);
            return ResponseEntity.ok(ApiResponse.success(product));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5002, e.getMessage()));
        }
    }

    @GetMapping("/products")
    public ResponseEntity<ApiResponse<Page<MallProduct>>> getProducts(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        try {
            Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
            Page<MallProduct> products = mallService.getProducts(category, keyword, pageable);
            return ResponseEntity.ok(ApiResponse.success(products));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5003, e.getMessage()));
        }
    }

    @GetMapping("/products/{productId}")
    public ResponseEntity<ApiResponse<MallProduct>> getProductDetail(
            @AuthenticationPrincipal String userId,
            @PathVariable String productId) {
        try {
            MallProduct product = mallService.getProductDetail(productId);
            // Add browse history
            try { mallService.addBrowseHistory(userId, productId); } catch (Exception ignored) {}
            return ResponseEntity.ok(ApiResponse.success(product));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5004, e.getMessage()));
        }
    }

    // ==================== Cart ====================

    @PostMapping("/cart/add")
    public ResponseEntity<ApiResponse<Map<String, Object>>> addToCart(
            @AuthenticationPrincipal String userId,
            @RequestParam String productId,
            @RequestParam(defaultValue = "1") int quantity) {
        try {
            Map<String, Object> item = mallService.addToCart(userId, productId, quantity);
            return ResponseEntity.ok(ApiResponse.success(item));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5005, e.getMessage()));
        }
    }

    @GetMapping("/cart")
    public ResponseEntity<ApiResponse<List<MallCartItem>>> getCart(
            @AuthenticationPrincipal String userId) {
        try {
            List<MallCartItem> cart = mallService.getCart(userId);
            return ResponseEntity.ok(ApiResponse.success(cart));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5005, e.getMessage()));
        }
    }

    @PutMapping("/cart/{itemId}")
    public ResponseEntity<ApiResponse<MallCartItem>> updateCartItem(
            @AuthenticationPrincipal String userId,
            @PathVariable Long itemId,
            @RequestParam int quantity) {
        try {
            MallCartItem item = mallService.updateCartItem(userId, itemId, quantity);
            return ResponseEntity.ok(ApiResponse.success(item));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5005, e.getMessage()));
        }
    }

    @DeleteMapping("/cart/{itemId}")
    public ResponseEntity<ApiResponse<Void>> removeCartItem(
            @AuthenticationPrincipal String userId,
            @PathVariable Long itemId) {
        try {
            mallService.removeCartItem(userId, itemId);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5005, e.getMessage()));
        }
    }

    // ==================== Order ====================

    @PostMapping("/orders")
    public ResponseEntity<ApiResponse<MallOrder>> createOrder(
            @AuthenticationPrincipal String userId,
            @RequestBody OrderRequest request) {
        try {
            MallOrder order = mallService.createOrder(userId, request);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5006, e.getMessage()));
        }
    }

    @GetMapping("/orders")
    public ResponseEntity<ApiResponse<Page<MallOrder>>> getOrders(
            @AuthenticationPrincipal String userId,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        try {
            Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
            Page<MallOrder> orders = mallService.getOrders(userId, status, pageable);
            return ResponseEntity.ok(ApiResponse.success(orders));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5007, e.getMessage()));
        }
    }

    @GetMapping("/orders/{orderId}")
    public ResponseEntity<ApiResponse<MallOrder>> getOrderDetail(
            @PathVariable String orderId) {
        try {
            MallOrder order = mallService.getOrderDetail(orderId);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5007, e.getMessage()));
        }
    }

    @PutMapping("/orders/{orderId}/status")
    public ResponseEntity<ApiResponse<MallOrder>> updateOrderStatus(
            @AuthenticationPrincipal String userId,
            @PathVariable String orderId,
            @RequestParam String status) {
        try {
            MallOrder order = mallService.updateOrderStatus(userId, orderId, status);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5008, e.getMessage()));
        }
    }

    @PutMapping("/orders/{orderId}/tracking")
    public ResponseEntity<ApiResponse<MallOrder>> addTracking(
            @AuthenticationPrincipal String userId,
            @PathVariable String orderId,
            @RequestParam String trackingNo) {
        try {
            MallOrder order = mallService.addTracking(userId, orderId, trackingNo);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5009, e.getMessage()));
        }
    }

    // ==================== Refund ====================

    @PostMapping("/orders/{orderId}/refund")
    public ResponseEntity<ApiResponse<MallOrder>> requestRefund(
            @AuthenticationPrincipal String userId,
            @PathVariable String orderId,
            @RequestParam String reason) {
        try {
            MallOrder order = mallService.requestRefund(userId, orderId, reason);
            return ResponseEntity.ok(ApiResponse.success(order));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5010, e.getMessage()));
        }
    }

    // ==================== Review ====================

    @PostMapping("/reviews")
    public ResponseEntity<ApiResponse<MallReview>> submitReview(
            @AuthenticationPrincipal String userId,
            @RequestBody ReviewRequest request) {
        try {
            MallReview review = mallService.submitReview(userId, request);
            return ResponseEntity.ok(ApiResponse.success(review));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5011, e.getMessage()));
        }
    }

    @GetMapping("/products/{productId}/reviews")
    public ResponseEntity<ApiResponse<List<MallReview>>> getProductReviews(
            @PathVariable String productId) {
        try {
            List<MallReview> reviews = mallService.getProductReviews(productId);
            return ResponseEntity.ok(ApiResponse.success(reviews));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5011, e.getMessage()));
        }
    }

    // ==================== Favorites ====================

    @PostMapping("/favorites/add")
    public ResponseEntity<ApiResponse<Void>> addFavorite(
            @AuthenticationPrincipal String userId,
            @RequestParam String productId) {
        try {
            mallService.addFavorite(userId, productId);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5012, e.getMessage()));
        }
    }

    @PostMapping("/favorites/remove")
    public ResponseEntity<ApiResponse<Void>> removeFavorite(
            @AuthenticationPrincipal String userId,
            @RequestParam String productId) {
        try {
            mallService.removeFavorite(userId, productId);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5012, e.getMessage()));
        }
    }

    @GetMapping("/favorites")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getFavorites(
            @AuthenticationPrincipal String userId) {
        try {
            List<Map<String, Object>> favorites = mallService.getFavorites(userId);
            return ResponseEntity.ok(ApiResponse.success(favorites));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5012, e.getMessage()));
        }
    }

    // ==================== Shop ====================

    @PostMapping("/shops/register")
    public ResponseEntity<ApiResponse<MallShop>> registerShop(
            @AuthenticationPrincipal String userId,
            @RequestParam String shopName) {
        try {
            MallShop shop = mallService.registerShop(userId, shopName);
            return ResponseEntity.ok(ApiResponse.success(shop));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5013, e.getMessage()));
        }
    }

    @GetMapping("/shops/{shopId}")
    public ResponseEntity<ApiResponse<MallShop>> getShop(
            @PathVariable String shopId) {
        try {
            MallShop shop = mallService.getShop(shopId);
            return ResponseEntity.ok(ApiResponse.success(shop));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5013, e.getMessage()));
        }
    }

    // ==================== Dispute ====================

    @PostMapping("/disputes")
    public ResponseEntity<ApiResponse<Map<String, Object>>> createDispute(
            @AuthenticationPrincipal String userId,
            @RequestParam String tradeId,
            @RequestParam String reason) {
        try {
            Map<String, Object> dispute = mallService.createDispute(tradeId, userId, reason);
            return ResponseEntity.ok(ApiResponse.success(dispute));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5014, e.getMessage()));
        }
    }

    @GetMapping("/disputes/{disputeId}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getDispute(
            @PathVariable String disputeId) {
        try {
            Map<String, Object> dispute = mallService.getDispute(disputeId);
            return ResponseEntity.ok(ApiResponse.success(dispute));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5014, e.getMessage()));
        }
    }

    // ==================== Browse ====================

    @GetMapping("/browse/history")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getHistory(
            @AuthenticationPrincipal String userId) {
        try {
            List<Map<String, Object>> history = mallService.getHistory(userId);
            return ResponseEntity.ok(ApiResponse.success(history));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5015, e.getMessage()));
        }
    }

    @DeleteMapping("/browse/history")
    public ResponseEntity<ApiResponse<Void>> clearHistory(
            @AuthenticationPrincipal String userId) {
        try {
            mallService.clearHistory(userId);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5015, e.getMessage()));
        }
    }

    // ==================== Relist ====================

    @PostMapping("/products/{productId}/relist")
    public ResponseEntity<ApiResponse<Map<String, String>>> relist(
            @AuthenticationPrincipal String userId,
            @PathVariable String productId) {
        try {
            Map<String, String> result = mallService.relist(userId, productId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5016, e.getMessage()));
        }
    }

    // ==================== Recycle ====================

    @PostMapping("/recycle/estimate")
    public ResponseEntity<ApiResponse<Map<String, Object>>> estimate(
            @AuthenticationPrincipal String userId,
            @RequestParam String category,
            @RequestParam(required = false) String info) {
        try {
            Map<String, Object> result = mallService.estimate(userId, category, info);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5017, e.getMessage()));
        }
    }

    @PostMapping("/recycle/submit")
    public ResponseEntity<ApiResponse<Map<String, String>>> submitRecycle(
            @AuthenticationPrincipal String userId,
            @RequestParam String estimateId) {
        try {
            Map<String, String> result = mallService.submitRecycle(userId, estimateId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5017, e.getMessage()));
        }
    }

    // ==================== Coupons ====================

    @GetMapping("/coupons")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getAvailableCoupons() {
        try {
            List<Map<String, Object>> coupons = mallService.getAvailableCoupons();
            return ResponseEntity.ok(ApiResponse.success(coupons));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5018, e.getMessage()));
        }
    }

    @PostMapping("/coupons/claim")
    public ResponseEntity<ApiResponse<Map<String, Object>>> claimCoupon(
            @AuthenticationPrincipal String userId,
            @RequestParam String couponId) {
        try {
            Map<String, Object> result = mallService.claimCoupon(userId, couponId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5018, e.getMessage()));
        }
    }

    // ==================== Chat ====================

    @PostMapping("/orders/{orderId}/chat")
    public ResponseEntity<ApiResponse<Map<String, String>>> getOrCreateChat(
            @AuthenticationPrincipal String userId,
            @PathVariable String orderId) {
        try {
            Map<String, String> result = mallService.getOrCreateChat(orderId, userId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5019, e.getMessage()));
        }
    }

    // ==================== Credit ====================

    @PostMapping("/credit/update")
    public ResponseEntity<ApiResponse<Void>> updateCreditScore(
            @AuthenticationPrincipal String userId,
            @RequestParam int delta) {
        try {
            mallService.updateCreditScore(userId, delta);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(5020, e.getMessage()));
        }
    }
}
