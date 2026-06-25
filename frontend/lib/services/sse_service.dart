import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:dochat_app/services/api_service.dart';

class SseService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final Map<String, StreamSubscription<dynamic>> _subscriptions = {};

  Stream<Map<String, dynamic>> subscribe(String sessionId) {
    final controller = StreamController<Map<String, dynamic>>.broadcast(
      onCancel: () {
        _subscriptions[sessionId]?.cancel();
        _subscriptions.remove(sessionId);
      },
    );

    _startConnection(sessionId, controller);

    return controller.stream;
  }

  Future<void> _startConnection(
    String sessionId,
    StreamController<Map<String, dynamic>> controller,
  ) async {
    final token = await _storage.read(key: 'token');
    if (token == null) {
      controller.addError('No auth token');
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
        controller.addError('SSE connection failed: ${response.statusCode}');
        return;
      }

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
              final json = jsonDecode(dataBuffer.toString()) as Map<String, dynamic>;
              json['_event'] = eventType ?? 'message';
              controller.add(json);
            } catch (_) {}

            eventType = null;
            dataBuffer = StringBuffer();
          }
        }
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError('SSE error: $e');
      }
    } finally {
      client.close();
    }
  }

  void unsubscribe(String sessionId) {
    _subscriptions[sessionId]?.cancel();
    _subscriptions.remove(sessionId);
  }

  void dispose() {
    for (final sub in _subscriptions.values) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}
