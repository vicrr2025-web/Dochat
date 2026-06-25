import 'package:flutter/foundation.dart';

import 'package:dochat_app/models/friend_models.dart';
import 'package:dochat_app/services/friend_service.dart';

class FriendProvider extends ChangeNotifier {
  final FriendService _friendService = FriendService();

  List<FriendInfo> _friends = [];
  List<FriendRequestInfo> _pendingRequests = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  FriendInfo? _searchResult;

  List<FriendInfo> get friends => _friends;
  List<FriendRequestInfo> get pendingRequests => _pendingRequests;
  int get pendingRequestCount => _pendingRequests.where((r) => r.isPending).length;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  FriendInfo? get searchResult => _searchResult;

  Future<void> loadFriends() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _friends = await _friendService.getFriends();
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadPendingRequests() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pendingRequests = await _friendService.getPendingRequests();
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchUser(String phone) async {
    _isSearching = true;
    _searchResult = null;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResult = await _friendService.searchUser(phone);
    } catch (e) {
      _errorMessage = 'userNotFound';
    }

    _isSearching = false;
    notifyListeners();
  }

  Future<bool> sendRequest(String targetUserId, String message) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _friendService.sendFriendRequest(targetUserId, message);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'networkError';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> acceptRequest(String requestId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _friendService.acceptRequest(requestId);
      final idx = _pendingRequests.indexWhere((r) => r.requestId == requestId);
      if (idx != -1) {
        final old = _pendingRequests[idx];
        _pendingRequests[idx] = FriendRequestInfo(
          requestId: old.requestId,
          fromUserId: old.fromUserId,
          fromNickname: old.fromNickname,
          fromAvatar: old.fromAvatar,
          message: old.message,
          status: 'accepted',
          createdAt: old.createdAt,
        );
      }
      await loadFriends();
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> rejectRequest(String requestId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _friendService.rejectRequest(requestId);
      final idx = _pendingRequests.indexWhere((r) => r.requestId == requestId);
      if (idx != -1) {
        final old = _pendingRequests[idx];
        _pendingRequests[idx] = FriendRequestInfo(
          requestId: old.requestId,
          fromUserId: old.fromUserId,
          fromNickname: old.fromNickname,
          fromAvatar: old.fromAvatar,
          message: old.message,
          status: 'rejected',
          createdAt: old.createdAt,
        );
      }
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeFriend(String friendId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _friendService.removeFriend(friendId);
      _friends.removeWhere((f) => f.userId == friendId);
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _searchResult = null;
    _isSearching = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
