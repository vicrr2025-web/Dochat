class PageResponse<T> {
  final List<T> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasMore;

  const PageResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    this.hasMore = false,
  });

  factory PageResponse.fromJson(
    Map<String, dynamic> json, {
    required T Function(Map<String, dynamic>) fromJsonT,
  }) {
    final List<dynamic> contentJson = json['content'] as List<dynamic>;
    return PageResponse(
      content: contentJson
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      page: (json['currentPage'] as int?) ?? (json['page'] as int?) ?? 0,
      size: (json['size'] as int?) ?? 20,
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }
}

class SessionInfo {
  final String sessionId;
  final String type;
  final String name;
  final String? avatar;
  final String? lastMessage;
  final String? lastMessageType;
  final DateTime? lastTime;
  final int unreadCount;
  final bool isPinned;
  final bool isMuted;

  const SessionInfo({
    required this.sessionId,
    required this.type,
    required this.name,
    this.avatar,
    this.lastMessage,
    this.lastMessageType,
    this.lastTime,
    this.unreadCount = 0,
    this.isPinned = false,
    this.isMuted = false,
  });

  factory SessionInfo.fromJson(Map<String, dynamic> json) {
    return SessionInfo(
      sessionId: json['sessionId'] as String,
      type: json['type'] as String,
      name: json['name'] as String? ?? '',
      avatar: json['avatar'] as String?,
      lastMessage: json['lastMessage'] as String?,
      lastMessageType: json['lastMessageType'] as String?,
      lastTime: json['lastTime'] != null
          ? DateTime.tryParse(json['lastTime'] as String)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isPinned: json['isPinned'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'type': type,
      'name': name,
      'avatar': avatar,
      'lastMessage': lastMessage,
      'lastMessageType': lastMessageType,
      'lastTime': lastTime?.toIso8601String(),
      'unreadCount': unreadCount,
      'isPinned': isPinned,
      'isMuted': isMuted,
    };
  }
}

class MessageInfo {
  final String messageId;
  final String sessionId;
  final String senderId;
  final String type;
  final String? content;
  final String? mediaUrl;
  final int? mediaDuration;
  final String? fileName;
  final int? fileSize;
  final String status;
  final bool isRecalled;
  final DateTime sentAt;
  final String currentUserId;

  const MessageInfo({
    required this.messageId,
    required this.sessionId,
    required this.senderId,
    required this.type,
    this.content,
    this.mediaUrl,
    this.mediaDuration,
    this.fileName,
    this.fileSize,
    this.status = 'sent',
    this.isRecalled = false,
    required this.sentAt,
    required this.currentUserId,
  });

  bool get isMine => senderId == currentUserId;

  factory MessageInfo.fromJson(Map<String, dynamic> json, {required String currentUserId}) {
    return MessageInfo(
      messageId: json['messageId'] as String,
      sessionId: json['sessionId'] as String,
      senderId: json['senderId'] as String,
      type: json['type'] as String? ?? 'text',
      content: json['content'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      mediaDuration: json['mediaDuration'] as int?,
      fileName: json['fileName'] as String?,
      fileSize: json['fileSize'] as int?,
      status: json['status'] as String? ?? 'sent',
      isRecalled: json['isRecalled'] as bool? ?? false,
      sentAt: DateTime.parse(json['sentAt'] as String),
      currentUserId: currentUserId,
    );
  }
}

class CreateSessionRequest {
  final String targetUserId;

  const CreateSessionRequest({required this.targetUserId});

  Map<String, dynamic> toJson() => {'targetUserId': targetUserId};
}

class SendMessageRequest {
  final String sessionId;
  final String type;
  final String? content;
  final String? mediaUrl;
  final int? mediaDuration;
  final String? fileName;
  final int? fileSize;

  const SendMessageRequest({
    required this.sessionId,
    required this.type,
    this.content,
    this.mediaUrl,
    this.mediaDuration,
    this.fileName,
    this.fileSize,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'sessionId': sessionId,
      'type': type,
    };
    if (content != null) map['content'] = content;
    if (mediaUrl != null) map['mediaUrl'] = mediaUrl;
    if (mediaDuration != null) map['mediaDuration'] = mediaDuration;
    if (fileName != null) map['fileName'] = fileName;
    if (fileSize != null) map['fileSize'] = fileSize;
    return map;
  }
}
