class HomeServiceItem {
  final String serviceId;
  final String name;
  final String category;
  final String subCategory;
  final String? detailCategory;
  final String description;
  final String priceType;
  final double? fixedPrice;
  final double? basePrice;
  final String? unit;
  final List<String> imageUrls;
  final bool active;
  final String createdAt;

  HomeServiceItem({
    required this.serviceId,
    required this.name,
    required this.category,
    required this.subCategory,
    this.detailCategory,
    required this.description,
    required this.priceType,
    this.fixedPrice,
    this.basePrice,
    this.unit,
    required this.imageUrls,
    required this.active,
    required this.createdAt,
  });

  factory HomeServiceItem.fromJson(Map<String, dynamic> json) {
    return HomeServiceItem(
      serviceId: json['serviceId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      subCategory: json['subCategory'] as String? ?? '',
      detailCategory: json['detailCategory'] as String?,
      description: json['description'] as String? ?? '',
      priceType: json['priceType'] as String? ?? 'fixed',
      fixedPrice: (json['fixedPrice'] as num?)?.toDouble(),
      basePrice: (json['basePrice'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      imageUrls: (json['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      active: json['active'] as bool? ?? true,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'name': name,
      'category': category,
      'subCategory': subCategory,
      'detailCategory': detailCategory,
      'description': description,
      'priceType': priceType,
      'fixedPrice': fixedPrice,
      'basePrice': basePrice,
      'unit': unit,
      'imageUrls': imageUrls,
      'active': active,
      'createdAt': createdAt,
    };
  }
}

class HomeCategory {
  final String key;
  final String name;
  final List<HomeCategory> children;

  HomeCategory({
    required this.key,
    required this.name,
    required this.children,
  });

  factory HomeCategory.fromJson(Map<String, dynamic> json) {
    return HomeCategory(
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      children: (json['children'] as List?)
              ?.map((e) => HomeCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'children': children.map((e) => e.toJson()).toList(),
    };
  }
}

class HomeOrder {
  final String orderId;
  final String userId;
  final String? workerId;
  final String serviceId;
  final String address;
  final String appointmentTime;
  final double price;
  final String status;
  final double? rating;
  final String createdAt;

  HomeOrder({
    required this.orderId,
    required this.userId,
    this.workerId,
    required this.serviceId,
    required this.address,
    required this.appointmentTime,
    required this.price,
    required this.status,
    this.rating,
    required this.createdAt,
  });

  factory HomeOrder.fromJson(Map<String, dynamic> json) {
    return HomeOrder(
      orderId: json['orderId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      workerId: json['workerId'] as String?,
      serviceId: json['serviceId'] as String? ?? '',
      address: json['address'] as String? ?? '',
      appointmentTime: json['appointmentTime'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble(),
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'workerId': workerId,
      'serviceId': serviceId,
      'address': address,
      'appointmentTime': appointmentTime,
      'price': price,
      'status': status,
      'rating': rating,
      'createdAt': createdAt,
    };
  }
}

class HomeWorker {
  final String workerId;
  final String userId;
  final String name;
  final String phone;
  final List<String> skills;
  final List<String> certificates;
  final double deposit;
  final String authStatus;
  final double creditScore;
  final String status;
  final double totalIncome;
  final double balance;
  final int completedOrders;

  HomeWorker({
    required this.workerId,
    required this.userId,
    required this.name,
    required this.phone,
    required this.skills,
    required this.certificates,
    required this.deposit,
    required this.authStatus,
    required this.creditScore,
    required this.status,
    required this.totalIncome,
    required this.balance,
    required this.completedOrders,
  });

  factory HomeWorker.fromJson(Map<String, dynamic> json) {
    return HomeWorker(
      workerId: json['workerId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      skills: (json['skills'] as List?)?.map((e) => e.toString()).toList() ?? [],
      certificates: (json['certificates'] as List?)?.map((e) => e.toString()).toList() ?? [],
      deposit: (json['deposit'] as num?)?.toDouble() ?? 0.0,
      authStatus: json['authStatus'] as String? ?? '',
      creditScore: (json['creditScore'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'offline',
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      completedOrders: json['completedOrders'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workerId': workerId,
      'userId': userId,
      'name': name,
      'phone': phone,
      'skills': skills,
      'certificates': certificates,
      'deposit': deposit,
      'authStatus': authStatus,
      'creditScore': creditScore,
      'status': status,
      'totalIncome': totalIncome,
      'balance': balance,
      'completedOrders': completedOrders,
    };
  }
}

class HomeFavorite {
  final String favoriteId;
  final String userId;
  final String workerId;
  final String? workerName;
  final String createdAt;

  HomeFavorite({
    required this.favoriteId,
    required this.userId,
    required this.workerId,
    this.workerName,
    required this.createdAt,
  });

  factory HomeFavorite.fromJson(Map<String, dynamic> json) {
    return HomeFavorite(
      favoriteId: json['favoriteId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      workerId: json['workerId'] as String? ?? '',
      workerName: json['workerName'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favoriteId': favoriteId,
      'userId': userId,
      'workerId': workerId,
      'workerName': workerName,
      'createdAt': createdAt,
    };
  }
}

class HomeDispute {
  final String disputeId;
  final String orderId;
  final String reason;
  final List<String> evidence;
  final String status;
  final String createdAt;

  HomeDispute({
    required this.disputeId,
    required this.orderId,
    required this.reason,
    required this.evidence,
    required this.status,
    required this.createdAt,
  });

  factory HomeDispute.fromJson(Map<String, dynamic> json) {
    return HomeDispute(
      disputeId: json['disputeId'] as String? ?? '',
      orderId: json['orderId'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      evidence: (json['evidence'] as List?)?.map((e) => e.toString()).toList() ?? [],
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disputeId': disputeId,
      'orderId': orderId,
      'reason': reason,
      'evidence': evidence,
      'status': status,
      'createdAt': createdAt,
    };
  }
}

class HomeTraining {
  final String trainingId;
  final String title;
  final String category;
  final String description;
  final String videoUrl;
  final int durationMinutes;
  final bool isCompleted;
  final String createdAt;

  HomeTraining({
    required this.trainingId,
    required this.title,
    required this.category,
    required this.description,
    required this.videoUrl,
    required this.durationMinutes,
    required this.isCompleted,
    required this.createdAt,
  });

  factory HomeTraining.fromJson(Map<String, dynamic> json) {
    return HomeTraining(
      trainingId: json['trainingId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      videoUrl: json['videoUrl'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trainingId': trainingId,
      'title': title,
      'category': category,
      'description': description,
      'videoUrl': videoUrl,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
    };
  }
}
