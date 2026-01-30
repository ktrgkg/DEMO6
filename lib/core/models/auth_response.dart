import "user_lite.dart";

class AuthResponse {
  const AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final UserLite user;

  AuthResponse copyWith({
    String? accessToken,
    String? tokenType,
    int? expiresIn,
    UserLite? user,
  }) {
    return AuthResponse(
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      user: user ?? this.user,
    );
  }

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json["access_token"]?.toString() ?? "",
      tokenType: json["token_type"]?.toString() ?? "",
      expiresIn: _readInt(json["expires_in"]),
      user: UserLite.fromJson((json["user"] as Map<String, dynamic>? ?? {})),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "access_token": accessToken,
      "token_type": tokenType,
      "expires_in": expiresIn,
      "user": user.toJson(),
    };
  }
}

int _readInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  if (value is double) {
    return value.toInt();
  }
  return 0;
}
