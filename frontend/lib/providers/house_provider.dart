import 'package:flutter/foundation.dart';
import 'package:dochat_app/models/house_models.dart';
import 'package:dochat_app/services/house_service.dart';

class HouseProvider extends ChangeNotifier {
  final HouseService _service = HouseService();

  List<House> _newHouses = [];
  List<House> _secondHouses = [];
  List<House> _rentHouses = [];
  List<House> _commercialHouses = [];
  House? _currentHouse;
  List<HouseAppointment> _appointments = [];
  List<HouseFavorite> _favorites = [];
  Map<String, dynamic>? _mortgageResult;
  Map<String, dynamic>? _taxResult;
  Map<String, dynamic>? _valuationResult;
  Map<String, dynamic>? _renovationResult;
  List<Map<String, dynamic>> _renovationCompanies = [];
  Map<String, dynamic>? _vipInfo;
  Map<String, dynamic>? _communityInfo;
  bool _loading = false;

  List<House> get newHouses => _newHouses;
  List<House> get secondHouses => _secondHouses;
  List<House> get rentHouses => _rentHouses;
  List<House> get commercialHouses => _commercialHouses;
  House? get currentHouse => _currentHouse;
  List<HouseAppointment> get appointments => _appointments;
  List<HouseFavorite> get favorites => _favorites;
  Map<String, dynamic>? get mortgageResult => _mortgageResult;
  Map<String, dynamic>? get taxResult => _taxResult;
  Map<String, dynamic>? get valuationResult => _valuationResult;
  Map<String, dynamic>? get renovationResult => _renovationResult;
  List<Map<String, dynamic>> get renovationCompanies => _renovationCompanies;
  Map<String, dynamic>? get vipInfo => _vipInfo;
  Map<String, dynamic>? get communityInfo => _communityInfo;
  bool get isLoading => _loading;

  Future<void> loadNewHouses({int page = 0, String? region}) async {
    _loading = true;
    notifyListeners();
    try {
      _newHouses = await _service.getNewHouses(page: page, region: region);
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<void> loadSecondHouses({int page = 0}) async {
    _loading = true;
    notifyListeners();
    try {
      _secondHouses = await _service.getSecondHouses(page: page);
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<void> loadRentHouses({int page = 0, String? subType}) async {
    _loading = true;
    notifyListeners();
    try {
      _rentHouses = await _service.getRentHouses(page: page, subType: subType);
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<void> loadCommercialHouses({int page = 0, String? subType}) async {
    _loading = true;
    notifyListeners();
    try {
      _commercialHouses = await _service.getCommercialHouses(page: page, subType: subType);
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<void> loadHouseDetail(String houseId) async {
    _loading = true;
    notifyListeners();
    try {
      _currentHouse = await _service.getHouseDetail(houseId);
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<bool> publishHouse(Map<String, dynamic> body) async {
    try {
      final house = await _service.publishHouse(body);
      _newHouses = [house, ..._newHouses];
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> toggleFavorite(String houseId) async {
    try {
      await _service.addFavorite(houseId);
    } catch (_) {}
  }

  Future<void> removeFavorite(String houseId) async {
    try {
      await _service.removeFavorite(houseId);
    } catch (_) {}
  }

  Future<bool> createAppointment(Map<String, dynamic> body) async {
    try {
      final appointment = await _service.createAppointment(body);
      _appointments = [appointment, ..._appointments];
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> loadAppointments({int page = 0}) async {
    _loading = true;
    notifyListeners();
    try {
      _appointments = await _service.getAppointments(page: page);
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<void> calculateMortgage(Map<String, dynamic> body) async {
    try {
      _mortgageResult = await _service.calculateMortgage(body);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> calculateTax(Map<String, dynamic> body) async {
    try {
      _taxResult = await _service.calculateTax(body);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> evaluateHouse(Map<String, dynamic> body) async {
    try {
      _valuationResult = await _service.evaluateHouse(body);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> upgradeVip() async {
    try {
      _vipInfo = await _service.upgradeVip();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> renovationEstimate(Map<String, dynamic> body) async {
    try {
      _renovationResult = await _service.renovationEstimate(body);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadRenovationCompanies({int page = 0}) async {
    _loading = true;
    notifyListeners();
    try {
      _renovationCompanies = await _service.getRenovationCompanies(page: page);
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<void> loadCommunityInfo(String houseId) async {
    try {
      _communityInfo = await _service.getCommunityInfo(houseId);
      notifyListeners();
    } catch (_) {}
  }

  void clearCalculationResults() {
    _mortgageResult = null;
    _taxResult = null;
    notifyListeners();
  }
}
