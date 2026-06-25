import 'package:dochat_app/models/mall_models.dart';
import 'package:dochat_app/services/api_service.dart';

class MallService {
  final _api = ApiService();

  Future<List<ProductInfo>> getProductList({String? category, int page = 0}) async {
    final params = <String, dynamic>{'page': page};
    if (category != null && category.isNotEmpty) params['category'] = category;
    final res = await _api.client.get('/mall/products', queryParameters: params);
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => ProductInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map && data['content'] is List) {
      return (data['content'] as List)
          .map((e) => ProductInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<ProductInfo> getProductDetail(String productId) async {
    final res = await _api.client.get('/mall/products/$productId');
    return ProductInfo.fromJson(res.data['data']);
  }

  Future<ProductInfo> publishProduct(PublishProductRequest request) async {
    final res =
        await _api.client.post('/mall/products', data: request.toJson());
    return ProductInfo.fromJson(res.data['data']);
  }

  Future<void> toggleFavorite(String productId) async {
    await _api.client.post('/mall/favorites/$productId');
  }

  Future<List<ProductInfo>> getFavorites({int page = 0}) async {
    final res = await _api.client.get('/mall/favorites',
        queryParameters: {'page': page});
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => ProductInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map && data['content'] is List) {
      return (data['content'] as List)
          .map((e) => ProductInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<CartItemInfo>> getCart() async {
    final res = await _api.client.get('/mall/cart');
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => CartItemInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map && data['content'] is List) {
      return (data['content'] as List)
          .map((e) => CartItemInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> addToCart(String productId, {int qty = 1}) async {
    await _api.client.post('/mall/cart',
        data: {'productId': productId, 'qty': qty});
  }

  Future<void> updateCartItem(String cartItemId, int qty) async {
    await _api.client.put('/mall/cart/$cartItemId', data: {'qty': qty});
  }

  Future<void> removeCartItem(String cartItemId) async {
    await _api.client.delete('/mall/cart/$cartItemId');
  }

  Future<List<OrderInfo>> createOrders(List<CreateOrderRequest> requests) async {
    final res = await _api.client.post('/mall/orders',
        data: requests.map((r) => r.toJson()).toList());
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => OrderInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map && data['content'] is List) {
      return (data['content'] as List)
          .map((e) => OrderInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<OrderInfo>> getOrderList({String? status, int page = 0}) async {
    final params = <String, dynamic>{'page': page};
    if (status != null && status.isNotEmpty) params['status'] = status;
    final res =
        await _api.client.get('/mall/orders', queryParameters: params);
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => OrderInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map && data['content'] is List) {
      return (data['content'] as List)
          .map((e) => OrderInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<OrderInfo> getOrderDetail(String orderId) async {
    final res = await _api.client.get('/mall/orders/$orderId');
    return OrderInfo.fromJson(res.data['data']);
  }

  Future<void> payOrder(String orderId) async {
    await _api.client.put('/mall/orders/$orderId/pay');
  }

  Future<void> shipOrder(String orderId, String trackingNo) async {
    await _api.client
        .put('/mall/orders/$orderId/ship', data: {'trackingNo': trackingNo});
  }

  Future<void> confirmReceipt(String orderId) async {
    await _api.client.put('/mall/orders/$orderId/confirm');
  }

  Future<void> refundOrder(String orderId, String reason) async {
    await _api.client
        .post('/mall/orders/$orderId/refund', data: {'reason': reason});
  }

  Future<Map<String, dynamic>> getChatSession(String orderId) async {
    final res = await _api.client.get('/mall/orders/$orderId/chat');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<ReviewInfo> submitReview(SubmitReviewRequest request) async {
    final res =
        await _api.client.post('/mall/reviews', data: request.toJson());
    return ReviewInfo.fromJson(res.data['data']);
  }

  Future<ShopInfo> getShop(String shopId) async {
    final res = await _api.client.get('/mall/shops/$shopId');
    return ShopInfo.fromJson(res.data['data']);
  }

  Future<List<ProductInfo>> getShopProducts(String shopId,
      {int page = 0}) async {
    final res = await _api.client.get('/mall/shops/$shopId/products',
        queryParameters: {'page': page});
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => ProductInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map && data['content'] is List) {
      return (data['content'] as List)
          .map((e) => ProductInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> estimateRecycle(RecycleRequest request) async {
    final res =
        await _api.client.post('/mall/recycle/estimate', data: request.toJson());
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<void> submitRecycle(RecycleRequest request) async {
    await _api.client.post('/mall/recycle', data: request.toJson());
  }

  Future<List<CouponInfo>> getCoupons() async {
    final res = await _api.client.get('/mall/coupons');
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => CouponInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map && data['content'] is List) {
      return (data['content'] as List)
          .map((e) => CouponInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> claimCoupon(String couponId) async {
    await _api.client.post('/mall/coupons/$couponId/claim');
  }

  Future<Map<String, dynamic>> getDispute(String orderId) async {
    final res = await _api.client.get('/mall/orders/$orderId/dispute');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<void> createDispute(DisputeRequest request) async {
    await _api.client.post('/mall/disputes', data: request.toJson());
  }
}
