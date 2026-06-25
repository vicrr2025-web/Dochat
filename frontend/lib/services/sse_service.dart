import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:dochat_app/services/api_service.dart';

class SseService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Map<String, StreamController<Map<String, dynamic>>> _controllers = {};
  final Map<String, int> _retryCount = {};
  static const int maxRetries = 5;
  static const Duration retryDelay = Duration(seconds: 3);

  Stream<Map<String, dynamic>> subscribe(String sessionId) {
    // 如果已有订阅，先取消
    unsubscribe(sessionId);

    final controller = StreamController<Map<String, dynamic>>.broadcast(
      onCancel: () {
        _controllers.remove(sessionId);
        _retryCount.remove(sessionId);
      },
    );

    _controllers[sessionId] = controller;
    _retryCount[sessionId] = 0;
    _startConnection(sessionId);

    return controller.stream;
  }

  Future<void> _startConnection(String sessionId) async {
    final controller = _controllers[sessionId];
    if (controller == null || controller.isClosed) return;

    final token = await _storage.read(key: 'token');
    if (token == null) {
      if (!controller.isClosed) {
        controller.addError('No auth token');
      }
      return;
    }

    final client = HttpClient();
    try {
      final request = await client.getUrl(
        Uri.parse('${ApiService.baseUrl}/v1/sessions/$sessionId/subscribe'),
      );
      request.headers.set('Authorization', 'Bearer $token');
      request.headers.set('Accept', 'text/event-stream');
      request.headers.set('Cache-Control', 'no-cache');

      final response = await request.close();

      if (response.statusCode != 200) {
        _scheduleReconnect(sessionId);
        return;
      }

      // 连接成功，重置重试计数
      _retryCount[sessionId] = 0;

      String? eventType;
      StringBuffer dataBuffer = StringBuffer();

      await for (final chunk in response.transform(utf8.decoder)) {
        final lines = chunk.split('\n');

        for (final line in lines) {
          if (line.startsWith('event:')) {
            eventType = line.substring(6).trim();
          } else if (line.startsWith('data:')) {
            final data = line.substring(5).trim();
            if (dataBuffer.isNotEmpty) {
              dataBuffer.write('\n');
            }
            dataBuffer.write(data);
          } else if (line.isEmpty && dataBuffer.isNotEmpty) {
            try {
              final json =
                  jsonDecode(dataBuffer.toString()) as Map<String, dynamic>;
              json['_event'] = eventType ?? 'message';
              if (!controller.isClosed) {
                controller.add(json);
              }
            } catch (_) {}

            eventType = null;
            dataBuffer = StringBuffer();
          }
        }
      }

      // 连接正常关闭，尝试重连
      _scheduleReconnect(sessionId);
    } catch (e) {
      // 连接异常断开，尝试重连
      _scheduleReconnect(sessionId);
    } finally {
      client.close();
    }
  }

  void _scheduleReconnect(String sessionId) {
    final currentRetries = _retryCount[sessionId] ?? 0;
    if (currentRetries >= maxRetries) {
      _controllers[sessionId]?.close();
      _controllers.remove(sessionId);
      _retryCount.remove(sessionId);
      return;
    }

    _retryCount[sessionId] = currentRetries + 1;
    Future.delayed(retryDelay, () {
      _startConnection(sessionId);
    });
  }

  void unsubscribe(String sessionId) {
    _retryCount.remove(sessionId);
    final controller = _controllers.remove(sessionId);
    if (controller != null && !controller.isClosed) {
      controller.close();
    }
  }

  void dispose() {
    for (final sid in _controllers.keys.toList()) {
      unsubscribe(sid);
    }
  }
}
