import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/models/fee.dart";
import "../../../core/network/error_message.dart";
import "../../../core/widgets/snackbars.dart";
import "../controllers/fee_summary_controller.dart";
import "../controllers/worker_fees_controller.dart";

class SubmitPaymentScreen extends ConsumerStatefulWidget {
  const SubmitPaymentScreen({super.key, required this.fee});

  final Fee fee;

  @override
  ConsumerState<SubmitPaymentScreen> createState() => _SubmitPaymentScreenState();
}

class _SubmitPaymentScreenState extends ConsumerState<SubmitPaymentScreen> {
  late final TextEditingController _noteController;
  String _method = "cash";
  DateTime _paidAt = DateTime.now();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gửi thanh toán"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Số tiền cần thanh toán: ${widget.fee.amount} đ",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _method,
              decoration: const InputDecoration(
                labelText: "Phương thức thanh toán",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "cash", child: Text("Tiền mặt")),
                DropdownMenuItem(value: "transfer", child: Text("Chuyển khoản")),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _method = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: "Mã giao dịch / Ghi chú",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            _DateTimePicker(
              label: "Thời gian thanh toán",
              value: _paidAt,
              onChanged: (value) {
                setState(() {
                  _paidAt = value;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Xác nhận gửi"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
    });
    final payload = {
      "payment_method": _method,
      "note": _noteController.text.trim(),
      "paid_at": _paidAt.toIso8601String(),
    };
    try {
      final message = await ref
          .read(workerFeesControllerProvider.notifier)
          .submitPayment(widget.fee.id, payload);
      if (!mounted) {
        return;
      }
      if (message != null) {
        showErrorSnackBar(context, message);
      } else {
        await ref.read(workerFeesControllerProvider.notifier).refresh();
        await ref.read(feeSummaryProvider.notifier).refresh();
        showSuccessSnackBar(context, "Đã gửi thanh toán thành công.");
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, mapErrorToMessage(error));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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

String _formatDateTime(DateTime dateTime) {
  final local = dateTime.toLocal();
  final day = local.day.toString().padLeft(2, "0");
  final month = local.month.toString().padLeft(2, "0");
  final hour = local.hour.toString().padLeft(2, "0");
  final minute = local.minute.toString().padLeft(2, "0");
  return "$day/$month/${local.year} $hour:$minute";
}
