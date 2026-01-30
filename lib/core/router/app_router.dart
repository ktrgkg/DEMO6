import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../core/constants/app_routes.dart";
import "../../features/auth/controllers/auth_controller.dart";
import "../auth/auth_state.dart";
import "../models/fee.dart";
import "../models/job.dart";
import "../../features/auth/screens/login_screen.dart";
import "../../features/auth/screens/register_screen.dart";
import "../../features/auth/screens/splash_screen.dart";
import "../../features/home/screens/home_screen.dart";
import "../../features/admin/screens/admin_fees_screen.dart";
import "../../features/poster/screens/create_edit_job_screen.dart";
import "../../features/worker/screens/job_detail_screen.dart";
import "../../features/worker/screens/submit_payment_screen.dart";
import "../../features/worker/screens/worker_fees_screen.dart";
import "../widgets/safe_fallback_screen.dart";

final routerProvider = Provider<GoRouter>((ref) {
  ref.watch(authControllerProvider);
  final authState = ref.watch(authSessionProvider);
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable:
        GoRouterRefreshStream(ref.watch(authSessionProvider.notifier).stream),
    errorBuilder: (context, state) => const SafeFallbackScreen(
      message: "Trang không tồn tại hoặc thiếu dữ liệu.",
    ),
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
      GoRoute(
        path: "${AppRoutes.posterJobEdit}/:id",
        builder: (context, state) {
          final job = state.extra;
          return CreateEditJobScreen(job: job is Job ? job : null);
        },
      ),
      GoRoute(
        path: AppRoutes.workerFees,
        builder: (context, state) => const WorkerFeesScreen(),
      ),
      GoRoute(
        path: AppRoutes.submitPayment,
        builder: (context, state) {
          final fee = state.extra;
          if (fee is Fee) {
            return SubmitPaymentScreen(fee: fee);
          }
          return const SafeFallbackScreen(
            message: "Không tìm thấy thông tin phí cần hiển thị.",
          );
        },
      ),
      GoRoute(
        path: AppRoutes.adminFees,
        builder: (context, state) => AdminFeesScreen(onLogout: () {}),
      ),
    ],
  );
});
