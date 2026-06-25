class JobResume {
  final String resumeId;
  final String userId;
  final String? name;
  final String? avatar;
  final String? phone;
  final String? email;
  final String? education;
  final String? experience;
  final String? skills;
  final String? intention;
  final String? privacy;
  final String? attachment;
  final String? status;
  final int? exposure;

  const JobResume({
    required this.resumeId,
    required this.userId,
    this.name,
    this.avatar,
    this.phone,
    this.email,
    this.education,
    this.experience,
    this.skills,
    this.intention,
    this.privacy,
    this.attachment,
    this.status,
    this.exposure,
  });

  factory JobResume.fromJson(Map<String, dynamic> json) {
    return JobResume(
      resumeId: json['resumeId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      education: json['education'] as String?,
      experience: json['experience'] as String?,
      skills: json['skills'] as String?,
      intention: json['intention'] as String?,
      privacy: json['privacy'] as String?,
      attachment: json['attachment'] as String?,
      status: json['status'] as String?,
      exposure: json['exposure'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resumeId': resumeId,
      'userId': userId,
      'name': name,
      'avatar': avatar,
      'phone': phone,
      'email': email,
      'education': education,
      'experience': experience,
      'skills': skills,
      'intention': intention,
      'privacy': privacy,
      'attachment': attachment,
      'status': status,
      'exposure': exposure,
    };
  }
}

class JobPosition {
  final String positionId;
  final String companyId;
  final String? companyName;
  final String? title;
  final String? industry;
  final String? city;
  final String? experienceRequired;
  final String? educationRequired;
  final String? description;
  final String? tags;
  final String? status;
  final int? salaryMin;
  final int? salaryMax;
  final int? viewCount;
  final int? applyCount;
  final bool? isBoosted;
  final String? boostExpiresAt;
  final String? createdAt;

  const JobPosition({
    required this.positionId,
    required this.companyId,
    this.companyName,
    this.title,
    this.industry,
    this.city,
    this.experienceRequired,
    this.educationRequired,
    this.description,
    this.tags,
    this.status,
    this.salaryMin,
    this.salaryMax,
    this.viewCount,
    this.applyCount,
    this.isBoosted,
    this.boostExpiresAt,
    this.createdAt,
  });

  factory JobPosition.fromJson(Map<String, dynamic> json) {
    return JobPosition(
      positionId: json['positionId'] as String? ?? '',
      companyId: json['companyId'] as String? ?? '',
      companyName: json['companyName'] as String?,
      title: json['title'] as String?,
      industry: json['industry'] as String?,
      city: json['city'] as String?,
      experienceRequired: json['experienceRequired'] as String?,
      educationRequired: json['educationRequired'] as String?,
      description: json['description'] as String?,
      tags: json['tags'] as String?,
      status: json['status'] as String?,
      salaryMin: json['salaryMin'] as int?,
      salaryMax: json['salaryMax'] as int?,
      viewCount: json['viewCount'] as int?,
      applyCount: json['applyCount'] as int?,
      isBoosted: json['isBoosted'] as bool?,
      boostExpiresAt: json['boostExpiresAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'positionId': positionId,
      'companyId': companyId,
      'companyName': companyName,
      'title': title,
      'industry': industry,
      'city': city,
      'experienceRequired': experienceRequired,
      'educationRequired': educationRequired,
      'description': description,
      'tags': tags,
      'status': status,
      'salaryMin': salaryMin,
      'salaryMax': salaryMax,
      'viewCount': viewCount,
      'applyCount': applyCount,
      'isBoosted': isBoosted,
      'boostExpiresAt': boostExpiresAt,
      'createdAt': createdAt,
    };
  }
}

class JobApplication {
  final String applicationId;
  final String positionId;
  final String userId;
  final String? resumeId;
  final String? status;
  final String? greeting;
  final String? createdAt;

  const JobApplication({
    required this.applicationId,
    required this.positionId,
    required this.userId,
    this.resumeId,
    this.status,
    this.greeting,
    this.createdAt,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      applicationId: json['applicationId'] as String? ?? '',
      positionId: json['positionId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      resumeId: json['resumeId'] as String?,
      status: json['status'] as String?,
      greeting: json['greeting'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applicationId': applicationId,
      'positionId': positionId,
      'userId': userId,
      'resumeId': resumeId,
      'status': status,
      'greeting': greeting,
      'createdAt': createdAt,
    };
  }
}

class JobInterview {
  final String interviewId;
  final String applicationId;
  final String companyUserId;
  final String candidateUserId;
  final String? interviewTime;
  final String? location;
  final String? type;
  final String? status;
  final String? remark;
  final int? candidateRating;
  final int? companyRating;

  const JobInterview({
    required this.interviewId,
    required this.applicationId,
    required this.companyUserId,
    required this.candidateUserId,
    this.interviewTime,
    this.location,
    this.type,
    this.status,
    this.remark,
    this.candidateRating,
    this.companyRating,
  });

  factory JobInterview.fromJson(Map<String, dynamic> json) {
    return JobInterview(
      interviewId: json['interviewId'] as String? ?? '',
      applicationId: json['applicationId'] as String? ?? '',
      companyUserId: json['companyUserId'] as String? ?? '',
      candidateUserId: json['candidateUserId'] as String? ?? '',
      interviewTime: json['interviewTime'] as String?,
      location: json['location'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      remark: json['remark'] as String?,
      candidateRating: json['candidateRating'] as int?,
      companyRating: json['companyRating'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interviewId': interviewId,
      'applicationId': applicationId,
      'companyUserId': companyUserId,
      'candidateUserId': candidateUserId,
      'interviewTime': interviewTime,
      'location': location,
      'type': type,
      'status': status,
      'remark': remark,
      'candidateRating': candidateRating,
      'companyRating': companyRating,
    };
  }
}

class JobCompany {
  final String companyId;
  final String userId;
  final String? name;
  final String? logo;
  final String? industry;
  final String? scale;
  final String? address;
  final String? licenseUrl;
  final String? authStatus;
  final String? description;

  const JobCompany({
    required this.companyId,
    required this.userId,
    this.name,
    this.logo,
    this.industry,
    this.scale,
    this.address,
    this.licenseUrl,
    this.authStatus,
    this.description,
  });

  factory JobCompany.fromJson(Map<String, dynamic> json) {
    return JobCompany(
      companyId: json['companyId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String?,
      logo: json['logo'] as String?,
      industry: json['industry'] as String?,
      scale: json['scale'] as String?,
      address: json['address'] as String?,
      licenseUrl: json['licenseUrl'] as String?,
      authStatus: json['authStatus'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'userId': userId,
      'name': name,
      'logo': logo,
      'industry': industry,
      'scale': scale,
      'address': address,
      'licenseUrl': licenseUrl,
      'authStatus': authStatus,
      'description': description,
    };
  }
}

class JobVip {
  final String vipId;
  final String userId;
  final String? role;
  final int? level;
  final String? expiresAt;

  const JobVip({
    required this.vipId,
    required this.userId,
    this.role,
    this.level,
    this.expiresAt,
  });

  factory JobVip.fromJson(Map<String, dynamic> json) {
    return JobVip(
      vipId: json['vipId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      role: json['role'] as String?,
      level: json['level'] as int?,
      expiresAt: json['expiresAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vipId': vipId,
      'userId': userId,
      'role': role,
      'level': level,
      'expiresAt': expiresAt,
    };
  }
}
