import 'package:flutter/foundation.dart';
import 'package:dochat_app/models/guarantee_models.dart';
import 'package:dochat_app/services/guarantee_service.dart';

class GuaranteeProvider extends ChangeNotifier {
  final GuaranteeService _service = GuaranteeService();

  List<TradeInfo> _trades = [];
  TradeInfo? _currentTrade;
  DisputeInfo? _currentDispute;
  bool _isLoading = false;
  String? _errorMessage;

  List<TradeInfo> get trades => _trades;
  TradeInfo? get currentTrade => _currentTrade;
  DisputeInfo? get currentDispute => _currentDispute;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadTradeList({String? status}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _trades = await _service.getTradeList(status: status);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTradeDetail(String tradeId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentTrade = await _service.getTradeDetail(tradeId);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createTrade(CreateTradeRequest request) async {
    try {
      final trade = await _service.createTrade(request);
      _trades.insert(0, trade);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> confirmTrade(String tradeId) async {
    try {
      await _service.confirmTrade(tradeId);
      await loadTradeDetail(tradeId);
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> freezeFunds(String tradeId) async {
    try {
      await _service.freezeFunds(tradeId);
      await loadTradeDetail(tradeId);
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> initiateVerify(String tradeId) async {
    try {
      await _service.initiateVerify(tradeId);
      await loadTradeDetail(tradeId);
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> releaseFunds(String tradeId) async {
    try {
      await _service.releaseFunds(tradeId);
      await loadTradeDetail(tradeId);
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<DisputeInfo?> createDispute(String tradeId, DisputeRequest request) async {
    try {
      final dispute = await _service.createDispute(tradeId, request);
      _currentDispute = dispute;
      if (_currentTrade != null) {
        _currentTrade = TradeInfo(
          tradeId: _currentTrade!.tradeId,
          buyerId: _currentTrade!.buyerId,
          sellerId: _currentTrade!.sellerId,
          buyerNickname: _currentTrade!.buyerNickname,
          sellerNickname: _currentTrade!.sellerNickname,
          productName: _currentTrade!.productName,
          productDesc: _currentTrade!.productDesc,
          amount: _currentTrade!.amount,
          status: _currentTrade!.status,
          verifyStatus: _currentTrade!.verifyStatus,
          verifyReport: _currentTrade!.verifyReport,
          disputeId: dispute.disputeId,
          sessionId: _currentTrade!.sessionId,
          createdAt: _currentTrade!.createdAt,
        );
      }
      notifyListeners();
      return dispute;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return null;
    }
  }

  Future<void> loadDispute(String tradeId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentDispute = await _service.getDispute(tradeId);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
