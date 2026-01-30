import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/models/enums.dart";
import "../../../core/network/dio_error_mapper.dart";
import "../../../core/repositories/auth_repository.dart";
import "../../../core/storage/token_storage.dart";
import "../../../core/auth/auth_state.dart";

final authControllerProvider = Provider<AuthController>((ref) {
  final controller = AuthController(
    ref,
    ref.read(tokenStorageProvider),
    ref.read(authRepositoryProvider),
  );
  controller.initialize();
  return controller;
});

class AuthController {
  AuthController(this._ref, this._tokenStorage, this._authRepository);

  final Ref _ref;
  final TokenStorage _tokenStorage;
  final AuthRepository _authRepository;

  AuthSessionNotifier get _session => _ref.read(authSessionProvider.notifier);

  Future<void> initialize() async {
    final token = await _tokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      _session.setUnauthenticated();
      return;
    }

    try {
      final user = await _authRepository.me();
      _session.setAuthenticated(user);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        await _tokenStorage.clear();
      }
      _session.setUnauthenticated();
    } catch (_) {
      _session.setUnauthenticated();
    }
  }

  Future<String?> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response =
          await _authRepository.login(phone: phone, password: password);
      await _tokenStorage.saveAccessToken(response.accessToken);
      _session.setAuthenticated(response.user);
      return null;
    } on DioException catch (error) {
      return mapDioExceptionToMessage(error);
    } catch (_) {
      return "Đã có lỗi xảy ra. Vui lòng thử lại.";
    }
  }

  Future<String?> register({
    required String name,
    required String phone,
    required String password,
    required UserRole role,
    required Province province,
    required String district,
  }) async {
    try {
      final response = await _authRepository.register(
        name: name,
        phone: phone,
        password: password,
        role: userRoleToString(role),
        province: provinceToString(province),
        district: district,
      );
      await _tokenStorage.saveAccessToken(response.accessToken);
      _session.setAuthenticated(response.user);
      return null;
    } on DioException catch (error) {
      return mapDioExceptionToMessage(error);
    } catch (_) {
      return "Đã có lỗi xảy ra. Vui lòng thử lại.";
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
    _session.setUnauthenticated();
  }
}
