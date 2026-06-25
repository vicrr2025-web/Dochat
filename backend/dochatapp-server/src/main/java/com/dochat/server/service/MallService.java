package com.dochat.server.service;

import com.dochat.server.dto.OrderRequest;
import com.dochat.server.dto.ProductRequest;
import com.dochat.server.dto.ReviewRequest;
import com.dochat.server.model.*;
import com.dochat.server.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class MallService {

    private static final Logger log = LoggerFactory.getLogger(MallService.class);

    private final MallProductRepository productRepository;
    private final MallCartItemRepository cartItemRepository;
    private final MallOrderRepository orderRepository;
    private final MallReviewRepository reviewRepository;
    private final MallShopRepository shopRepository;
    private final MallCouponRepository couponRepository;
    private final MallFavoriteRepository favoriteRepository;
    private final MallBrowseHistoryRepository browseHistoryRepository;
    private final GuaranteeDisputeRepository disputeRepository;
    private final UserRepository userRepository;
    private final SessionRepository sessionRepository;
    private final SessionMemberRepository sessionMemberRepository;

    public MallService(MallProductRepository productRepository,
                       MallCartItemRepository cartItemRepository,
                       MallOrderRepository orderRepository,
                       MallReviewRepository reviewRepository,
                       MallShopRepository shopRepository,
                       MallCouponRepository couponRepository,
                       MallFavoriteRepository favoriteRepository,
                       MallBrowseHistoryRepository browseHistoryRepository,
                       GuaranteeDisputeRepository disputeRepository,
                       UserRepository userRepository,
                       SessionRepository sessionRepository,
                       SessionMemberRepository sessionMemberRepository) {
        this.productRepository = productRepository;
        this.cartItemRepository = cartItemRepository;
        this.orderRepository = orderRepository;
        this.reviewRepository = reviewRepository;
        this.shopRepository = shopRepository;
        this.couponRepository = couponRepository;
        this.favoriteRepository = favoriteRepository;
        this.browseHistoryRepository = browseHistoryRepository;
        this.disputeRepository = disputeRepository;
        this.userRepository = userRepository;
        this.sessionRepository = sessionRepository;
        this.sessionMemberRepository = sessionMemberRepository;
    }

    // ==================== Product ====================

    @Transactional
    public MallProduct publishProduct(String userId, ProductRequest request) {
        MallProduct product = new MallProduct();
        product.setSellerId(userId);
        product.setTitle(request.getTitle());
        product.setDescription(request.getDescription());
        product.setPrice(request.getPrice());
        product.setCategory(request.getCategory() != null ? request.getCategory() : "farm");
        if (request.getImages() != null) {
            product.setImages(toJsonArray(request.getImages()));
        }
        product = productRepository.save(product);
        log.info("Product published: {} by {}", product.getProductId(), userId);
        return product;
    }

    @Transactional
    public MallProduct publishIdleProduct(String userId, ProductRequest request) {
        return publishProduct(userId, request);
    }

    public Page<MallProduct> getProducts(String category, String keyword, Pageable pageable) {
        if (keyword != null && !keyword.isEmpty()) {
            return productRepository.findByTitleContaining(keyword, pageable);
        }
        if (category != null && !category.isEmpty()) {
            return productRepository.findByCategory(category, pageable);
        }
        return productRepository.findAll(pageable);
    }

    public MallProduct getProductDetail(String productId) {
        return productRepository.findByProductId(productId)
                .orElseThrow(() -> new RuntimeException("商品不存在: " + productId));
    }

    // ==================== Cart ====================

    @Transactional
    public Map<String, Object> addToCart(String userId, String productId, int quantity) {
        Optional<MallCartItem> existing = cartItemRepository.findByUserIdAndProductId(userId, productId);
        MallCartItem item;
        if (existing.isPresent()) {
            item = existing.get();
            item.setQuantity(item.getQuantity() + (quantity > 0 ? quantity : 1));
        } else {
            item = new MallCartItem();
            item.setUserId(userId);
            item.setProductId(productId);
            item.setQuantity(quantity > 0 ? quantity : 1);
        }
        item = cartItemRepository.save(item);
        Map<String, Object> result = new HashMap<>();
        result.put("id", item.getId());
        result.put("productId", item.getProductId());
        result.put("quantity", item.getQuantity());
        return result;
    }

    public List<MallCartItem> getCart(String userId) {
        return cartItemRepository.findByUserId(userId);
    }

    @Transactional
    public MallCartItem updateCartItem(String userId, Long itemId, int quantity) {
        MallCartItem item = cartItemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("购物车项不存在"));
        if (!item.getUserId().equals(userId)) {
            throw new RuntimeException("无权操作该购物车项");
        }
        item.setQuantity(quantity);
        return cartItemRepository.save(item);
    }

    @Transactional
    public void removeCartItem(String userId, Long itemId) {
        MallCartItem item = cartItemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("购物车项不存在"));
        if (!item.getUserId().equals(userId)) {
            throw new RuntimeException("无权操作该购物车项");
        }
        cartItemRepository.delete(item);
    }

    // ==================== Order ====================

    @Transactional
    public MallOrder createOrder(String userId, OrderRequest request) {
        MallProduct product = productRepository.findByProductId(request.getProductId())
                .orElseThrow(() -> new RuntimeException("商品不存在"));
        if (!"active".equals(product.getStatus())) {
            throw new RuntimeException("商品已下架或售出");
        }
        int qty = request.getQuantity() > 0 ? request.getQuantity() : 1;

        MallOrder order = new MallOrder();
        order.setBuyerId(userId);
        order.setSellerId(product.getSellerId());
        order.setProductId(product.getProductId());
        order.setAmount(product.getPrice().multiply(BigDecimal.valueOf(qty)));
        order.setQuantity(qty);
        order = orderRepository.save(order);

        // Clear cart items for this user
        cartItemRepository.deleteByUserId(userId);

        log.info("Order created: {} buyer={} product={}", order.getOrderId(), userId, product.getProductId());
        return order;
    }

    public Page<MallOrder> getOrders(String userId, String status, Pageable pageable) {
        if (status != null && !status.isEmpty()) {
            return orderRepository.findByBuyerIdOrSellerIdAndStatus(userId, status, pageable);
        }
        return orderRepository.findByBuyerIdOrSellerId(userId, pageable);
    }

    public MallOrder getOrderDetail(String orderId) {
        return orderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new RuntimeException("订单不存在: " + orderId));
    }

    @Transactional
    public MallOrder updateOrderStatus(String userId, String orderId, String newStatus) {
        MallOrder order = orderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new RuntimeException("订单不存在"));
        if (!order.getBuyerId().equals(userId) && !order.getSellerId().equals(userId)) {
            throw new RuntimeException("无权操作该订单");
        }
        // Validate status flow
        String current = order.getStatus();
        boolean valid = switch (current) {
            case "pending" -> newStatus.equals("paid") || newStatus.equals("cancelled");
            case "paid" -> newStatus.equals("shipped");
            case "shipped" -> newStatus.equals("received");
            case "received" -> newStatus.equals("completed");
            default -> false;
        };
        if (!valid) {
            throw new RuntimeException("状态流转不允许: " + current + " -> " + newStatus);
        }
        order.setStatus(newStatus);
        order = orderRepository.save(order);
        return order;
    }

    @Transactional
    public MallOrder addTracking(String userId, String orderId, String trackingNo) {
        MallOrder order = orderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new RuntimeException("订单不存在"));
        if (!order.getSellerId().equals(userId)) {
            throw new RuntimeException("仅卖家可以填写物流");
        }
        order.setTrackingNo(trackingNo);
        return orderRepository.save(order);
    }

    // ==================== Refund ====================

    @Transactional
    public MallOrder requestRefund(String userId, String orderId, String reason) {
        MallOrder order = orderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new RuntimeException("订单不存在"));
        if (!order.getBuyerId().equals(userId)) {
            throw new RuntimeException("仅买家可以申请退款");
        }
        if (!"paid".equals(order.getStatus()) && !"shipped".equals(order.getStatus()) && !"received".equals(order.getStatus())) {
            throw new RuntimeException("当前状态不允许退款");
        }
        order.setStatus("cancelled");
        return orderRepository.save(order);
    }

    // ==================== Review ====================

    @Transactional
    public MallReview submitReview(String userId, ReviewRequest request) {
        MallOrder order = orderRepository.findByOrderId(request.getOrderId())
                .orElseThrow(() -> new RuntimeException("订单不存在"));
        if (!order.getBuyerId().equals(userId)) {
            throw new RuntimeException("仅买家可以评价");
        }
        if (!"completed".equals(order.getStatus())) {
            throw new RuntimeException("订单未完成，无法评价");
        }
        if (request.getRating() < 1 || request.getRating() > 5) {
            throw new RuntimeException("评分必须在1-5之间");
        }

        MallReview review = new MallReview();
        review.setOrderId(request.getOrderId());
        review.setReviewerId(userId);
        review.setRating(request.getRating());
        review.setContent(request.getContent());
        review = reviewRepository.save(review);
        log.info("Review submitted: {} for order {}", review.getReviewId(), request.getOrderId());
        return review;
    }

    public List<MallReview> getProductReviews(String productId) {
        // Find orders for this product, then reviews for those orders
        List<MallOrder> orders = orderRepository.findAll().stream()
                .filter(o -> o.getProductId().equals(productId))
                .collect(Collectors.toList());
        List<MallReview> reviews = new ArrayList<>();
        for (MallOrder order : orders) {
            reviews.addAll(reviewRepository.findByOrderId(order.getOrderId()));
        }
        return reviews;
    }

    // ==================== Favorites ====================

    @Transactional
    public void addFavorite(String userId, String productId) {
        if (favoriteRepository.findByUserIdAndProductId(userId, productId).isPresent()) {
            return;
        }
        MallFavorite fav = new MallFavorite();
        fav.setUserId(userId);
        fav.setProductId(productId);
        favoriteRepository.save(fav);
    }

    @Transactional
    public void removeFavorite(String userId, String productId) {
        favoriteRepository.deleteByUserIdAndProductId(userId, productId);
    }

    public List<Map<String, Object>> getFavorites(String userId) {
        List<MallFavorite> favs = favoriteRepository.findByUserId(userId);
        List<Map<String, Object>> result = new ArrayList<>();
        for (MallFavorite fav : favs) {
            Map<String, Object> item = new HashMap<>();
            item.put("productId", fav.getProductId());
            item.put("createdAt", fav.getCreatedAt().toString());
            productRepository.findByProductId(fav.getProductId()).ifPresent(p -> {
                item.put("title", p.getTitle());
                item.put("price", p.getPrice());
                item.put("status", p.getStatus());
            });
            result.add(item);
        }
        return result;
    }

    // ==================== Shop ====================

    @Transactional
    public MallShop registerShop(String userId, String shopName) {
        MallShop shop = new MallShop();
        shop.setOwnerId(userId);
        shop.setShopName(shopName);
        shop.setStatus("pending");
        shop = shopRepository.save(shop);

        // MOCK auto-approve
        shop.setStatus("approved");
        shop = shopRepository.save(shop);
        log.info("Shop registered and auto-approved: {} by {}", shop.getShopId(), userId);
        return shop;
    }

    public MallShop getShop(String shopId) {
        return shopRepository.findByShopId(shopId)
                .orElseThrow(() -> new RuntimeException("店铺不存在: " + shopId));
    }

    // ==================== Dispute ====================

    @Transactional
    public Map<String, Object> createDispute(String tradeId, String userId, String reason) {
        MallOrder order = orderRepository.findByOrderId(tradeId)
                .orElseThrow(() -> new RuntimeException("订单不存在"));
        if (!order.getBuyerId().equals(userId) && !order.getSellerId().equals(userId)) {
            throw new RuntimeException("无权发起争议");
        }

        // Check if dispute already exists
        Optional<GuaranteeDispute> existing = disputeRepository.findByTradeId(tradeId);
        if (existing.isPresent()) {
            throw new RuntimeException("该订单已有争议记录");
        }

        GuaranteeDispute dispute = new GuaranteeDispute();
        dispute.setTradeId(tradeId);
        dispute.setInitiatorId(userId);
        dispute.setReason(reason);
        dispute.setStatus("pending");
        dispute = disputeRepository.save(dispute);

        // MOCK: Resolve immediately with jury_count=17, threshold=9
        // 10 votes buyer, 7 seller -> buyer_win
        dispute.setJuryCount(17);
        dispute.setVotesForBuyer(10);
        dispute.setVotesForSeller(7);
        dispute.setVerdict("buyer_win");
        dispute.setStatus("resolved");
        dispute.setResolvedAt(LocalDateTime.now());
        dispute = disputeRepository.save(dispute);

        Map<String, Object> result = new HashMap<>();
        result.put("disputeId", dispute.getDisputeId());
        result.put("tradeId", dispute.getTradeId());
        result.put("status", dispute.getStatus());
        result.put("verdict", dispute.getVerdict());
        result.put("juryCount", dispute.getJuryCount());
        result.put("votesForBuyer", dispute.getVotesForBuyer());
        result.put("votesForSeller", dispute.getVotesForSeller());
        return result;
    }

    public Map<String, Object> getDispute(String disputeId) {
        GuaranteeDispute dispute = disputeRepository.findByDisputeId(disputeId)
                .orElseThrow(() -> new RuntimeException("争议不存在: " + disputeId));

        Map<String, Object> result = new HashMap<>();
        result.put("disputeId", dispute.getDisputeId());
        result.put("tradeId", dispute.getTradeId());
        result.put("initiatorId", dispute.getInitiatorId());
        result.put("reason", dispute.getReason());
        result.put("status", dispute.getStatus());
        result.put("verdict", dispute.getVerdict());
        result.put("juryCount", dispute.getJuryCount());
        result.put("votesForBuyer", dispute.getVotesForBuyer());
        result.put("votesForSeller", dispute.getVotesForSeller());
        result.put("resolvedAt", dispute.getResolvedAt() != null ? dispute.getResolvedAt().toString() : null);
        return result;
    }

    // ==================== Browse ====================

    @Transactional
    public void addBrowseHistory(String userId, String productId) {
        MallBrowseHistory history = new MallBrowseHistory();
        history.setUserId(userId);
        history.setProductId(productId);
        browseHistoryRepository.save(history);
    }

    public List<Map<String, Object>> getHistory(String userId) {
        List<MallBrowseHistory> histories = browseHistoryRepository.findByUserIdOrderByCreatedAtDesc(userId);
        List<Map<String, Object>> result = new ArrayList<>();
        for (MallBrowseHistory h : histories) {
            Map<String, Object> item = new HashMap<>();
            item.put("productId", h.getProductId());
            item.put("createdAt", h.getCreatedAt().toString());
            productRepository.findByProductId(h.getProductId()).ifPresent(p -> {
                item.put("title", p.getTitle());
                item.put("price", p.getPrice());
            });
            result.add(item);
        }
        return result;
    }

    @Transactional
    public void clearHistory(String userId) {
        browseHistoryRepository.deleteByUserId(userId);
    }

    // ==================== Relist ====================

    @Transactional
    public Map<String, String> relist(String userId, String productId) {
        MallProduct product = productRepository.findByProductId(productId)
                .orElseThrow(() -> new RuntimeException("商品不存在"));
        if (!product.getSellerId().equals(userId)) {
            throw new RuntimeException("无权操作该商品");
        }
        product.setStatus("active");
        productRepository.save(product);
        Map<String, String> result = new HashMap<>();
        result.put("productId", productId);
        result.put("status", "active");
        return result;
    }

    // ==================== Recycle ====================

    public Map<String, Object> estimate(String userId, String category, String info) {
        Random random = new Random();
        BigDecimal price = BigDecimal.valueOf(50 + random.nextInt(451));
        Map<String, Object> result = new HashMap<>();
        result.put("estimateId", UUID.randomUUID().toString().replace("-", "").substring(0, 16));
        result.put("category", category);
        result.put("recyclePrice", price);
        return result;
    }

    @Transactional
    public Map<String, String> submitRecycle(String userId, String estimateId) {
        Map<String, String> result = new HashMap<>();
        result.put("estimateId", estimateId);
        result.put("status", "submitted");
        return result;
    }

    // ==================== Coupons ====================

    public List<Map<String, Object>> getAvailableCoupons() {
        List<Map<String, Object>> coupons = new ArrayList<>();

        Map<String, Object> c1 = new HashMap<>();
        c1.put("couponId", "coupon_new_user");
        c1.put("title", "新人专享券");
        c1.put("discount", new BigDecimal("20.00"));
        c1.put("minAmount", new BigDecimal("100.00"));
        coupons.add(c1);

        Map<String, Object> c2 = new HashMap<>();
        c2.put("couponId", "coupon_farm");
        c2.put("title", "农场满减券");
        c2.put("discount", new BigDecimal("15.00"));
        c2.put("minAmount", new BigDecimal("80.00"));
        coupons.add(c2);

        Map<String, Object> c3 = new HashMap<>();
        c3.put("couponId", "coupon_summer");
        c3.put("title", "夏日清凉券");
        c3.put("discount", new BigDecimal("30.00"));
        c3.put("minAmount", new BigDecimal("150.00"));
        coupons.add(c3);

        return coupons;
    }

    @Transactional
    public Map<String, Object> claimCoupon(String userId, String couponId) {
        Map<String, Object> result = new HashMap<>();
        result.put("couponId", couponId);
        result.put("userId", userId);
        result.put("status", "claimed");
        return result;
    }

    // ==================== Chat ====================

    @Transactional
    public Map<String, String> getOrCreateChat(String orderId, String userId) {
        MallOrder order = orderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new RuntimeException("订单不存在"));
        if (!order.getBuyerId().equals(userId) && !order.getSellerId().equals(userId)) {
            throw new RuntimeException("无权操作该订单");
        }

        if (order.getSessionId() != null) {
            Map<String, String> result = new HashMap<>();
            result.put("sessionId", order.getSessionId());
            return result;
        }

        String buyerId = order.getBuyerId();
        String sellerId = order.getSellerId();

        // Check existing single session
        List<String> commonSessionIds = sessionMemberRepository.findCommonSessionIds(buyerId, sellerId);
        for (String sid : commonSessionIds) {
            Optional<Session> optSession = sessionRepository.findBySessionId(sid);
            if (optSession.isPresent() && "single".equals(optSession.get().getType())) {
                order.setSessionId(sid);
                orderRepository.save(order);
                Map<String, String> result = new HashMap<>();
                result.put("sessionId", sid);
                return result;
            }
        }

        // Create new session
        String sessionId = "s_" + UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        Session session = new Session();
        session.setSessionId(sessionId);
        session.setType("single");
        session.setLastTime(LocalDateTime.now());
        session = sessionRepository.save(session);

        SessionMember member1 = new SessionMember();
        member1.setSessionId(sessionId);
        member1.setUserId(buyerId);
        sessionMemberRepository.save(member1);

        SessionMember member2 = new SessionMember();
        member2.setSessionId(sessionId);
        member2.setUserId(sellerId);
        sessionMemberRepository.save(member2);

        order.setSessionId(sessionId);
        orderRepository.save(order);

        log.info("Created mall chat session {} for order {}", sessionId, orderId);

        Map<String, String> result = new HashMap<>();
        result.put("sessionId", sessionId);
        return result;
    }

    // ==================== Credit ====================

    @Transactional
    public void updateCreditScore(String userId, int delta) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("用户不存在"));
        int newScore = user.getCreditScore() + delta;
        user.setCreditScore(Math.max(0, Math.min(100, newScore)));

        // Update credit level
        if (newScore >= 90) {
            user.setCreditLevel("钻石");
        } else if (newScore >= 70) {
            user.setCreditLevel("金牌");
        } else if (newScore >= 50) {
            user.setCreditLevel("银牌");
        } else {
            user.setCreditLevel("铜牌");
        }

        userRepository.save(user);
    }

    // ==================== Helpers ====================

    private String toJsonArray(List<String> list) {
        if (list == null || list.isEmpty()) return "[]";
        return "[" + list.stream().map(s -> "\"" + s + "\"").collect(Collectors.joining(",")) + "]";
    }
}
