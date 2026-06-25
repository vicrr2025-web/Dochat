class TradeInfo {
  final String tradeId;
  final String buyerId;
  final String sellerId;
  final String buyerNickname;
  final String sellerNickname;
  final String productName;
  final String productDesc;
  final double amount;
  final String status;
  final String verifyStatus;
  final String? verifyReport;
  final String? disputeId;
  final String? sessionId;
  final DateTime createdAt;

  const TradeInfo({
    required this.tradeId,
    required this.buyerId,
    required this.sellerId,
    required this.buyerNickname,
    required this.sellerNickname,
    required this.productName,
    required this.productDesc,
    required this.amount,
    required this.status,
    required this.verifyStatus,
    this.verifyReport,
    this.disputeId,
    this.sessionId,
    required this.createdAt,
  });

  factory TradeInfo.fromJson(Map<String, dynamic> json) {
    return TradeInfo(
      tradeId: json['tradeId'] as String,
      buyerId: json['buyerId'] as String,
      sellerId: json['sellerId'] as String,
      buyerNickname: json['buyerNickname'] as String? ?? '',
      sellerNickname: json['sellerNickname'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      productDesc: json['productDesc'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String? ?? 'pending',
      verifyStatus: json['verifyStatus'] as String? ?? 'none',
      verifyReport: json['verifyReport'] as String?,
      disputeId: json['disputeId'] as String?,
      sessionId: json['sessionId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tradeId': tradeId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'buyerNickname': buyerNickname,
      'sellerNickname': sellerNickname,
      'productName': productName,
      'productDesc': productDesc,
      'amount': amount,
      'status': status,
      'verifyStatus': verifyStatus,
      'verifyReport': verifyReport,
      'disputeId': disputeId,
      'sessionId': sessionId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class DisputeInfo {
  final String disputeId;
  final String tradeId;
  final String initiatorId;
  final String reason;
  final String description;
  final String status;
  final String? verdict;
  final int juryCount;
  final int votesForBuyer;
  final int votesForSeller;

  const DisputeInfo({
    required this.disputeId,
    required this.tradeId,
    required this.initiatorId,
    required this.reason,
    required this.description,
    required this.status,
    this.verdict,
    this.juryCount = 0,
    this.votesForBuyer = 0,
    this.votesForSeller = 0,
  });

  factory DisputeInfo.fromJson(Map<String, dynamic> json) {
    return DisputeInfo(
      disputeId: json['disputeId'] as String,
      tradeId: json['tradeId'] as String,
      initiatorId: json['initiatorId'] as String,
      reason: json['reason'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      verdict: json['verdict'] as String?,
      juryCount: json['juryCount'] as int? ?? 0,
      votesForBuyer: json['votesForBuyer'] as int? ?? 0,
      votesForSeller: json['votesForSeller'] as int? ?? 0,
    );
  }
}

class CreateTradeRequest {
  final String productName;
  final String productDesc;
  final double amount;
  final String counterpartyId;

  const CreateTradeRequest({
    required this.productName,
    required this.productDesc,
    required this.amount,
    required this.counterpartyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productDesc': productDesc,
      'amount': amount,
      'counterpartyId': counterpartyId,
    };
  }
}

class DisputeRequest {
  final String reason;
  final String description;

  const DisputeRequest({
    required this.reason,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'description': description,
    };
  }
}

class ChatSessionResponse {
  final String sessionId;

  const ChatSessionResponse({required this.sessionId});

  factory ChatSessionResponse.fromJson(Map<String, dynamic> json) {
    return ChatSessionResponse(
      sessionId: json['sessionId'] as String,
    );
  }
}
