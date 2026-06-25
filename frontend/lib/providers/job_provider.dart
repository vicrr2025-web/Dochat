import 'package:flutter/foundation.dart';
import 'package:dochat_app/models/job_models.dart';
import 'package:dochat_app/services/job_service.dart';

class JobProvider extends ChangeNotifier {
  final _service = JobService();

  JobResume? _resume;
  List<JobPosition> _positions = [];
  List<JobApplication> _applications = [];
  List<JobInterview> _interviews = [];
  JobCompany? _company;
  JobVip? _vip;
  String _role = 'candidate';
  bool _loading = false;
  String? _errorMessage;

  JobResume? get resume => _resume;
  List<JobPosition> get positions => _positions;
  List<JobApplication> get applications => _applications;
  List<JobInterview> get interviews => _interviews;
  JobCompany? get company => _company;
  JobVip? get vip => _vip;
  String get role => _role;
  bool get isLoading => _loading;
  String? get errorMessage => _errorMessage;

  void toggleRole() {
    _role = _role == 'candidate' ? 'recruiter' : 'candidate';
    notifyListeners();
  }

  Future<void> loadResume() async {
    _loading = true;
    notifyListeners();
    try {
      _resume = await _service.getResume();
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> saveResume(Map<String, dynamic> body) async {
    try {
      _resume = await _service.createOrUpdateResume(body);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadPositions({int page = 0, String? keyword, String? city, String? industry}) async {
    _loading = true;
    notifyListeners();
    try {
      if (page == 0) _positions = [];
      final newPos = await _service.searchPositions(
        page: page,
        keyword: keyword,
        city: city,
        industry: industry,
      );
      _positions.addAll(newPos);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> applyPosition(String positionId, String greeting) async {
    try {
      await _service.applyPosition(positionId, greeting);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> publishPosition(Map<String, dynamic> body) async {
    try {
      await _service.publishPosition(body);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadApplications() async {
    _loading = true;
    notifyListeners();
    try {
      final apps = await _service.getApplications();
      // applications are returned as List<dynamic> from server
      _applications = apps.map((a) => JobApplication(
        applicationId: a['applicationId'] ?? '',
        positionId: a['positionId'] ?? '',
        userId: a['userId'] ?? '',
        resumeId: a['resumeId'],
        status: a['status'] ?? 'applied',
        greeting: a['greeting'],
        createdAt: a['createdAt'],
      )).toList();
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<void> loadMessages() async {
    _loading = true;
    notifyListeners();
    try {
      await _service.getMessages();
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<void> loadCandidates(String positionId, {int page = 0}) async {
    _loading = true;
    notifyListeners();
    try {
      if (page == 0) _applications = [];
      final newCandidates = await _service.getCandidates(positionId, page: page);
      _applications.addAll(newCandidates);
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> toggleFavoriteResume(String resumeId) async {
    try {
      await _service.toggleFavoriteResume(resumeId);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendGreeting(String toUserId, String content) async {
    try {
      await _service.sendGreeting(toUserId, content);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadInterviews() async {
    _loading = true;
    notifyListeners();
    try {
      _interviews = await _service.getInterviews();
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> scheduleInterview(Map<String, dynamic> body) async {
    try {
      await _service.scheduleInterview(body);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadCompany() async {
    _loading = true;
    notifyListeners();
    try {
      // Company is loaded as part of getResume or separately
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> companyAuth(Map<String, dynamic> body) async {
    try {
      await _service.companyAuth(body);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> buyBoost(String positionId) async {
    try {
      await _service.buyBoost(positionId);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> aiBatchInvite(String positionId, List<String> resumeIds) async {
    try {
      await _service.aiBatchInvite(positionId, resumeIds);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> buyExpertService(String serviceType) async {
    try {
      await _service.buyExpertService(serviceType);
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
