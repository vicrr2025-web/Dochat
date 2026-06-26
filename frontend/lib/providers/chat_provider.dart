import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:dochat_app/models/chat_models.dart';
import 'package:dochat_app/services/chat_service.dart';
import 'package:dochat_app/services/sse_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final SseService _sseService = SseService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  List<SessionInfo> _sessions = [];
  final Map<String, List<MessageInfo>> _messagesCache = {};
  bool _isLoadingSessions = false;
  bool _isLoadingMessages = false;
  bool _isSending = false;
  bool _hasMoreSessions = true;
  bool _hasMoreMessages = true;
  String? _errorMessage;
  String? _currentSessionId;
  String _currentUserId = '';
  StreamSubscription<dynamic>? _sseSubscription;

  List<SessionInfo> get sessions => _sessions;
  Map<String, List<MessageInfo>> get messagesCache => _messagesCache;
  bool get isLoadingSessions => _isLoadingSessions;
  bool get isLoadingMessages => _isLoadingMessages;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;
  String? get currentSessionId => _currentSessionId;
  String get currentUserId => _currentUserId;

  List<MessageInfo> messagesForSession(String sessionId) =>
      _messagesCache[sessionId] ?? [];

  Future<void> _loadUserId() async {
    _currentUserId = await _storage.read(key: 'userId') ?? '';
  }

  Future<void> loadSessions({int page = 0}) async {
    if (_isLoadingSessions) return;
    _isLoadingSessions = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_currentUserId.isEmpty) await _loadUserId();
      final result = await _chatService.getSessions(page: page);
      if (page == 0) {
        _sessions = result.content;
      } else {
        _sessions.addAll(result.content);
      }
      _hasMoreSessions = result.page < result.totalPages - 1;
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoadingSessions = false;
    notifyListeners();
  }

  Future<void> loadMessages(
    String sessionId, {
    String? before,
  }) async {
    if (_isLoadingMessages) return;
    _isLoadingMessages = true;
    notifyListeners();

    try {
      if (_currentUserId.isEmpty) await _loadUserId();
      final result = await _chatService.getMessages(
        sessionId,
        beforeMessageId: before,
        currentUserId: _currentUserId,
      );

      if (before != null) {
        final existing = _messagesCache[sessionId] ?? [];
        existing.insertAll(0, result.content);
        _messagesCache[sessionId] = existing;
      } else {
        _messagesCache[sessionId] = result.content;
      }
      _hasMoreMessages = result.page < result.totalPages - 1;
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoadingMessages = false;
    notifyListeners();
  }

  Future<void> sendMessage(SendMessageRequest request) async {
    _isSending = true;
    notifyListeners();

    // Optimistic update: insert temp message
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMsg = MessageInfo(
      messageId: tempId,
      sessionId: request.sessionId,
      senderId: _currentUserId,
      currentUserId: _currentUserId,
      type: request.type,
      content: request.content,
      status: 'sending',
      sentAt: DateTime.now(),
    );
    _addMessageToCache(request.sessionId, tempMsg);

    try {
      if (_currentUserId.isEmpty) await _loadUserId();
      
      // Upload media files first if present
      var updatedRequest = request;
      if (request.mediaUrl != null && request.mediaUrl!.isNotEmpty && !request.mediaUrl!.startsWith('http')) {
        final uploadedUrl = await _chatService.uploadFile(request.mediaUrl!);
        updatedRequest = SendMessageRequest(
          sessionId: request.sessionId,
          type: request.type,
          content: request.content,
          mediaUrl: uploadedUrl,
          mediaDuration: request.mediaDuration,
        );
      }
      
      final message = await _chatService.sendMessage(
        updatedRequest,
        currentUserId: _currentUserId,
      );
      // Replace temp message with real one
      final messages = _messagesCache[request.sessionId] ?? [];
      final idx = messages.indexWhere((m) => m.messageId == tempId);
      if (idx != -1) {
        messages[idx] = message;
        _messagesCache[request.sessionId] = messages;
      }
    } catch (e) {
      // Remove temp message on failure
      final messages = _messagesCache[request.sessionId] ?? [];
      messages.removeWhere((m) => m.messageId == tempId);
      _errorMessage = 'sendFailed';
    }

    _isSending = false;
    notifyListeners();
  }

  Future<void> revokeMessage(String messageId) async {
    try {
      await _chatService.revokeMessage(messageId);

      for (final sessionId in _messagesCache.keys) {
        final messages = _messagesCache[sessionId]!;
        final index = messages.indexWhere((m) => m.messageId == messageId);
        if (index != -1) {
          final old = messages[index];
          messages[index] = MessageInfo(
            messageId: old.messageId,
            sessionId: old.sessionId,
            senderId: old.senderId,
            type: old.type,
            content: null,
            status: 'revoked',
            isRecalled: true,
            sentAt: old.sentAt,
            currentUserId: _currentUserId,
          );
          _messagesCache[sessionId] = messages;
          notifyListeners();
          break;
        }
      }
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<void> markAsRead(String sessionId, String lastMessageId) async {
    if (sessionId.isEmpty) return;
    try {
      await _chatService.markRead(sessionId, lastMessageId);
    } catch (_) {}
  }

  Future<SessionInfo> createSession(String targetUserId) async {
    try {
      if (_currentUserId.isEmpty) await _loadUserId();
      final session = await _chatService.createSession(targetUserId);
      _sessions.insert(0, session);
      notifyListeners();
      return session;
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> pinSession(String sessionId, bool pinned) async {
    try {
      await _chatService.pinSession(sessionId, pinned);
      final idx = _sessions.indexWhere((s) => s.sessionId == sessionId);
      if (idx != -1) {
        final old = _sessions[idx];
        _sessions[idx] = SessionInfo(
          sessionId: old.sessionId,
          type: old.type,
          name: old.name,
          avatar: old.avatar,
          lastMessage: old.lastMessage,
          lastMessageType: old.lastMessageType,
          lastTime: old.lastTime,
          unreadCount: old.unreadCount,
          isPinned: pinned,
          isMuted: old.isMuted,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<void> muteSession(String sessionId, bool muted, {int? duration}) async {
    try {
      await _chatService.muteSession(sessionId, muted, duration: duration);
      final idx = _sessions.indexWhere((s) => s.sessionId == sessionId);
      if (idx != -1) {
        final old = _sessions[idx];
        _sessions[idx] = SessionInfo(
          sessionId: old.sessionId,
          type: old.type,
          name: old.name,
          avatar: old.avatar,
          lastMessage: old.lastMessage,
          lastMessageType: old.lastMessageType,
          lastTime: old.lastTime,
          unreadCount: old.unreadCount,
          isPinned: old.isPinned,
          isMuted: muted,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      await _chatService.deleteSession(sessionId);
      _sessions.removeWhere((s) => s.sessionId == sessionId);
      _messagesCache.remove(sessionId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  void subscribeToSession(String sessionId) {
    _currentSessionId = sessionId;
    _sseSubscription = _sseService.subscribe(sessionId).listen(
      (event) {
        final eventType = event['_event'] as String? ?? 'message';
        if (eventType == 'message') {
          final message = MessageInfo.fromJson(event, currentUserId: _currentUserId);
          onNewMessage(message);
        }
      },
      onError: (_) {},
    );
  }

  void unsubscribeFromSession(String sessionId) {
    _sseService.unsubscribe(sessionId);
    _sseSubscription?.cancel();
    _sseSubscription = null;
    _currentSessionId = null;
  }

  void onNewMessage(MessageInfo message) {
    final sessionMessages = _messagesCache[message.sessionId] ?? [];
    final exists = sessionMessages.any((m) => m.messageId == message.messageId);
    if (!exists) {
      sessionMessages.add(message);
      _messagesCache[message.sessionId] = sessionMessages;

      final idx = _sessions.indexWhere(
        (s) => s.sessionId == message.sessionId,
      );
      if (idx != -1) {
        final old = _sessions[idx];
        _sessions[idx] = SessionInfo(
          sessionId: old.sessionId,
          type: old.type,
          name: old.name,
          avatar: old.avatar,
          lastMessage: message.content ?? message.type,
          lastMessageType: message.type,
          lastTime: message.sentAt,
          unreadCount: message.sessionId != _currentSessionId ? old.unreadCount + 1 : old.unreadCount,
          isPinned: old.isPinned,
          isMuted: old.isMuted,
        );
      }
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _addMessageToCache(String sessionId, MessageInfo message) {
    final messages = _messagesCache[sessionId] ?? [];
    messages.add(message);
    _messagesCache[sessionId] = messages;
  }

  @override
  void dispose() {
    _sseSubscription?.cancel();
    _sseService.dispose();
    super.dispose();
  }
}
