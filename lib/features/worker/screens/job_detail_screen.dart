import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../core/auth/auth_state.dart";
import "../../../core/models/enums.dart";
import "../../../core/models/job.dart";
import "../../../core/network/error_message.dart";
import "../../../core/constants/app_routes.dart";
import "../../../core/widgets/safe_fallback_screen.dart";
import "../../../core/widgets/snackbars.dart";
import "../../../core/widgets/state_views.dart";
import "../controllers/fee_summary_controller.dart";
import "../controllers/job_detail_controller.dart";
import "../widgets/job_labels.dart";
import "../widgets/job_status_badge.dart";

class JobDetailScreen extends ConsumerWidget {
  const JobDetailScreen({super.key, required this.jobId});

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (jobId.isEmpty) {
      return const SafeFallbackScreen(
        message: "Không tìm thấy công việc cần hiển thị.",
      );
    }
    final jobState = ref.watch(jobDetailControllerProvider(jobId));
    final feeSummaryState = ref.watch(feeSummaryProvider);
    final feeBlocked = feeSummaryState.valueOrNull?.blocked ?? false;
    final role = ref.watch(authSessionProvider).user?.role ?? UserRole.worker;
    final isPoster = role == UserRole.poster || role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết công việc"),
        actions: [
          if (isPoster)
            jobState.when(
              data: (state) {
                final canEdit = state.job.status == JobStatus.draft ||
                    state.job.status == JobStatus.open;
                if (!canEdit) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: "Chỉnh sửa",
                  onPressed: () {
                    context.push(
                      "${AppRoutes.posterJobEdit}/${state.job.id}",
                      extra: state.job,
                    );
                  },
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
        ],
      ),
      body: jobState.when(
        data: (state) {
          final job = state.job;
          final isAssignee = _isAssignee(ref, job);
          final canAccept = job.status == JobStatus.open &&
              !feeBlocked &&
              !state.isSubmitting &&
              !isPoster;
          final canStart = job.status == JobStatus.accepted &&
              isAssignee &&
              !state.isSubmitting &&
              !isPoster;
          final posterAction = _buildPosterAction(
            context,
            ref,
            job,
            state.isSubmitting,
            isPoster,
          );

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
                    if (feeBlocked && !isPoster) ...[
                      const SizedBox(height: 16),
                      _FeeWarningBanner(
                        message:
                            "Bạn đang nợ phí, vui lòng thanh toán để nhận việc mới.",
                      ),
                    ],
                  ],
                ),
              ),
              if (!isPoster &&
                  (job.status == JobStatus.open ||
                      job.status == JobStatus.accepted))
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
              if (posterAction != null)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: posterAction.onPressed,
                        child: posterAction.isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(posterAction.label),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => const LoadingView(),
        error: (error, _) => ErrorStateView(
          message: mapErrorToMessage(error),
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
    showErrorSnackBar(context, message);
  }

  _PosterAction? _buildPosterAction(
    BuildContext context,
    WidgetRef ref,
    Job job,
    bool isSubmitting,
    bool isPoster,
  ) {
    if (!isPoster) {
      return null;
    }
    if (job.status == JobStatus.draft) {
      return _PosterAction(
        label: "Đăng lên",
        isSubmitting: isSubmitting,
        onPressed: isSubmitting
            ? null
            : () async {
                final message = await ref
                    .read(jobDetailControllerProvider(jobId).notifier)
                    .publishJob();
                _showResult(context, message);
              },
      );
    }
    if (job.status == JobStatus.open) {
      return _PosterAction(
        label: "Huỷ job",
        isSubmitting: isSubmitting,
        onPressed: isSubmitting
            ? null
            : () async {
                final message = await ref
                    .read(jobDetailControllerProvider(jobId).notifier)
                    .cancelPosterJob();
                _showResult(context, message);
              },
      );
    }
    if (job.status == JobStatus.working) {
      return _PosterAction(
        label: "Xác nhận hoàn thành",
        isSubmitting: isSubmitting,
        onPressed: isSubmitting
            ? null
            : () async {
                final message = await ref
                    .read(jobDetailControllerProvider(jobId).notifier)
                    .confirmComplete();
                _showResult(context, message);
              },
      );
    }
    return null;
  }
}

class _PosterAction {
  const _PosterAction({
    required this.label,
    required this.isSubmitting,
    required this.onPressed,
  });

  final String label;
  final bool isSubmitting;
  final VoidCallback? onPressed;
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

 
