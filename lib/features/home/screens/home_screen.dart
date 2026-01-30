import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/constants/app_strings.dart";
import "../../auth/controllers/auth_controller.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final roleLabel = authState.role == UserRole.worker
        ? AppStrings.workerRole
        : AppStrings.posterRole;
    final initialIndex = authState.role == UserRole.worker ? 0 : 1;

    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.homeTitle),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).logout();
              },
              child: const Text(AppStrings.logoutButton),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: AppStrings.workerHomeTab),
              Tab(text: AppStrings.posterHomeTab),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.person_outline),
                  const SizedBox(width: 8),
                  Text("${AppStrings.roleDisplayPrefix} $roleLabel"),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  WorkerHomePlaceholder(),
                  PosterHomePlaceholder(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkerHomePlaceholder extends StatelessWidget {
  const WorkerHomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Nội dung dành cho người lao động"),
    );
  }
}

class PosterHomePlaceholder extends StatelessWidget {
  const PosterHomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Nội dung dành cho nhà tuyển dụng"),
    );
  }
}
