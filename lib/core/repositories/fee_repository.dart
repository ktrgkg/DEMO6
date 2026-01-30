import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../models/fee.dart";
import "../network/api_client.dart";

class FeeRepository {
  FeeRepository(this._client);

  final ApiClient _client;

  Future<List<Fee>> myFees() async {
    final response = await _client.dio.get("/api/fees/my");
    return _parseFeeList(response);
  }

  Future<Map<String, dynamic>> myFeeSummary() async {
    final response = await _client.dio.get("/api/fees/my/summary");
    return _unwrapData(response);
  }

  Future<Fee> submitPayment(String feeId, Map<String, dynamic> payload) async {
    final response =
        await _client.dio.post("/api/fees/$feeId/submit-payment", data: payload);
    return Fee.fromJson(_unwrapData(response));
  }

  Future<List<Fee>> adminFees({String? status}) async {
    final response = await _client.dio.get(
      "/api/admin/fees",
      queryParameters: status == null ? null : {"status": status},
    );
    return _parseFeeList(response);
  }

  Future<Fee> adminMarkPaid(String feeId, Map<String, dynamic> payload) async {
    final response =
        await _client.dio.post("/api/admin/fees/$feeId/mark-paid", data: payload);
    return Fee.fromJson(_unwrapData(response));
  }
}

final feeRepositoryProvider = Provider<FeeRepository>((ref) {
  final client = ref.read(apiClientProvider);
  return FeeRepository(client);
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

List<Fee> _parseFeeList(Response response) {
  final data = response.data;
  if (data is Map<String, dynamic> && data["data"] is List) {
    return (data["data"] as List)
        .whereType<Map<String, dynamic>>()
        .map(Fee.fromJson)
        .toList();
  }
  if (data is List) {
    return data
        .whereType<Map<String, dynamic>>()
        .map(Fee.fromJson)
        .toList();
  }
  return [];
}
