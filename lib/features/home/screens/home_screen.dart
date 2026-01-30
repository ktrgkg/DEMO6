import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../core/constants/app_strings.dart";
import "../../../core/constants/app_routes.dart";
import "../../../core/models/enums.dart";
import "../../auth/controllers/auth_controller.dart";
import "../../../core/auth/auth_state.dart";
import "../../admin/screens/admin_fees_screen.dart";
import "../../poster/screens/poster_jobs_screen.dart";
import "../../worker/screens/worker_jobs_screen.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authSessionProvider);
    final role = authState.user?.role ?? UserRole.worker;
    if (role == UserRole.worker) {
      return WorkerHomeScreen(onLogout: () {
        _handleLogout(context, ref);
      });
    }
    if (role == UserRole.admin) {
      return AdminFeesScreen(
        onLogout: () {
          _handleLogout(context, ref);
        },
      );
    }
    return PosterJobsScreen(
      onLogout: () {
        _handleLogout(context, ref);
      },
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider).logout();
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  }
}

class WorkerHomeScreen extends StatelessWidget {
  const WorkerHomeScreen({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        actions: [
          IconButton(
            onPressed: () {
              context.push(AppRoutes.workerFees);
            },
            icon: const Icon(Icons.receipt_long),
            tooltip: "Phí của tôi",
          ),
          TextButton(
            onPressed: onLogout,
            child: const Text(AppStrings.logoutButton),
          ),
        ],
      ),
      body: const WorkerJobsScreen(),
    );
  }
}
