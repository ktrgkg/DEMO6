import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../models/job.dart";
import "../network/api_client.dart";

class JobRepository {
  JobRepository(this._client);

  final ApiClient _client;

  Future<List<Job>> listJobs({Map<String, dynamic>? filters}) async {
    final response = await _client.dio.get(
      "/api/jobs",
      queryParameters: filters,
    );
    return _parseJobList(response);
  }

  Future<Job> getJob(String id) async {
    final response = await _client.dio.get("/api/jobs/$id");
    return Job.fromJson(_unwrapData(response));
  }

  Future<List<Job>> myJobs({String? status}) async {
    final response = await _client.dio.get(
      "/api/jobs/mine",
      queryParameters: status == null ? null : {"status": status},
    );
    return _parseJobList(response);
  }

  Future<Job> createJob(Map<String, dynamic> payload) async {
    final response = await _client.dio.post("/api/jobs", data: payload);
    return Job.fromJson(_unwrapData(response));
  }

  Future<Job> updateJob(String id, Map<String, dynamic> payload) async {
    final response = await _client.dio.patch("/api/jobs/$id", data: payload);
    return Job.fromJson(_unwrapData(response));
  }

  Future<Job> publishJob(String id) async {
    final response = await _client.dio.post("/api/jobs/$id/publish");
    return Job.fromJson(_unwrapData(response));
  }

  Future<Job> acceptJob(String id) async {
    final response = await _client.dio.post("/api/jobs/$id/accept");
    return Job.fromJson(_unwrapData(response));
  }

  Future<Job> startJob(String id) async {
    final response = await _client.dio.post("/api/jobs/$id/start");
    return Job.fromJson(_unwrapData(response));
  }

  Future<Job> confirmComplete(String id) async {
    final response = await _client.dio.post("/api/jobs/$id/confirm-complete");
    return Job.fromJson(_unwrapData(response));
  }

  Future<Job> cancelPoster(String id) async {
    final response = await _client.dio.post("/api/jobs/$id/cancel");
    return Job.fromJson(_unwrapData(response));
  }

  Future<Job> cancelWorker(String id) async {
    final response = await _client.dio.post("/api/jobs/$id/cancel-by-worker");
    return Job.fromJson(_unwrapData(response));
  }
}

final jobRepositoryProvider = Provider<JobRepository>((ref) {
  final client = ref.read(apiClientProvider);
  return JobRepository(client);
});

Map<String, dynamic> _unwrapData(Response response) {
  final data = response.data;
  if (data is Map<String, dynamic>) {
    if (data.containsKey("data")) {
      final inner = data["data"];
      if (inner is Map<String, dynamic>) {
        return inner;
      }
    }
    return data;
  }
  return {};
}

List<Job> _parseJobList(Response response) {
  final data = response.data;
  if (data is Map<String, dynamic> && data["data"] is List) {
    return (data["data"] as List)
        .whereType<Map<String, dynamic>>()
        .map(Job.fromJson)
        .toList();
  }
  if (data is List) {
    return data
        .whereType<Map<String, dynamic>>()
        .map(Job.fromJson)
        .toList();
  }
  return [];
}
