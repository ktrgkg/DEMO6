import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../models/auth_response.dart";
import "../models/user_lite.dart";
import "../network/api_client.dart";

class AuthRepository {
  AuthRepository(this._client);

  final ApiClient _client;

  Future<AuthResponse> login({
    required String phone,
    required String password,
  }) async {
    final response = await _client.dio.post(
      "/api/auth/login",
      data: {
        "phone": phone,
        "password": password,
      },
    );
    return AuthResponse.fromJson(_unwrapData(response));
  }

  Future<AuthResponse> register({
    required String name,
    required String phone,
    required String password,
    required String role,
    required String province,
    required String district,
  }) async {
    final response = await _client.dio.post(
      "/api/auth/register",
      data: {
        "name": name,
        "phone": phone,
        "password": password,
        "role": role,
        "province": province,
        "district": district,
      },
    );
    return AuthResponse.fromJson(_unwrapData(response));
  }

  Future<UserLite> me() async {
    final response = await _client.dio.get("/api/me");
    return UserLite.fromJson(_unwrapData(response));
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.read(apiClientProvider);
  return AuthRepository(client);
});

Map<String, dynamic> _unwrapData(Response response) {
  final data = response.data;
  if (data is Map<String, dynamic>) {
    if (data.containsKey("data") && data["data"] is Map<String, dynamic>) {
      return data["data"] as Map<String, dynamic>;
    }
    return data;
  }
  return {};
}
