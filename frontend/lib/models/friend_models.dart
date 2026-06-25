class FriendInfo {
  final String userId;
  final String nickname;
  final String? avatar;
  final String? status;
  final DateTime? createdAt;

  const FriendInfo({
    required this.userId,
    required this.nickname,
    this.avatar,
    this.status,
    this.createdAt,
  });

  factory FriendInfo.fromJson(Map<String, dynamic> json) {
    return FriendInfo(
      userId: json['userId'] as String,
      nickname: json['nickname'] as String? ?? '',
      avatar: json['avatar'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'avatar': avatar,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class FriendRequestInfo {
  final String requestId;
  final String fromUserId;
  final String fromNickname;
  final String? fromAvatar;
  final String? message;
  final String status;
  final DateTime? createdAt;

  const FriendRequestInfo({
    required this.requestId,
    required this.fromUserId,
    required this.fromNickname,
    this.fromAvatar,
    this.message,
    required this.status,
    this.createdAt,
  });

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';

  factory FriendRequestInfo.fromJson(Map<String, dynamic> json) {
    return FriendRequestInfo(
      requestId: json['requestId'] as String,
      fromUserId: json['fromUserId'] as String,
      fromNickname: json['fromNickname'] as String? ?? '',
      fromAvatar: json['fromAvatar'] as String?,
      message: json['message'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'fromUserId': fromUserId,
      'fromNickname': fromNickname,
      'fromAvatar': fromAvatar,
      'message': message,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
