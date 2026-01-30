import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../core/constants/app_routes.dart";
import "../../../core/models/fee.dart";
import "../../../core/network/dio_error_mapper.dart";
import "../../../core/models/fee_summary.dart";
import "../controllers/fee_summary_controller.dart";
import "../controllers/worker_fees_controller.dart";

class WorkerFeesScreen extends ConsumerWidget {
  const WorkerFeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryState = ref.watch(feeSummaryProvider);
    final feesState = ref.watch(workerFeesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Phí của tôi"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(workerFeesControllerProvider.notifier).refresh();
          await ref.read(feeSummaryProvider.notifier).refresh();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SummaryCard(summaryState: summaryState),
            const SizedBox(height: 16),
            feesState.when(
              data: (fees) {
                if (fees.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: Text("Không có phí cần thanh toán"),
                    ),
                  );
                }
                return Column(
                  children: fees
                      .map(
                        (fee) => _FeeItemCard(
                          fee: fee,
                          onSubmit: fee.status == "unpaid"
                              ? () {
                                  context.push(
                                    AppRoutes.submitPayment,
                                    extra: fee,
                                  );
                                }
                              : null,
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => _ErrorStateView(
                message: _errorMessage(error),
                onRetry: () {
                  ref.read(workerFeesControllerProvider.notifier).refresh();
                },
              ),
            ),
          ],
        ),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summaryState});

  final AsyncValue<FeeSummary> summaryState;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: summaryState.when(
          data: (summary) {
            final isBlocked = summary.blocked == true;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tổng phí cần thanh toán: ${summary.totalDue} đ",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  "Trạng thái: ${isBlocked ? "Bị khoá" : "Hoạt động"}",
                ),
                const SizedBox(height: 8),
                Text(
                  isBlocked
                      ? "Bạn đang nợ phí, vui lòng thanh toán để tiếp tục nhận việc."
                      : "Bạn đang hoạt động bình thường.",
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text(
            error is DioException
                ? mapDioExceptionToMessage(error)
                : "Đã có lỗi xảy ra. Vui lòng thử lại.",
          ),
        ),
      ),
    );
  }
}

class _FeeItemCard extends StatelessWidget {
  const _FeeItemCard({required this.fee, this.onSubmit});

  final Fee fee;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final jobTitle = fee.jobTitle?.isNotEmpty == true
        ? fee.jobTitle!
        : fee.jobId.isNotEmpty
            ? "Công việc #${fee.jobId}"
            : "Không rõ công việc";
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _InfoRow(label: "Số tiền", value: "${fee.amount} đ"),
            _InfoRow(label: "Trạng thái", value: _statusLabel(fee.status)),
            if (fee.createdAt != null)
              _InfoRow(
                label: "Ngày tạo",
                value: _formatDateTime(fee.createdAt!),
              ),
            if (onSubmit != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onSubmit,
                  child: const Text("Gửi thanh toán"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Text(
            "$label:",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
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

String _statusLabel(String status) {
  switch (status) {
    case "unpaid":
      return "Chưa thanh toán";
    case "submitted":
      return "Đã gửi thanh toán";
    case "paid":
      return "Đã thanh toán";
    default:
      return status;
  }
}

String _formatDateTime(DateTime dateTime) {
  final local = dateTime.toLocal();
  final day = local.day.toString().padLeft(2, "0");
  final month = local.month.toString().padLeft(2, "0");
  final hour = local.hour.toString().padLeft(2, "0");
  final minute = local.minute.toString().padLeft(2, "0");
  return "$day/$month/${local.year} $hour:$minute";
}
