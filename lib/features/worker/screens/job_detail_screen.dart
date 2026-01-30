import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/auth/auth_state.dart";
import "../../../core/models/enums.dart";
import "../../../core/models/job.dart";
import "../../../core/network/dio_error_mapper.dart";
import "../controllers/fee_summary_controller.dart";
import "../controllers/job_detail_controller.dart";
import "../widgets/job_labels.dart";
import "../widgets/job_status_badge.dart";

class JobDetailScreen extends ConsumerWidget {
  const JobDetailScreen({super.key, required this.jobId});

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobState = ref.watch(jobDetailControllerProvider(jobId));
    final feeSummaryState = ref.watch(feeSummaryProvider);
    final feeBlocked = feeSummaryState.valueOrNull?.blocked ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết công việc"),
      ),
      body: jobState.when(
        data: (state) {
          final job = state.job;
          final isAssignee = _isAssignee(ref, job);
          final canAccept =
              job.status == JobStatus.open && !feeBlocked && !state.isSubmitting;
          final canStart = job.status == JobStatus.accepted &&
              isAssignee &&
              !state.isSubmitting;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      job.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    JobStatusBadge(status: job.status),
                    const SizedBox(height: 16),
                    _InfoRow(
                      icon: Icons.place_outlined,
                      label: "Địa điểm",
                      value: "${provinceLabel(job.province)} • ${job.district}",
                    ),
                    _InfoRow(
                      icon: Icons.wallet,
                      label: "Giá",
                      value: "${job.price} đ",
                    ),
                    _InfoRow(
                      icon: Icons.payments_outlined,
                      label: "Thanh toán",
                      value: paymentTypeLabel(job.paymentType),
                    ),
                    _InfoRow(
                      icon: Icons.category_outlined,
                      label: "Loại việc",
                      value: jobTypeLabel(job.jobType),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Mô tả công việc",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job.description.isEmpty
                          ? "Chưa có mô tả"
                          : job.description,
                    ),
                    if (feeBlocked) ...[
                      const SizedBox(height: 16),
                      _FeeWarningBanner(
                        message:
                            "Bạn đang nợ phí, vui lòng thanh toán để nhận việc mới.",
                      ),
                    ],
                  ],
                ),
              ),
              if (job.status == JobStatus.open || job.status == JobStatus.accepted)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: canAccept
                            ? () async {
                                final message = await ref
                                    .read(jobDetailControllerProvider(jobId).notifier)
                                    .acceptJob();
                                _showResult(context, message);
                              }
                            : canStart
                                ? () async {
                                    final message = await ref
                                        .read(jobDetailControllerProvider(jobId).notifier)
                                        .startJob();
                                    _showResult(context, message);
                                  }
                                : null,
                        child: state.isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(_actionLabel(job, feeBlocked, isAssignee)),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorStateView(
          message: _errorMessage(error),
          onRetry: () {
            ref.invalidate(jobDetailControllerProvider(jobId));
          },
        ),
      ),
    );
  }

  bool _isAssignee(WidgetRef ref, Job job) {
    final userId = ref.read(authSessionProvider).user?.id;
    return userId != null && userId.isNotEmpty && job.worker?.id == userId;
  }

  String _actionLabel(Job job, bool blocked, bool isAssignee) {
    if (job.status == JobStatus.open) {
      return blocked ? "Không thể nhận việc" : "Nhận việc";
    }
    if (job.status == JobStatus.accepted && isAssignee) {
      return "Bắt đầu";
    }
    return "Không khả dụng";
  }

  void _showResult(BuildContext context, String? message) {
    if (message == null) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      return mapDioExceptionToMessage(error);
    }
    return "Đã có lỗi xảy ra. Vui lòng thử lại.";
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeeWarningBanner extends StatelessWidget {
  const _FeeWarningBanner({required this.message});

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
