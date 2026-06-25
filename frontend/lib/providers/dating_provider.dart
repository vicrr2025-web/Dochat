import 'package:flutter/foundation.dart';
import 'package:dochat_app/models/dating_models.dart';
import 'package:dochat_app/services/dating_service.dart';

class DatingProvider extends ChangeNotifier {
  final _service = DatingService();

  DatingProfile? _profile;
  List<DatingProfile> _recommendations = [];
  List<DatingNote> _notes = [];
  List<DatingFeed> _feeds = [];
  DatingLive? _currentLive;
  bool _loading = false;
  String? _errorMessage;

  DatingProfile? get profile => _profile;
  List<DatingProfile> get recommendations => _recommendations;
  List<DatingNote> get notes => _notes;
  List<DatingFeed> get feeds => _feeds;
  DatingLive? get currentLive => _currentLive;
  bool get isLoading => _loading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProfile() async {
    _loading = true;
    notifyListeners();
    try {
      _profile = await _service.getProfile();
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> updateProfile(Map<String, dynamic> body) async {
    try {
      _profile = await _service.updateProfile(body);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadRecommendations({int page = 0}) async {
    _loading = true;
    notifyListeners();
    try {
      if (page == 0) _recommendations = [];
      final newRecs = await _service.getRecommendations(page: page);
      _recommendations.addAll(newRecs);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> likeUser(String toUserId) async {
    try {
      final result = await _service.like(toUserId);
      notifyListeners();
      return result;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> superLikeUser(String toUserId) async {
    try {
      final result = await _service.superLike(toUserId);
      notifyListeners();
      return result;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return null;
    }
  }

  Future<void> loadNotes() async {
    _loading = true;
    notifyListeners();
    try {
      _notes = await _service.getNotes();
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> sendNote(String toUserId, String content) async {
    try {
      final note = await _service.sendNote(toUserId, content);
      _notes.insert(0, note);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadFeeds({int page = 0}) async {
    _loading = true;
    notifyListeners();
    try {
      if (page == 0) _feeds = [];
      final newFeeds = await _service.getFeeds(page: page);
      _feeds.addAll(newFeeds);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> createFeed(String content, [String? images]) async {
    try {
      final feed = await _service.createFeed(content, images);
      _feeds.insert(0, feed);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleFeedLike(String feedId) async {
    try {
      await _service.toggleFeedLike(feedId);
      final idx = _feeds.indexWhere((f) => f.feedId == feedId);
      if (idx >= 0) {
        final current = _feeds[idx];
        _feeds[idx] = DatingFeed(
          feedId: current.feedId,
          userId: current.userId,
          content: current.content,
          images: current.images,
          likeCount: current.isLiked ? current.likeCount - 1 : current.likeCount + 1,
          commentCount: current.commentCount,
          createdAt: current.createdAt,
          userName: current.userName,
          avatar: current.avatar,
          isLiked: !current.isLiked,
        );
        notifyListeners();
      }
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> startLive() async {
    try {
      _currentLive = await _service.startLive();
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> endLive() async {
    try {
      await _service.endLive();
      _currentLive = null;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendGift(String toUserId, String giftType) async {
    try {
      await _service.sendGift(toUserId, giftType);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> recharge(int amount) async {
    try {
      final result = await _service.recharge(amount);
      if (_profile != null) {
        _profile = DatingProfile(
          profileId: _profile!.profileId,
          userId: _profile!.userId,
          gender: _profile!.gender,
          birthday: _profile!.birthday,
          height: _profile!.height,
          education: _profile!.education,
          income: _profile!.income,
          maritalStatus: _profile!.maritalStatus,
          avatar: _profile!.avatar,
          photos: _profile!.photos,
          tags: _profile!.tags,
          aboutMe: _profile!.aboutMe,
          realVerified: _profile!.realVerified,
          workVerified: _profile!.workVerified,
          eduVerified: _profile!.eduVerified,
          charmValue: _profile!.charmValue,
          loveCoin: (result['loveCoin'] as int?) ?? _profile!.loveCoin,
          vipLevel: _profile!.vipLevel,
          vipExpiresAt: _profile!.vipExpiresAt,
          nickname: _profile!.nickname,
          age: _profile!.age,
        );
        notifyListeners();
      }
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> upgradeVip(int months) async {
    try {
      final result = await _service.upgradeVip(months);
      if (_profile != null) {
        _profile = DatingProfile(
          profileId: _profile!.profileId,
          userId: _profile!.userId,
          gender: _profile!.gender,
          birthday: _profile!.birthday,
          height: _profile!.height,
          education: _profile!.education,
          income: _profile!.income,
          maritalStatus: _profile!.maritalStatus,
          avatar: _profile!.avatar,
          photos: _profile!.photos,
          tags: _profile!.tags,
          aboutMe: _profile!.aboutMe,
          realVerified: _profile!.realVerified,
          workVerified: _profile!.workVerified,
          eduVerified: _profile!.eduVerified,
          charmValue: _profile!.charmValue,
          loveCoin: _profile!.loveCoin,
          vipLevel: (result['vipLevel'] as int?) ?? _profile!.vipLevel,
          vipExpiresAt: (result['vipExpiresAt'] as String?) ?? _profile!.vipExpiresAt,
          nickname: _profile!.nickname,
          age: _profile!.age,
        );
        notifyListeners();
      }
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> superBoost() async {
    try {
      await _service.superBoost();
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> authReal() async {
    try {
      await _service.authReal();
      await loadProfile();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> authWork() async {
    try {
      await _service.authWork();
      await loadProfile();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> authEdu() async {
    try {
      await _service.authEdu();
      await loadProfile();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> charmWithdraw(int amount) async {
    try {
      await _service.charmWithdraw(amount);
      await loadProfile();
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
