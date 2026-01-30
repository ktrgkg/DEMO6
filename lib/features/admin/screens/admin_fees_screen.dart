import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/models/fee.dart";
import "../controllers/admin_fees_controller.dart";

class AdminFeesScreen extends ConsumerStatefulWidget {
  const AdminFeesScreen({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  ConsumerState<AdminFeesScreen> createState() => _AdminFeesScreenState();
}

class _AdminFeesScreenState extends ConsumerState<AdminFeesScreen>
    with SingleTickerProviderStateMixin {
  static const _statuses = ["unpaid", "submitted", "paid"];
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      return;
    }
    ref
        .read(adminFeesControllerProvider.notifier)
        .updateStatus(_statuses[_tabController.index]);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminFeesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý phí"),
        actions: [
          TextButton(
            onPressed: widget.onLogout,
            child: const Text("Đăng xuất"),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Chưa thu"),
            Tab(text: "Đã gửi"),
            Tab(text: "Đã thu"),
          ],
        ),
      ),
      body: state.when(
        data: (data) {
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await ref.read(adminFeesControllerProvider.notifier).refresh();
                },
                child: data.fees.isEmpty
                    ? const ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 120),
                          Center(child: Text("Không có phí cần thanh toán")),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: data.fees.length,
                        itemBuilder: (context, index) {
                          final fee = data.fees[index];
                          return _AdminFeeCard(
                            fee: fee,
                            canMarkPaid: data.status != "paid",
                            onMarkPaid: () => _openMarkPaidDialog(context, fee),
                          );
                        },
                      ),
              ),
              if (data.isSubmitting)
                Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorStateView(
          message: ref
                  .read(adminFeesControllerProvider.notifier)
                  .errorMessage(error) ??
              "Đã có lỗi xảy ra. Vui lòng thử lại.",
          onRetry: () {
            ref.read(adminFeesControllerProvider.notifier).refresh();
          },
        ),
      ),
    );
  }

  Future<void> _openMarkPaidDialog(BuildContext context, Fee fee) async {
    final noteController = TextEditingController();
    DateTime paidAt = DateTime.now();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Đánh dấu đã thu tiền"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      labelText: "Ghi chú",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _DateTimePicker(
                    label: "Thời gian thu",
                    value: paidAt,
                    onChanged: (value) {
                      setState(() {
                        paidAt = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Huỷ"),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Xác nhận"),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != true) {
      noteController.dispose();
      return;
    }

    final payload = {
      "note": noteController.text.trim(),
      "paid_at": paidAt.toIso8601String(),
    };
    noteController.dispose();

    final message =
        await ref.read(adminFeesControllerProvider.notifier).markPaid(
              fee.id,
              payload,
            );
    if (!mounted) {
      return;
    }
    if (message != null) {
      _showMessage(message);
    } else {
      _showMessage("Đã đánh dấu đã thu tiền.");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _AdminFeeCard extends StatelessWidget {
  const _AdminFeeCard({
    required this.fee,
    required this.canMarkPaid,
    required this.onMarkPaid,
  });

  final Fee fee;
  final bool canMarkPaid;
  final VoidCallback onMarkPaid;

  @override
  Widget build(BuildContext context) {
    final jobTitle = fee.jobTitle?.isNotEmpty == true
        ? fee.jobTitle!
        : fee.jobId.isNotEmpty
            ? "Công việc #${fee.jobId}"
            : "Không rõ công việc";
    final userLabel = fee.userName?.isNotEmpty == true
        ? fee.userName!
        : "Người dùng #${fee.userPhone ?? fee.id}";
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userLabel, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _InfoRow(label: "Công việc", value: jobTitle),
            _InfoRow(label: "Số tiền", value: "${fee.amount} đ"),
            _InfoRow(label: "Trạng thái", value: _statusLabel(fee.status)),
            if (fee.paidAt != null)
              _InfoRow(
                label: "Ngày thu",
                value: _formatDateTime(fee.paidAt!),
              ),
            if (canMarkPaid) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onMarkPaid,
                  child: const Text("Đánh dấu đã thu tiền"),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (date == null) {
          return;
        }
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(value),
        );
        final updated = DateTime(
          date.year,
          date.month,
          date.day,
          time?.hour ?? value.hour,
          time?.minute ?? value.minute,
        );
        onChanged(updated);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(_formatDateTime(value)),
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
