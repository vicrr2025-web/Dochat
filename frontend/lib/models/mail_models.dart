class MailAccount {
  final String accountId;
  final String userId;
  final String? email;
  final String? provider;
  final String? imapHost;
  final String? smtpHost;
  final String? displayName;
  final String? status;
  final int? imapPort;
  final int? smtpPort;
  final bool? isDefault;
  final String? createdAt;

  const MailAccount({
    required this.accountId,
    required this.userId,
    this.email,
    this.provider,
    this.imapHost,
    this.smtpHost,
    this.displayName,
    this.status,
    this.imapPort,
    this.smtpPort,
    this.isDefault,
    this.createdAt,
  });

  factory MailAccount.fromJson(Map<String, dynamic> json) {
    return MailAccount(
      accountId: json['accountId'] as String,
      userId: json['userId'] as String,
      email: json['email'] as String?,
      provider: json['provider'] as String?,
      imapHost: json['imapHost'] as String?,
      smtpHost: json['smtpHost'] as String?,
      displayName: json['displayName'] as String?,
      status: json['status'] as String?,
      imapPort: json['imapPort'] as int?,
      smtpPort: json['smtpPort'] as int?,
      isDefault: json['isDefault'] as bool?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'userId': userId,
      'email': email,
      'provider': provider,
      'imapHost': imapHost,
      'smtpHost': smtpHost,
      'displayName': displayName,
      'status': status,
      'imapPort': imapPort,
      'smtpPort': smtpPort,
      'isDefault': isDefault,
      'createdAt': createdAt,
    };
  }
}

class MailMessage {
  final String messageId;
  final String accountId;
  final String? folder;
  final String? sender;
  final String? recipients;
  final String? subject;
  final String? body;
  final String? attachments;
  final String? messageUid;
  final bool? isRead;
  final bool? isStarred;
  final bool? hasAttachments;
  final String? receivedAt;
  final String? createdAt;

  const MailMessage({
    required this.messageId,
    required this.accountId,
    this.folder,
    this.sender,
    this.recipients,
    this.subject,
    this.body,
    this.attachments,
    this.messageUid,
    this.isRead,
    this.isStarred,
    this.hasAttachments,
    this.receivedAt,
    this.createdAt,
  });

  factory MailMessage.fromJson(Map<String, dynamic> json) {
    return MailMessage(
      messageId: json['messageId'] as String,
      accountId: json['accountId'] as String,
      folder: json['folder'] as String?,
      sender: json['sender'] as String?,
      recipients: json['recipients'] as String?,
      subject: json['subject'] as String?,
      body: json['body'] as String?,
      attachments: json['attachments'] as String?,
      messageUid: json['messageUid'] as String?,
      isRead: json['isRead'] as bool?,
      isStarred: json['isStarred'] as bool?,
      hasAttachments: json['hasAttachments'] as bool?,
      receivedAt: json['receivedAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'accountId': accountId,
      'folder': folder,
      'sender': sender,
      'recipients': recipients,
      'subject': subject,
      'body': body,
      'attachments': attachments,
      'messageUid': messageUid,
      'isRead': isRead,
      'isStarred': isStarred,
      'hasAttachments': hasAttachments,
      'receivedAt': receivedAt,
      'createdAt': createdAt,
    };
  }

  MailMessage copyWith({
    String? messageId,
    String? accountId,
    String? folder,
    String? sender,
    String? recipients,
    String? subject,
    String? body,
    String? attachments,
    String? messageUid,
    bool? isRead,
    bool? isStarred,
    bool? hasAttachments,
    String? receivedAt,
    String? createdAt,
  }) {
    return MailMessage(
      messageId: messageId ?? this.messageId,
      accountId: accountId ?? this.accountId,
      folder: folder ?? this.folder,
      sender: sender ?? this.sender,
      recipients: recipients ?? this.recipients,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      attachments: attachments ?? this.attachments,
      messageUid: messageUid ?? this.messageUid,
      isRead: isRead ?? this.isRead,
      isStarred: isStarred ?? this.isStarred,
      hasAttachments: hasAttachments ?? this.hasAttachments,
      receivedAt: receivedAt ?? this.receivedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class MailFolder {
  final String folderId;
  final String userId;
  final String? name;
  final String? icon;
  final int? sortOrder;

  const MailFolder({
    required this.folderId,
    required this.userId,
    this.name,
    this.icon,
    this.sortOrder,
  });

  factory MailFolder.fromJson(Map<String, dynamic> json) {
    return MailFolder(
      folderId: json['folderId'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String?,
      icon: json['icon'] as String?,
      sortOrder: json['sortOrder'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'folderId': folderId,
      'userId': userId,
      'name': name,
      'icon': icon,
      'sortOrder': sortOrder,
    };
  }
}

class MailFilter {
  final String filterId;
  final String userId;
  final String? type;
  final String? addressPattern;

  const MailFilter({
    required this.filterId,
    required this.userId,
    this.type,
    this.addressPattern,
  });

  factory MailFilter.fromJson(Map<String, dynamic> json) {
    return MailFilter(
      filterId: json['filterId'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String?,
      addressPattern: json['addressPattern'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filterId': filterId,
      'userId': userId,
      'type': type,
      'addressPattern': addressPattern,
    };
  }
}

class MailRead {
  final String readId;
  final String userId;
  final String? articleId;
  final String? title;
  final String? source;
  final String? url;
  final bool? isFavorited;
  final String? readAt;

  const MailRead({
    required this.readId,
    required this.userId,
    this.articleId,
    this.title,
    this.source,
    this.url,
    this.isFavorited,
    this.readAt,
  });

  factory MailRead.fromJson(Map<String, dynamic> json) {
    return MailRead(
      readId: json['readId'] as String,
      userId: json['userId'] as String,
      articleId: json['articleId'] as String?,
      title: json['title'] as String?,
      source: json['source'] as String?,
      url: json['url'] as String?,
      isFavorited: json['isFavorited'] as bool?,
      readAt: json['readAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'readId': readId,
      'userId': userId,
      'articleId': articleId,
      'title': title,
      'source': source,
      'url': url,
      'isFavorited': isFavorited,
      'readAt': readAt,
    };
  }
}
