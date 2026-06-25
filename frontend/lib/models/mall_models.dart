class ProductInfo {
  final String id;
  final String title;
  final String desc;
  final double price;
  final List<String> images;
  final String category;
  final String sellerId;
  final String shopId;
  final String status;
  final int stock;
  final DateTime createdAt;

  const ProductInfo({
    required this.id,
    required this.title,
    required this.desc,
    required this.price,
    required this.images,
    required this.category,
    required this.sellerId,
    required this.shopId,
    required this.status,
    required this.stock,
    required this.createdAt,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      category: json['category'] as String? ?? '',
      sellerId: json['sellerId'] as String? ?? '',
      shopId: json['shopId'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      stock: json['stock'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'price': price,
      'images': images,
      'category': category,
      'sellerId': sellerId,
      'shopId': shopId,
      'status': status,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class CartItemInfo {
  final String id;
  final String productId;
  final String title;
  final double price;
  final String image;
  int qty;
  bool selected;

  CartItemInfo({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    this.qty = 1,
    this.selected = true,
  });

  factory CartItemInfo.fromJson(Map<String, dynamic> json) {
    return CartItemInfo(
      id: json['id'] as String,
      productId: json['productId'] as String,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] as String? ?? '',
      qty: json['qty'] as int? ?? 1,
      selected: json['selected'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'qty': qty,
      'selected': selected,
    };
  }
}

class OrderInfo {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int qty;
  final String status;
  final String? trackingNo;
  final String? sellerId;
  final String? buyerId;
  final String? sessionId;
  final DateTime createdAt;

  const OrderInfo({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.qty,
    required this.status,
    this.trackingNo,
    this.sellerId,
    this.buyerId,
    this.sessionId,
    required this.createdAt,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
      id: json['id'] as String,
      productId: json['productId'] as String,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      qty: json['qty'] as int? ?? 1,
      status: json['status'] as String? ?? 'toPay',
      trackingNo: json['trackingNo'] as String?,
      sellerId: json['sellerId'] as String?,
      buyerId: json['buyerId'] as String?,
      sessionId: json['sessionId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'price': price,
      'qty': qty,
      'status': status,
      'trackingNo': trackingNo,
      'sellerId': sellerId,
      'buyerId': buyerId,
      'sessionId': sessionId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ReviewInfo {
  final String id;
  final String orderId;
  final int rating;
  final String content;
  final String reviewerId;

  const ReviewInfo({
    required this.id,
    required this.orderId,
    required this.rating,
    required this.content,
    required this.reviewerId,
  });

  factory ReviewInfo.fromJson(Map<String, dynamic> json) {
    return ReviewInfo(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      rating: json['rating'] as int? ?? 5,
      content: json['content'] as String? ?? '',
      reviewerId: json['reviewerId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'rating': rating,
      'content': content,
      'reviewerId': reviewerId,
    };
  }
}

class ShopInfo {
  final String id;
  final String name;
  final String logo;
  final String status;

  const ShopInfo({
    required this.id,
    required this.name,
    required this.logo,
    required this.status,
  });

  factory ShopInfo.fromJson(Map<String, dynamic> json) {
    return ShopInfo(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'status': status,
    };
  }
}

class CouponInfo {
  final String id;
  final String title;
  final double discount;
  final double minAmount;
  final DateTime expiresAt;

  const CouponInfo({
    required this.id,
    required this.title,
    required this.discount,
    required this.minAmount,
    required this.expiresAt,
  });

  factory CouponInfo.fromJson(Map<String, dynamic> json) {
    return CouponInfo(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      minAmount: (json['minAmount'] as num?)?.toDouble() ?? 0.0,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'discount': discount,
      'minAmount': minAmount,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}

class PublishProductRequest {
  final String title;
  final String desc;
  final double price;
  final String category;
  final List<String> images;

  const PublishProductRequest({
    required this.title,
    required this.desc,
    required this.price,
    required this.category,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': desc,
      'price': price,
      'category': category,
      'images': images,
    };
  }
}

class CreateOrderRequest {
  final String productId;
  final int qty;

  const CreateOrderRequest({
    required this.productId,
    required this.qty,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'qty': qty,
    };
  }
}

class SubmitReviewRequest {
  final String orderId;
  final int rating;
  final String content;

  const SubmitReviewRequest({
    required this.orderId,
    required this.rating,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'rating': rating,
      'content': content,
    };
  }
}

class RecycleRequest {
  final String category;
  final String desc;
  final List<String> images;

  const RecycleRequest({
    required this.category,
    required this.desc,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'desc': desc,
      'images': images,
    };
  }
}

class DisputeRequest {
  final String orderId;
  final String reason;

  const DisputeRequest({
    required this.orderId,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'reason': reason,
    };
  }
}
