import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../core/constants/app_routes.dart";
import "../../features/auth/controllers/auth_controller.dart";
import "../auth/auth_state.dart";
import "../../features/auth/screens/login_screen.dart";
import "../../features/auth/screens/register_screen.dart";
import "../../features/auth/screens/splash_screen.dart";
import "../../features/home/screens/home_screen.dart";
import "../../features/worker/screens/job_detail_screen.dart";

final routerProvider = Provider<GoRouter>((ref) {
  ref.watch(authControllerProvider);
  final authState = ref.watch(authSessionProvider);
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable:
        GoRouterRefreshStream(ref.watch(authSessionProvider.notifier).stream),
    redirect: (context, state) {
      final location = state.matchedLocation;

      if (authState.status == AuthStatus.unknown) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      if (authState.status == AuthStatus.unauthenticated) {
        if (location == AppRoutes.login || location == AppRoutes.register) {
          return null;
        }
        return AppRoutes.login;
      }

      if (authState.status == AuthStatus.authenticated) {
        if (location == AppRoutes.splash ||
            location == AppRoutes.login ||
            location == AppRoutes.register) {
          return AppRoutes.home;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: "${AppRoutes.jobDetail}/:id",
        builder: (context, state) {
          final jobId = state.pathParameters["id"] ?? "";
          return JobDetailScreen(jobId: jobId);
        },
      ),
    ],
  );
});
