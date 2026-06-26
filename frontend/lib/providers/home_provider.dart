import 'package:flutter/foundation.dart';
import 'package:dochat_app/models/home_models.dart';
import 'package:dochat_app/services/home_service.dart' as home_svc;

class HomeProvider extends ChangeNotifier {
  final home_svc.HomeService _service = home_svc.HomeService();

  List<HomeServiceItem> _services = [];
  List<HomeCategory> _categories = [];
  List<HomeOrder> _orders = [];
  HomeOrder? _currentOrder;
  HomeWorker? _worker;
  List<HomeWorker> _workers = [];
  Map<String, dynamic>? _credit;
  HomeDispute? _dispute;
  Map<String, dynamic>? _juryStatus;
  List<HomeTraining> _trainings = [];
  List<HomeFavorite> _favorites = [];
  Map<String, dynamic>? _income;
  String _role = 'user';
  String _currentCategory = 'all';
  bool _loading = false;
  String? _errorMessage;

  List<HomeServiceItem> get services => _services;
  List<HomeCategory> get categories => _categories;
  List<HomeOrder> get orders => _orders;
  HomeOrder? get currentOrder => _currentOrder;
  HomeWorker? get worker => _worker;
  List<HomeWorker> get workers => _workers;
  Map<String, dynamic>? get credit => _credit;
  HomeDispute? get dispute => _dispute;
  Map<String, dynamic>? get juryStatus => _juryStatus;
  List<HomeTraining> get trainings => _trainings;
  List<HomeFavorite> get favorites => _favorites;
  Map<String, dynamic>? get income => _income;
  String get role => _role;
  String get currentCategory => _currentCategory;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  void toggleRole() {
    _role = _role == 'user' ? 'worker' : 'user';
    notifyListeners();
  }

  void setCategory(String category) {
    _currentCategory = category;
    notifyListeners();
  }

  Future<void> loadServices({String? category, String? subCategory}) async {
    _loading = true;
    notifyListeners();
    try {
      _services = await _service.getServices(category: category, subCategory: subCategory);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _service.getCategories();
      notifyListeners();
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<void> loadServiceDetail(String serviceId) async {
    _loading = true;
    notifyListeners();
    try {
      final detail = await _service.getServiceDetail(serviceId);
      final idx = _services.indexWhere((s) => s.serviceId == serviceId);
      if (idx >= 0) {
        _services[idx] = detail;
      }
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

  Future<void> loadOrders({String? role}) async {
    _loading = true;
    notifyListeners();
    try {
      _orders = await _service.getOrders(role: role ?? _role);
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

  Future<bool> startService(String orderId) async {
    try {
      _currentOrder = await _service.startService(orderId);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> completeService(String orderId) async {
    try {
      _currentOrder = await _service.completeService(orderId);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOrder(String orderId, bool accept, {double? rating}) async {
    try {
      _currentOrder = await _service.verifyOrder(orderId, accept, rating: rating);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerWorker(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      _worker = await _service.registerWorker(data);
      _role = 'worker';
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

  Future<void> loadWorkers({String? serviceId}) async {
    _loading = true;
    notifyListeners();
    try {
      _workers = await _service.getWorkers(serviceId: serviceId);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> loadWorkerDetail(String workerId) async {
    try {
      _worker = await _service.getWorkerDetail(workerId);
      notifyListeners();
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<void> loadWorkerCredit() async {
    try {
      _credit = await _service.getWorkerCredit();
      notifyListeners();
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<bool> createDispute(Map<String, dynamic> data) async {
    try {
      _dispute = await _service.createDispute(data);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitEvidence(String disputeId, String evidence) async {
    try {
      await _service.submitEvidence(disputeId, evidence);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadJuryStatus(String disputeId) async {
    try {
      _juryStatus = await _service.getJuryStatus(disputeId);
      notifyListeners();
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<void> loadTrainings({String? category}) async {
    _loading = true;
    notifyListeners();
    try {
      _trainings = await _service.getTrainings(category: category);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> updateWorkerStatus(String status) async {
    try {
      await _service.updateWorkerStatus(status);
      if (_worker != null) {
        _worker = HomeWorker(
          workerId: _worker!.workerId,
          userId: _worker!.userId,
          name: _worker!.name,
          phone: _worker!.phone,
          skills: _worker!.skills,
          certificates: _worker!.certificates,
          deposit: _worker!.deposit,
          authStatus: _worker!.authStatus,
          creditScore: _worker!.creditScore,
          status: status,
          totalIncome: _worker!.totalIncome,
          balance: _worker!.balance,
          completedOrders: _worker!.completedOrders,
        );
      }
      notifyListeners();
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<void> loadWorkerIncome() async {
    try {
      _income = await _service.getWorkerIncome();
      notifyListeners();
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<bool> withdraw(double amount) async {
    try {
      await _service.withdraw(amount);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadFavorites() async {
    try {
      _favorites = await _service.getFavorites();
      notifyListeners();
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<bool> addFavorite(String workerId) async {
    try {
      await _service.addFavorite(workerId);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFavorite(String workerId) async {
    try {
      await _service.removeFavorite(workerId);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
