import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../core/constants/app_routes.dart";
import "../../../core/network/dio_error_mapper.dart";
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
    final feeBlocked = feeSummaryState.valueOrNull?.blocked ?? false;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
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
                      children: const [
                        SizedBox(height: 120),
                        Center(child: Text("Chưa có việc phù hợp")),
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
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _ErrorStateView(
                message: _errorMessage(error),
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

  String _errorMessage(Object error) {
    if (error is DioException) {
      return mapDioExceptionToMessage(error);
    }
    return "Đã có lỗi xảy ra. Vui lòng thử lại.";
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
