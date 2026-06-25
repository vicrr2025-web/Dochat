class DatingProfile {
  final String profileId;
  final String userId;
  final String gender;
  final String? birthday;
  final int? height;
  final String? education;
  final String? income;
  final String? maritalStatus;
  final String? avatar;
  final String? photos;
  final String? tags;
  final String? aboutMe;
  final bool realVerified;
  final bool workVerified;
  final bool eduVerified;
  final int charmValue;
  final int loveCoin;
  final int vipLevel;
  final String? vipExpiresAt;
  final String? nickname;
  final int? age;

  const DatingProfile({
    required this.profileId,
    required this.userId,
    required this.gender,
    this.birthday,
    this.height,
    this.education,
    this.income,
    this.maritalStatus,
    this.avatar,
    this.photos,
    this.tags,
    this.aboutMe,
    this.realVerified = false,
    this.workVerified = false,
    this.eduVerified = false,
    this.charmValue = 0,
    this.loveCoin = 0,
    this.vipLevel = 0,
    this.vipExpiresAt,
    this.nickname,
    this.age,
  });

  factory DatingProfile.fromJson(Map<String, dynamic> json) {
    return DatingProfile(
      profileId: json['profileId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      birthday: json['birthday'] as String?,
      height: json['height'] as int?,
      education: json['education'] as String?,
      income: json['income'] as String?,
      maritalStatus: json['maritalStatus'] as String?,
      avatar: json['avatar'] as String?,
      photos: json['photos'] as String?,
      tags: json['tags'] as String?,
      aboutMe: json['aboutMe'] as String?,
      realVerified: json['realVerified'] as bool? ?? false,
      workVerified: json['workVerified'] as bool? ?? false,
      eduVerified: json['eduVerified'] as bool? ?? false,
      charmValue: json['charmValue'] as int? ?? 0,
      loveCoin: json['loveCoin'] as int? ?? 0,
      vipLevel: json['vipLevel'] as int? ?? 0,
      vipExpiresAt: json['vipExpiresAt'] as String?,
      nickname: json['nickname'] as String?,
      age: json['age'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileId': profileId,
      'userId': userId,
      'gender': gender,
      'birthday': birthday,
      'height': height,
      'education': education,
      'income': income,
      'maritalStatus': maritalStatus,
      'avatar': avatar,
      'photos': photos,
      'tags': tags,
      'aboutMe': aboutMe,
      'realVerified': realVerified,
      'workVerified': workVerified,
      'eduVerified': eduVerified,
      'charmValue': charmValue,
      'loveCoin': loveCoin,
      'vipLevel': vipLevel,
      'vipExpiresAt': vipExpiresAt,
      'nickname': nickname,
      'age': age,
    };
  }
}

class DatingNote {
  final String noteId;
  final String fromUserId;
  final String toUserId;
  final String content;
  final bool isRead;
  final String createdAt;
  final String? fromUserName;

  const DatingNote({
    required this.noteId,
    required this.fromUserId,
    required this.toUserId,
    required this.content,
    required this.isRead,
    required this.createdAt,
    this.fromUserName,
  });

  factory DatingNote.fromJson(Map<String, dynamic> json) {
    return DatingNote(
      noteId: json['noteId'] as String? ?? '',
      fromUserId: json['fromUserId'] as String? ?? '',
      toUserId: json['toUserId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      fromUserName: json['fromUserName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noteId': noteId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'content': content,
      'isRead': isRead,
      'createdAt': createdAt,
      'fromUserName': fromUserName,
    };
  }
}

class DatingFeed {
  final String feedId;
  final String userId;
  final String content;
  final String? images;
  final int likeCount;
  final int commentCount;
  final String createdAt;
  final String? userName;
  final String? avatar;
  final bool isLiked;

  const DatingFeed({
    required this.feedId,
    required this.userId,
    required this.content,
    this.images,
    this.likeCount = 0,
    this.commentCount = 0,
    required this.createdAt,
    this.userName,
    this.avatar,
    this.isLiked = false,
  });

  factory DatingFeed.fromJson(Map<String, dynamic> json) {
    return DatingFeed(
      feedId: json['feedId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      images: json['images'] as String?,
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
      userName: json['userName'] as String?,
      avatar: json['avatar'] as String?,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedId': feedId,
      'userId': userId,
      'content': content,
      'images': images,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'createdAt': createdAt,
      'userName': userName,
      'avatar': avatar,
      'isLiked': isLiked,
    };
  }
}

class DatingLive {
  final String liveId;
  final String userId;
  final String status;
  final int viewerCount;
  final int giftValue;
  final String? startedAt;
  final String? endedAt;

  const DatingLive({
    required this.liveId,
    required this.userId,
    required this.status,
    this.viewerCount = 0,
    this.giftValue = 0,
    this.startedAt,
    this.endedAt,
  });

  factory DatingLive.fromJson(Map<String, dynamic> json) {
    return DatingLive(
      liveId: json['liveId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      status: json['status'] as String? ?? 'offline',
      viewerCount: json['viewerCount'] as int? ?? 0,
      giftValue: json['giftValue'] as int? ?? 0,
      startedAt: json['startedAt'] as String?,
      endedAt: json['endedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'liveId': liveId,
      'userId': userId,
      'status': status,
      'viewerCount': viewerCount,
      'giftValue': giftValue,
      'startedAt': startedAt,
      'endedAt': endedAt,
    };
  }
}
