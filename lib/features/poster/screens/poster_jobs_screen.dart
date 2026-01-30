import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../core/constants/app_routes.dart";
import "../../../core/constants/app_strings.dart";
import "../../../core/models/enums.dart";
import "../controllers/poster_jobs_controller.dart";
import "../widgets/poster_job_card.dart";

class PosterJobsScreen extends ConsumerStatefulWidget {
  const PosterJobsScreen({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  ConsumerState<PosterJobsScreen> createState() => _PosterJobsScreenState();
}

class _PosterJobsScreenState extends ConsumerState<PosterJobsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const List<JobStatus> _tabs = [
    JobStatus.draft,
    JobStatus.open,
    JobStatus.accepted,
    JobStatus.working,
    JobStatus.completed,
    JobStatus.cancelled,
  ];

  static const Map<JobStatus, String> _labels = {
    JobStatus.draft: "Nháp",
    JobStatus.open: "Đang mở",
    JobStatus.accepted: "Đã nhận",
    JobStatus.working: "Đang làm",
    JobStatus.completed: "Hoàn thành",
    JobStatus.cancelled: "Đã huỷ",
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Công việc của tôi"),
        actions: [
          if (widget.onLogout != null)
            TextButton(
              onPressed: widget.onLogout,
              child: const Text(AppStrings.logoutButton),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs
              .map((status) => Tab(text: _labels[status] ?? ""))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push("${AppRoutes.posterJobEdit}/new");
        },
        icon: const Icon(Icons.add),
        label: const Text("Đăng việc"),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs
            .map((status) => _PosterJobsTab(status: status))
            .toList(),
      ),
    );
  }
}

class _PosterJobsTab extends ConsumerWidget {
  const _PosterJobsTab({required this.status});

  final JobStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posterJobsControllerProvider(status));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: state.when(
        data: (data) {
          if (data.jobs.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(posterJobsControllerProvider(status).notifier)
                    .refresh();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text("Chưa có job")),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(posterJobsControllerProvider(status).notifier)
                  .refresh();
            },
            child: ListView.builder(
              itemCount: data.jobs.length,
              itemBuilder: (context, index) {
                final job = data.jobs[index];
                return PosterJobCard(
                  job: job,
                  onTap: () {
                    context.push("${AppRoutes.jobDetail}/${job.id}");
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorStateView(
          message: ref
                  .read(posterJobsControllerProvider(status).notifier)
                  .errorMessage(error) ??
              "Đã có lỗi xảy ra. Vui lòng thử lại.",
          onRetry: () {
            ref.read(posterJobsControllerProvider(status).notifier).refresh();
          },
        ),
      ),
    );
  }
}

class _ErrorStateView extends StatelessWidget {
  const _ErrorStateView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text("Thử lại"),
          ),
        ],
      ),
    );
  }
}
