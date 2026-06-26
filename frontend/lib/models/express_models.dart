class ExpressOrder {
  final String orderId;
  final String userId;
  final String? driverId;
  final String type;
  final String? vehicleType;
  final String originAddress;
  final double originLat;
  final double originLng;
  final String destAddress;
  final double destLat;
  final double destLng;
  final String? cargoInfo;
  final double estimatedPrice;
  final double? actualPrice;
  final bool insured;
  final double insuranceFee;
  final String status;
  final double? rating;
  final String createdAt;
  final String? updatedAt;

  ExpressOrder({
    required this.orderId,
    required this.userId,
    this.driverId,
    required this.type,
    this.vehicleType,
    required this.originAddress,
    required this.originLat,
    required this.originLng,
    required this.destAddress,
    required this.destLat,
    required this.destLng,
    this.cargoInfo,
    required this.estimatedPrice,
    this.actualPrice,
    required this.insured,
    required this.insuranceFee,
    required this.status,
    this.rating,
    required this.createdAt,
    this.updatedAt,
  });

  factory ExpressOrder.fromJson(Map<String, dynamic> json) {
    return ExpressOrder(
      orderId: json['orderId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      driverId: json['driverId'] as String?,
      type: json['type'] as String? ?? '',
      vehicleType: json['vehicleType'] as String?,
      originAddress: json['originAddress'] as String? ?? '',
      originLat: (json['originLat'] as num?)?.toDouble() ?? 0.0,
      originLng: (json['originLng'] as num?)?.toDouble() ?? 0.0,
      destAddress: json['destAddress'] as String? ?? '',
      destLat: (json['destLat'] as num?)?.toDouble() ?? 0.0,
      destLng: (json['destLng'] as num?)?.toDouble() ?? 0.0,
      cargoInfo: json['cargoInfo'] as String?,
      estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble() ?? 0.0,
      actualPrice: (json['actualPrice'] as num?)?.toDouble(),
      insured: json['insured'] as bool? ?? false,
      insuranceFee: (json['insuranceFee'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble(),
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'driverId': driverId,
      'type': type,
      'vehicleType': vehicleType,
      'originAddress': originAddress,
      'originLat': originLat,
      'originLng': originLng,
      'destAddress': destAddress,
      'destLat': destLat,
      'destLng': destLng,
      'cargoInfo': cargoInfo,
      'estimatedPrice': estimatedPrice,
      'actualPrice': actualPrice,
      'insured': insured,
      'insuranceFee': insuranceFee,
      'status': status,
      'rating': rating,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class ExpressDriver {
  final String driverId;
  final String userId;
  final String name;
  final String phone;
  final String vehicleType;
  final String vehiclePlate;
  final String authStatus;
  final double creditScore;
  final String status;
  final double? currentLat;
  final double? currentLng;
  final double totalIncome;
  final double balance;

  ExpressDriver({
    required this.driverId,
    required this.userId,
    required this.name,
    required this.phone,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.authStatus,
    required this.creditScore,
    required this.status,
    this.currentLat,
    this.currentLng,
    required this.totalIncome,
    required this.balance,
  });

  factory ExpressDriver.fromJson(Map<String, dynamic> json) {
    return ExpressDriver(
      driverId: json['driverId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      vehicleType: json['vehicleType'] as String? ?? '',
      vehiclePlate: json['vehiclePlate'] as String? ?? '',
      authStatus: json['authStatus'] as String? ?? '',
      creditScore: (json['creditScore'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
      currentLat: (json['currentLat'] as num?)?.toDouble(),
      currentLng: (json['currentLng'] as num?)?.toDouble(),
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'userId': userId,
      'name': name,
      'phone': phone,
      'vehicleType': vehicleType,
      'vehiclePlate': vehiclePlate,
      'authStatus': authStatus,
      'creditScore': creditScore,
      'status': status,
      'currentLat': currentLat,
      'currentLng': currentLng,
      'totalIncome': totalIncome,
      'balance': balance,
    };
  }
}

class ExpressLocation {
  final String orderId;
  final double lat;
  final double lng;
  final String timestamp;

  ExpressLocation({
    required this.orderId,
    required this.lat,
    required this.lng,
    required this.timestamp,
  });

  factory ExpressLocation.fromJson(Map<String, dynamic> json) {
    return ExpressLocation(
      orderId: json['orderId'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'lat': lat,
      'lng': lng,
      'timestamp': timestamp,
    };
  }
}

class ExpressDispute {
  final String disputeId;
  final String orderId;
  final String reason;
  final String evidence;
  final String status;
  final int votesFor;
  final int votesAgainst;
  final String? verdict;
  final String createdAt;

  ExpressDispute({
    required this.disputeId,
    required this.orderId,
    required this.reason,
    required this.evidence,
    required this.status,
    required this.votesFor,
    required this.votesAgainst,
    this.verdict,
    required this.createdAt,
  });

  factory ExpressDispute.fromJson(Map<String, dynamic> json) {
    return ExpressDispute(
      disputeId: json['disputeId'] as String? ?? '',
      orderId: json['orderId'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      evidence: json['evidence'] as String? ?? '',
      status: json['status'] as String? ?? '',
      votesFor: json['votesFor'] as int? ?? 0,
      votesAgainst: json['votesAgainst'] as int? ?? 0,
      verdict: json['verdict'] as String?,
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
      'votesFor': votesFor,
      'votesAgainst': votesAgainst,
      'verdict': verdict,
      'createdAt': createdAt,
    };
  }
}

class ExpressInsurance {
  final String insuranceId;
  final String orderId;
  final String type;
  final double fee;
  final double coverage;
  final String status;
  final String? claimDescription;
  final String? claimStatus;
  final String createdAt;

  ExpressInsurance({
    required this.insuranceId,
    required this.orderId,
    required this.type,
    required this.fee,
    required this.coverage,
    required this.status,
    this.claimDescription,
    this.claimStatus,
    required this.createdAt,
  });

  factory ExpressInsurance.fromJson(Map<String, dynamic> json) {
    return ExpressInsurance(
      insuranceId: json['insuranceId'] as String? ?? '',
      orderId: json['orderId'] as String? ?? '',
      type: json['type'] as String? ?? '',
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      coverage: (json['coverage'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
      claimDescription: json['claimDescription'] as String?,
      claimStatus: json['claimStatus'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'insuranceId': insuranceId,
      'orderId': orderId,
      'type': type,
      'fee': fee,
      'coverage': coverage,
      'status': status,
      'claimDescription': claimDescription,
      'claimStatus': claimStatus,
      'createdAt': createdAt,
    };
  }
}

class ExpressWithdrawal {
  final String withdrawalId;
  final String driverId;
  final double amount;
  final String bankAccount;
  final String status;
  final String createdAt;

  ExpressWithdrawal({
    required this.withdrawalId,
    required this.driverId,
    required this.amount,
    required this.bankAccount,
    required this.status,
    required this.createdAt,
  });

  factory ExpressWithdrawal.fromJson(Map<String, dynamic> json) {
    return ExpressWithdrawal(
      withdrawalId: json['withdrawalId'] as String? ?? '',
      driverId: json['driverId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      bankAccount: json['bankAccount'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'withdrawalId': withdrawalId,
      'driverId': driverId,
      'amount': amount,
      'bankAccount': bankAccount,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
