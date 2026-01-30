import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../core/auth/auth_state.dart";
import "../../../core/constants/app_routes.dart";
import "../../../core/network/error_message.dart";
import "../../../core/widgets/account_summary_card.dart";
import "../../../core/widgets/state_views.dart";
import "../../worker/controllers/fee_summary_controller.dart";
import "../../worker/controllers/worker_jobs_controller.dart";
import "../widgets/worker_job_card.dart";
import "../widgets/worker_job_filter_sheet.dart";

class WorkerJobsScreen extends ConsumerStatefulWidget {
  const WorkerJobsScreen({super.key});

  @override
  ConsumerState<WorkerJobsScreen> createState() => _WorkerJobsScreenState();
}

class _WorkerJobsScreenState extends ConsumerState<WorkerJobsScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    ref.listen<AsyncValue<WorkerJobsState>>(
      workerJobsControllerProvider,
      (previous, next) {
        final keyword = next.valueOrNull?.filters.keyword ?? "";
        if (_searchController.text != keyword) {
          _searchController.text = keyword;
        }
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobsState = ref.watch(workerJobsControllerProvider);
    final feeSummaryState = ref.watch(feeSummaryProvider);
    final user = ref.watch(authSessionProvider).user;
    final feeBlocked = feeSummaryState.valueOrNull?.blocked ?? false;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AccountSummaryCard(user: user),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Tìm kiếm công việc",
                  ),
                  onSubmitted: (value) {
                    ref
                        .read(workerJobsControllerProvider.notifier)
                        .updateKeyword(value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  final filters = jobsState.valueOrNull?.filters;
                  if (filters == null) {
                    return;
                  }
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return WorkerJobFilterSheet(
                        initialFilters: filters,
                        onApply: (updated) {
                          ref
                              .read(workerJobsControllerProvider.notifier)
                              .applyFilters(updated);
                        },
                        onReset: () {
                          ref
                              .read(workerJobsControllerProvider.notifier)
                              .resetFilters();
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Icons.filter_list),
                tooltip: "Bộ lọc",
              ),
            ],
          ),
          if (feeBlocked) ...[
            const SizedBox(height: 12),
            _FeeBlockedBanner(message: "Bạn đang nợ phí, vui lòng thanh toán để nhận việc mới."),
          ],
          const SizedBox(height: 12),
          Expanded(
            child: jobsState.when(
              data: (data) {
                if (data.jobs.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(workerJobsControllerProvider.notifier)
                          .refresh();
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 80),
                        EmptyStateView(
                          message:
                              "Chưa có việc phù hợp. Kéo xuống để cập nhật.",
                          onRetry: () {
                            ref
                                .read(workerJobsControllerProvider.notifier)
                                .refresh();
                          },
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(workerJobsControllerProvider.notifier)
                        .refresh();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 4),
                    itemCount: data.jobs.length,
                    itemBuilder: (context, index) {
                      final job = data.jobs[index];
                      return WorkerJobCard(
                        job: job,
                        onTap: () {
                          context.push("${AppRoutes.jobDetail}/${job.id}");
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const LoadingView(),
              error: (error, _) => ErrorStateView(
                message: mapErrorToMessage(error),
                onRetry: () {
                  ref.read(workerJobsControllerProvider.notifier).refresh();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeeBlockedBanner extends StatelessWidget {
  const _FeeBlockedBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.errorContainer,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.warning_amber, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
