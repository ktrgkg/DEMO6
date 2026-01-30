import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/storage/token_storage.dart";

enum AuthStatus { unknown, authenticated, unauthenticated }

enum UserRole { worker, poster }

class AuthState {
  const AuthState({
    required this.status,
    required this.role,
  });

  final AuthStatus status;
  final UserRole role;

  AuthState copyWith({
    AuthStatus? status,
    UserRole? role,
  }) {
    return AuthState(
      status: status ?? this.status,
      role: role ?? this.role,
    );
  }

  factory AuthState.unknown() {
    return const AuthState(status: AuthStatus.unknown, role: UserRole.worker);
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final storage = ref.read(tokenStorageProvider);
  return AuthController(storage);
});

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._tokenStorage) : super(AuthState.unknown()) {
    _init();
  }

  final TokenStorage _tokenStorage;

  Future<void> _init() async {
    final token = await _tokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } else {
      state = state.copyWith(status: AuthStatus.authenticated);
    }
  }

  Future<void> login({UserRole role = UserRole.worker}) async {
    await _tokenStorage.saveAccessToken("dummy_token");
    state = state.copyWith(status: AuthStatus.authenticated, role: role);
  }

  Future<void> register({required UserRole role}) async {
    await _tokenStorage.saveAccessToken("dummy_token");
    state = state.copyWith(status: AuthStatus.authenticated, role: role);
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }
}
