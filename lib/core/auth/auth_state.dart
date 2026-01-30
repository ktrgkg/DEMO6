import "package:flutter_riverpod/flutter_riverpod.dart";

import "../models/user_lite.dart";

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
  });

  final AuthStatus status;
  final UserLite? user;

  AuthState copyWith({
    AuthStatus? status,
    UserLite? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  factory AuthState.unknown() {
    return const AuthState(status: AuthStatus.unknown);
  }
}

class AuthSessionNotifier extends StateNotifier<AuthState> {
  AuthSessionNotifier() : super(AuthState.unknown());

  void setAuthenticated(UserLite user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  void setUnauthenticated() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void setUnknown() {
    state = AuthState.unknown();
  }
}

final authSessionProvider =
    StateNotifierProvider<AuthSessionNotifier, AuthState>((ref) {
  return AuthSessionNotifier();
});
