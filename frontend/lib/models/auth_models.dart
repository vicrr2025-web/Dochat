class AuthResponse {
  final String userId;
  final String token;
  final String refreshToken;
  final String userSig;
  final int expiresIn;

  const AuthResponse({
    required this.userId,
    required this.token,
    required this.refreshToken,
    required this.userSig,
    required this.expiresIn,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      userId: json['userId'] as String,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      userSig: json['userSig'] as String,
      expiresIn: json['expiresIn'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'token': token,
      'refreshToken': refreshToken,
      'userSig': userSig,
      'expiresIn': expiresIn,
    };
  }
}

class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  const ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? fromJsonT,
  }) {
    return ApiResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }
}

class ApiError {
  final int code;
  final String message;

  const ApiError({required this.code, required this.message});
}
