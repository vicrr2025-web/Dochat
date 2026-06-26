class PostInfo {
  final String postId;
  final String userId;
  final String userNickname;
  final String? userAvatar;
  final String? content;
  final String mediaType;
  final List<String> mediaUrls;
  final int? mediaDuration;
  final String? location;
  final String visibility;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLiked;
  final bool isFollowing;
  final String createdAt;

  const PostInfo({
    required this.postId,
    required this.userId,
    required this.userNickname,
    this.userAvatar,
    this.content,
    this.mediaType = 'text',
    this.mediaUrls = const [],
    this.mediaDuration,
    this.location,
    this.visibility = 'public',
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.isLiked = false,
    this.isFollowing = false,
    required this.createdAt,
  });

  factory PostInfo.fromJson(Map<String, dynamic> json) {
    return PostInfo(
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      userNickname: json['userNickname'] as String? ?? '',
      userAvatar: json['userAvatar'] as String?,
      content: json['content'] as String?,
      mediaType: json['mediaType'] as String? ?? 'text',
      mediaUrls: json['mediaUrls'] != null
          ? List<String>.from(json['mediaUrls'] as List)
          : const [],
      mediaDuration: json['mediaDuration'] as int?,
      location: json['location'] as String?,
      visibility: json['visibility'] as String? ?? 'public',
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      shareCount: json['shareCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isFollowing: json['isFollowing'] as bool? ?? false,
      createdAt: (json['createdAt'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'userNickname': userNickname,
      'userAvatar': userAvatar,
      'content': content,
      'mediaType': mediaType,
      'mediaUrls': mediaUrls,
      'mediaDuration': mediaDuration,
      'location': location,
      'visibility': visibility,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'isLiked': isLiked,
      'isFollowing': isFollowing,
      'createdAt': createdAt,
    };
  }

  PostInfo copyWith({
    String? postId,
    String? userId,
    String? userNickname,
    String? userAvatar,
    String? content,
    String? mediaType,
    List<String>? mediaUrls,
    int? mediaDuration,
    String? location,
    String? visibility,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    bool? isLiked,
    bool? isFollowing,
    String? createdAt,
  }) {
    return PostInfo(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userNickname: userNickname ?? this.userNickname,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      mediaType: mediaType ?? this.mediaType,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      mediaDuration: mediaDuration ?? this.mediaDuration,
      location: location ?? this.location,
      visibility: visibility ?? this.visibility,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      isLiked: isLiked ?? this.isLiked,
      isFollowing: isFollowing ?? this.isFollowing,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CommentInfo {
  final String commentId;
  final String userId;
  final String userNickname;
  final String? userAvatar;
  final String content;
  final int likeCount;
  final String? parentId;
  final String? replyToUserId;
  final String createdAt;

  const CommentInfo({
    required this.commentId,
    required this.userId,
    required this.userNickname,
    this.userAvatar,
    required this.content,
    this.likeCount = 0,
    this.parentId,
    this.replyToUserId,
    required this.createdAt,
  });

  factory CommentInfo.fromJson(Map<String, dynamic> json) {
    return CommentInfo(
      commentId: json['commentId'] as String,
      userId: json['userId'] as String,
      userNickname: json['userNickname'] as String? ?? '',
      userAvatar: json['userAvatar'] as String?,
      content: json['content'] as String,
      likeCount: json['likeCount'] as int? ?? 0,
      parentId: json['parentId'] as String?,
      replyToUserId: json['replyToUserId'] as String?,
      createdAt: (json['createdAt'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'userId': userId,
      'userNickname': userNickname,
      'userAvatar': userAvatar,
      'content': content,
      'likeCount': likeCount,
      'parentId': parentId,
      'replyToUserId': replyToUserId,
      'createdAt': createdAt,
    };
  }
}

class PostRequest {
  final String? content;
  final String mediaType;
  final List<String> mediaUrls;
  final int? mediaDuration;
  final String? location;
  final String visibility;

  const PostRequest({
    this.content,
    this.mediaType = 'text',
    this.mediaUrls = const [],
    this.mediaDuration,
    this.location,
    this.visibility = 'public',
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'mediaType': mediaType,
      'mediaUrls': mediaUrls,
      'mediaDuration': mediaDuration,
      'location': location,
      'visibility': visibility,
    };
  }
}

class LikeResult {
  final bool liked;
  final int count;

  const LikeResult({required this.liked, required this.count});

  factory LikeResult.fromJson(Map<String, dynamic> json) {
    return LikeResult(
      liked: json['liked'] as bool,
      count: json['count'] as int,
    );
  }
}

class FollowResult {
  final bool following;

  const FollowResult({required this.following});

  factory FollowResult.fromJson(Map<String, dynamic> json) {
    return FollowResult(
      following: json['following'] as bool,
    );
  }
}
