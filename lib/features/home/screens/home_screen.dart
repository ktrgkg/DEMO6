import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/constants/app_strings.dart";
import "../../../core/models/enums.dart";
import "../../auth/controllers/auth_controller.dart";
import "../../../core/auth/auth_state.dart";
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
        ref.read(authControllerProvider).logout();
      });
    }
    return PosterJobsScreen(
      onLogout: () {
        ref.read(authControllerProvider).logout();
      },
    );
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
