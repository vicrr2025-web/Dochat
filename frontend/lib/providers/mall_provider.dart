import 'package:flutter/foundation.dart';
import 'package:dochat_app/models/mall_models.dart';
import 'package:dochat_app/services/mall_service.dart';

class MallProvider extends ChangeNotifier {
  final MallService _service = MallService();

  List<ProductInfo> _products = [];
  List<CartItemInfo> _cart = [];
  List<OrderInfo> _orders = [];
  List<ProductInfo> _favorites = [];
  ShopInfo? _shop;
  List<ReviewInfo> _reviews = [];
  List<CouponInfo> _coupons = [];
  ProductInfo? _currentProduct;
  OrderInfo? _currentOrder;
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductInfo> get products => _products;
  List<CartItemInfo> get cart => _cart;
  List<OrderInfo> get orders => _orders;
  List<ProductInfo> get favorites => _favorites;
  ShopInfo? get shop => _shop;
  List<ReviewInfo> get reviews => _reviews;
  List<CouponInfo> get coupons => _coupons;
  ProductInfo? get currentProduct => _currentProduct;
  OrderInfo? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get cartTotal {
    double total = 0;
    for (final item in _cart) {
      if (item.selected) total += item.price * item.qty;
    }
    return total;
  }

  bool get cartAllSelected {
    if (_cart.isEmpty) return false;
    return _cart.every((item) => item.selected);
  }

  Future<void> loadProducts({String? category}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _service.getProductList(category: category);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadProductDetail(String productId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentProduct = await _service.getProductDetail(productId);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> publishProduct(PublishProductRequest request) async {
    try {
      final product = await _service.publishProduct(request);
      _products.insert(0, product);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleFavorite(String productId) async {
    try {
      await _service.toggleFavorite(productId);
      await loadFavorites();
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    try {
      _favorites = await _service.getFavorites();
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();
    try {
      _cart = await _service.getCart();
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addToCart(String productId, {int qty = 1}) async {
    try {
      await _service.addToCart(productId, qty: qty);
      await loadCart();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCartItemQty(String cartItemId, int qty) async {
    try {
      await _service.updateCartItem(cartItemId, qty);
      final idx = _cart.indexWhere((e) => e.id == cartItemId);
      if (idx >= 0) {
        _cart[idx].qty = qty;
        notifyListeners();
      }
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeCartItem(String cartItemId) async {
    try {
      await _service.removeCartItem(cartItemId);
      _cart.removeWhere((e) => e.id == cartItemId);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  void toggleCartItemSelection(int index) {
    _cart[index].selected = !_cart[index].selected;
    notifyListeners();
  }

  void toggleSelectAll() {
    final newVal = !cartAllSelected;
    for (final item in _cart) {
      item.selected = newVal;
    }
    notifyListeners();
  }

  Future<List<OrderInfo>> createOrders(List<CreateOrderRequest> requests) async {
    try {
      final orders = await _service.createOrders(requests);
      _orders.insertAll(0, orders);
      _cart.clear();
      notifyListeners();
      return orders;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return [];
    }
  }

  Future<void> loadOrders({String? status}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _orders = await _service.getOrderList(status: status);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadOrderDetail(String orderId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentOrder = await _service.getOrderDetail(orderId);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> payOrder(String orderId) async {
    try {
      await _service.payOrder(orderId);
      await loadOrderDetail(orderId);
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> shipOrder(String orderId, String trackingNo) async {
    try {
      await _service.shipOrder(orderId, trackingNo);
      await loadOrderDetail(orderId);
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> confirmReceipt(String orderId) async {
    try {
      await _service.confirmReceipt(orderId);
      await loadOrderDetail(orderId);
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> refundOrder(String orderId, String reason) async {
    try {
      await _service.refundOrder(orderId, reason);
      await loadOrderDetail(orderId);
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>?> getChatSession(String orderId) async {
    try {
      return await _service.getChatSession(orderId);
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return null;
    }
  }

  Future<bool> submitReview(SubmitReviewRequest request) async {
    try {
      final review = await _service.submitReview(request);
      _reviews.insert(0, review);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadShop(String shopId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _shop = await _service.getShop(shopId);
      _products = await _service.getShopProducts(shopId);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> estimateRecycle(RecycleRequest request) async {
    try {
      return await _service.estimateRecycle(request);
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return null;
    }
  }

  Future<bool> submitRecycle(RecycleRequest request) async {
    try {
      await _service.submitRecycle(request);
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadCoupons() async {
    _isLoading = true;
    notifyListeners();
    try {
      _coupons = await _service.getCoupons();
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> claimCoupon(String couponId) async {
    try {
      await _service.claimCoupon(couponId);
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>?> getDispute(String orderId) async {
    try {
      return await _service.getDispute(orderId);
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return null;
    }
  }

  Future<bool> createDispute(DisputeRequest request) async {
    try {
      await _service.createDispute(request);
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }
}
