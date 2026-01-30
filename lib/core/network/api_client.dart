import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../auth/auth_state.dart";
import "../config/app_config.dart";
import "../storage/token_storage.dart";

class ApiClient {
  ApiClient(this.dio);

  final Dio dio;
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = AppConfig.apiBaseUrl;
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Accept": "application/json",
      },
    ),
  );
  final tokenStorage = ref.read(tokenStorageProvider);
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokenStorage.getAccessToken();
        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await tokenStorage.clear();
          ref.read(authSessionProvider.notifier).setUnauthenticated();
        }
        return handler.next(error);
      },
    ),
  );
  return ApiClient(dio);
});
