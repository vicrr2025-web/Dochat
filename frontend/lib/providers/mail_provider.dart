import 'package:flutter/foundation.dart';
import 'package:dochat_app/models/mail_models.dart';
import 'package:dochat_app/services/mail_service.dart';

class MailProvider extends ChangeNotifier {
  final MailService _service = MailService();

  List<MailAccount> _accounts = [];
  MailAccount? _currentAccount;
  List<MailMessage> _messages = [];
  MailMessage? _currentMessage;
  List<MailFolder> _folders = [];
  List<MailFilter> _filters = [];
  List<MailRead> _reads = [];
  bool _loading = false;
  String? _errorMessage;

  List<MailAccount> get accounts => _accounts;
  MailAccount? get currentAccount => _currentAccount;
  List<MailMessage> get messages => _messages;
  MailMessage? get currentMessage => _currentMessage;
  List<MailFolder> get folders => _folders;
  List<MailFilter> get filters => _filters;
  List<MailRead> get reads => _reads;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAccounts() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final data = await _service.getAccounts();
      _accounts = data
          .map((e) => MailAccount.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> addAccount(Map<String, dynamic> data) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.addAccount(data);
      await loadAccounts();
      return true;
    } catch (e) {
      _errorMessage = 'networkError';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAccount(String accountId) async {
    try {
      await _service.deleteAccount(accountId);
      _accounts.removeWhere((a) => a.accountId == accountId);
      if (_currentAccount?.accountId == accountId) {
        _currentAccount = null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  void setCurrentAccount(MailAccount account) {
    _currentAccount = account;
    notifyListeners();
  }

  Future<void> loadMailList(String accountId, String folder,
      {int page = 0, int size = 20}) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final list = await _service.getMailList(accountId, folder,
          page: page, size: size);
      _messages = list
          .map((e) => MailMessage.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> loadMailDetail(String messageId) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final data = await _service.getMailDetail(messageId);
      _currentMessage = MailMessage.fromJson(data);
    } catch (e) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> sendMail(Map<String, dynamic> data) async {
    try {
      await _service.sendMail(data);
      return true;
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> replyMail(Map<String, dynamic> data) async {
    try {
      await _service.replyMail(data);
      return true;
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteMail(String messageId) async {
    try {
      await _service.deleteMail(messageId);
      _messages.removeWhere((m) => m.messageId == messageId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> markMail(Map<String, dynamic> data) async {
    try {
      await _service.markMail(data);
      final messageId = data['messageId'] as String?;
      final action = data['action'] as String?;
      if (messageId != null) {
        final idx = _messages.indexWhere((m) => m.messageId == messageId);
        if (idx != -1) {
          MailMessage updated = _messages[idx];
          switch (action) {
            case 'read':
              updated = updated.copyWith(isRead: true);
              break;
            case 'unread':
              updated = updated.copyWith(isRead: false);
              break;
            case 'star':
              updated = updated.copyWith(isStarred: true);
              break;
            case 'unstar':
              updated = updated.copyWith(isStarred: false);
              break;
          }
          _messages[idx] = updated;
          if (_currentMessage?.messageId == messageId) {
            _currentMessage = updated;
          }
        }
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<void> moveMail(Map<String, dynamic> data) async {
    try {
      await _service.moveMail(data);
      final messageId = data['messageId'] as String?;
      if (messageId != null) {
        _messages.removeWhere((m) => m.messageId == messageId);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<void> loadFolders() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final list = await _service.getFolders();
      _folders = list.map((e) => MailFolder.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> createFolder(String name) async {
    try {
      final data = await _service.createFolder(name);
      _folders.add(MailFolder.fromJson(data));
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteFolder(String folderId) async {
    try {
      await _service.deleteFolder(folderId);
      _folders.removeWhere((f) => f.folderId == folderId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadFilters() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final list = await _service.getFilters();
      _filters = list.map((e) => MailFilter.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      _errorMessage = 'networkError';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> addFilter(Map<String, dynamic> data) async {
    try {
      final result = await _service.addFilter(data);
      _filters.add(MailFilter.fromJson(result));
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadReads({int page = 0, int size = 10}) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final data = await _service.getDailyReads(page: page, size: size);
      final list = data['content'] as List? ?? [];
      _reads = list
          .map((e) => MailRead.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
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
