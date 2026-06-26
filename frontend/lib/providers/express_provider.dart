import 'package:flutter/foundation.dart';
import 'package:dochat_app/models/express_models.dart';
import 'package:dochat_app/services/express_service.dart';

class ExpressProvider extends ChangeNotifier {
  final ExpressService _service = ExpressService();

  List<ExpressOrder> _orders = [];
  ExpressOrder? _currentOrder;
  ExpressDriver? _driver;
  Map<String, dynamic>? _estimateResult;
  Map<String, dynamic>? _income;
  Map<String, dynamic>? _juryStatus;
  List<ExpressLocation> _locations = [];
  String _role = 'user';
  bool _loading = false;
  String? _errorMessage;

  List<ExpressOrder> get orders => _orders;
  ExpressOrder? get currentOrder => _currentOrder;
  ExpressDriver? get driver => _driver;
  Map<String, dynamic>? get estimateResult => _estimateResult;
  Map<String, dynamic>? get income => _income;
  Map<String, dynamic>? get juryStatus => _juryStatus;
  List<ExpressLocation> get locations => _locations;
  String get role => _role;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  void toggleRole() {
    _role = _role == 'user' ? 'driver' : 'user';
    notifyListeners();
  }

  Future<void> loadOrders({int page = 0, int size = 20}) async {
    _loading = true;
    notifyListeners();
    try {
      _orders = await _service.getOrders(_role, page: page, size: size);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> loadOrderDetail(String orderId) async {
    _loading = true;
    notifyListeners();
    try {
      _currentOrder = await _service.getOrderDetail(orderId);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> createOrder(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      _currentOrder = await _service.createOrder(data);
      _orders.insert(0, _currentOrder!);
      _loading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> acceptOrder(String orderId) async {
    try {
      _currentOrder = await _service.acceptOrder(orderId);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> updateLocation(String orderId, double lat, double lng) async {
    try {
      await _service.updateLocation(orderId, lat, lng);
      _locations.add(ExpressLocation(
        orderId: orderId,
        lat: lat,
        lng: lng,
        timestamp: DateTime.now().toIso8601String(),
      ));
      notifyListeners();
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<bool> completeOrder(String orderId, double price) async {
    try {
      _currentOrder = await _service.completeOrder(orderId, price);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> estimatePrice(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      _estimateResult = await _service.estimatePrice(data);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> registerDriver(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      _driver = await _service.registerDriver(data);
      _loading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadDriverIncome() async {
    _loading = true;
    notifyListeners();
    try {
      _income = await _service.getDriverIncome();
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> withdraw(double amount, String bankAccount) async {
    try {
      await _service.withdraw(amount, bankAccount);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> updateDriverStatus(String status) async {
    try {
      await _service.updateDriverStatus(status);
      if (_driver != null) {
        _driver = ExpressDriver(
          driverId: _driver!.driverId,
          userId: _driver!.userId,
          name: _driver!.name,
          phone: _driver!.phone,
          vehicleType: _driver!.vehicleType,
          vehiclePlate: _driver!.vehiclePlate,
          authStatus: _driver!.authStatus,
          creditScore: _driver!.creditScore,
          status: status,
          currentLat: _driver!.currentLat,
          currentLng: _driver!.currentLng,
          totalIncome: _driver!.totalIncome,
          balance: _driver!.balance,
        );
      }
      notifyListeners();
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<ExpressDispute?> createDispute(Map<String, dynamic> data) async {
    try {
      final dispute = await _service.createDispute(data);
      notifyListeners();
      return dispute;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return null;
    }
  }

  Future<void> submitEvidence(String disputeId, String evidence) async {
    try {
      await _service.submitEvidence(disputeId, evidence);
      notifyListeners();
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<void> loadJuryStatus(String disputeId) async {
    _loading = true;
    notifyListeners();
    try {
      _juryStatus = await _service.getJuryStatus(disputeId);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
