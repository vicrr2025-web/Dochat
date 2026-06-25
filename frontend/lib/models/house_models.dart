class House {
  final String houseId;
  final String publisherId;
  final String type;
  final String? subType;
  final String? title;
  final String? description;
  final String? priceUnit;
  final String? layout;
  final String? floorInfo;
  final String? direction;
  final String? decoration;
  final String? communityName;
  final String? address;
  final String? images;
  final String? tags;
  final String? status;
  final double? price;
  final double? area;
  final double? longitude;
  final double? latitude;
  final int? viewCount;
  final int? favoriteCount;
  final String? createdAt;
  final String? updatedAt;

  const House({
    required this.houseId,
    required this.publisherId,
    required this.type,
    this.subType,
    this.title,
    this.description,
    this.priceUnit,
    this.layout,
    this.floorInfo,
    this.direction,
    this.decoration,
    this.communityName,
    this.address,
    this.images,
    this.tags,
    this.status,
    this.price,
    this.area,
    this.longitude,
    this.latitude,
    this.viewCount,
    this.favoriteCount,
    this.createdAt,
    this.updatedAt,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      houseId: json['houseId'] as String,
      publisherId: json['publisherId'] as String,
      type: json['type'] as String,
      subType: json['subType'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      area: (json['area'] as num?)?.toDouble(),
      priceUnit: json['priceUnit'] as String?,
      layout: json['layout'] as String?,
      floorInfo: json['floorInfo'] as String?,
      direction: json['direction'] as String?,
      decoration: json['decoration'] as String?,
      communityName: json['communityName'] as String?,
      address: json['address'] as String?,
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      images: json['images'] as String?,
      tags: json['tags'] as String?,
      status: json['status'] as String?,
      viewCount: json['viewCount'] as int?,
      favoriteCount: json['favoriteCount'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'houseId': houseId,
      'publisherId': publisherId,
      'type': type,
      'subType': subType,
      'title': title,
      'description': description,
      'price': price,
      'area': area,
      'priceUnit': priceUnit,
      'layout': layout,
      'floorInfo': floorInfo,
      'direction': direction,
      'decoration': decoration,
      'communityName': communityName,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
      'images': images,
      'tags': tags,
      'status': status,
      'viewCount': viewCount,
      'favoriteCount': favoriteCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class HouseAppointment {
  final String appointmentId;
  final String houseId;
  final String userId;
  final String? appointmentTime;
  final String? contactName;
  final String? contactPhone;
  final String? remark;
  final String? type;
  final String? status;
  final String? createdAt;

  const HouseAppointment({
    required this.appointmentId,
    required this.houseId,
    required this.userId,
    this.appointmentTime,
    this.contactName,
    this.contactPhone,
    this.remark,
    this.type,
    this.status,
    this.createdAt,
  });

  factory HouseAppointment.fromJson(Map<String, dynamic> json) {
    return HouseAppointment(
      appointmentId: json['appointmentId'] as String,
      houseId: json['houseId'] as String,
      userId: json['userId'] as String,
      appointmentTime: json['appointmentTime'] as String?,
      contactName: json['contactName'] as String?,
      contactPhone: json['contactPhone'] as String?,
      remark: json['remark'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'houseId': houseId,
      'userId': userId,
      'appointmentTime': appointmentTime,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'remark': remark,
      'type': type,
      'status': status,
      'createdAt': createdAt,
    };
  }
}

class HouseFavorite {
  final String userId;
  final String houseId;
  final String? createdAt;

  const HouseFavorite({
    required this.userId,
    required this.houseId,
    this.createdAt,
  });

  factory HouseFavorite.fromJson(Map<String, dynamic> json) {
    return HouseFavorite(
      userId: json['userId'] as String,
      houseId: json['houseId'] as String,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'houseId': houseId,
      'createdAt': createdAt,
    };
  }
}

class HouseVip {
  final String vipId;
  final String userId;
  final int? level;
  final String? expiresAt;
  final String? createdAt;

  const HouseVip({
    required this.vipId,
    required this.userId,
    this.level,
    this.expiresAt,
    this.createdAt,
  });

  factory HouseVip.fromJson(Map<String, dynamic> json) {
    return HouseVip(
      vipId: json['vipId'] as String,
      userId: json['userId'] as String,
      level: json['level'] as int?,
      expiresAt: json['expiresAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vipId': vipId,
      'userId': userId,
      'level': level,
      'expiresAt': expiresAt,
      'createdAt': createdAt,
    };
  }
}
