import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../core/auth/auth_state.dart";
import "../../../core/models/enums.dart";
import "../../../core/models/job.dart";
import "../../worker/widgets/job_labels.dart";
import "../controllers/create_edit_job_controller.dart";

class CreateEditJobScreen extends ConsumerStatefulWidget {
  const CreateEditJobScreen({super.key, this.job});

  final Job? job;

  @override
  ConsumerState<CreateEditJobScreen> createState() =>
      _CreateEditJobScreenState();
}

class _CreateEditJobScreenState extends ConsumerState<CreateEditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _districtController;
  late final TextEditingController _priceController;

  JobType? _jobType;
  Province? _province;
  PaymentType? _paymentType;

  @override
  void initState() {
    super.initState();
    final job = widget.job;
    _titleController = TextEditingController(text: job?.title ?? "");
    _descriptionController = TextEditingController(text: job?.description ?? "");
    _districtController = TextEditingController(text: job?.district ?? "");
    _priceController = TextEditingController(
      text: job == null ? "" : job.price.toString(),
    );
    _jobType = job?.jobType;
    _province = job?.province ??
        ref.read(authSessionProvider).user?.province ??
        Province.anGiang;
    _paymentType = job?.paymentType;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _districtController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final jobType = _jobType;
    final province = _province;
    final paymentType = _paymentType;
    if (jobType == null || province == null || paymentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn đầy đủ thông tin.")),
      );
      return;
    }
    final price = int.tryParse(_priceController.text.trim()) ?? 0;
    final message = await ref.read(createEditJobControllerProvider.notifier).submit(
          job: widget.job,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          jobType: jobType,
          province: province,
          district: _districtController.text.trim(),
          price: price,
          paymentType: paymentType,
        );
    if (!mounted) {
      return;
    }
    if (message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createEditJobControllerProvider);
    final job = widget.job;
    final isEditing = job != null;
    final canEdit = job == null ||
        job.status == JobStatus.draft ||
        job.status == JobStatus.open;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Chỉnh sửa job" : "Tạo job"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _titleController,
              enabled: canEdit,
              decoration: const InputDecoration(labelText: "Tiêu đề *"),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Vui lòng nhập tiêu đề.";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              enabled: canEdit,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Mô tả"),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<JobType>(
              value: _jobType,
              decoration: const InputDecoration(labelText: "Loại việc *"),
              items: const [
                DropdownMenuItem(
                  value: JobType.shift,
                  child: Text("Ca làm"),
                ),
                DropdownMenuItem(
                  value: JobType.task,
                  child: Text("Công việc"),
                ),
                DropdownMenuItem(
                  value: JobType.shortTerm,
                  child: Text("Ngắn hạn"),
                ),
              ],
              onChanged: canEdit
                  ? (value) {
                      setState(() {
                        _jobType = value;
                      });
                    }
                  : null,
              validator: (value) {
                if (value == null) {
                  return "Vui lòng chọn loại việc.";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Province>(
              value: _province,
              decoration: const InputDecoration(labelText: "Tỉnh *"),
              items: const [
                DropdownMenuItem(
                  value: Province.anGiang,
                  child: Text("An Giang"),
                ),
                DropdownMenuItem(
                  value: Province.kienGiang,
                  child: Text("Kiên Giang"),
                ),
              ],
              onChanged: canEdit
                  ? (value) {
                      setState(() {
                        _province = value;
                      });
                    }
                  : null,
              validator: (value) {
                if (value == null) {
                  return "Vui lòng chọn tỉnh.";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _districtController,
              enabled: canEdit,
              decoration: const InputDecoration(labelText: "Huyện/Thành phố"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              enabled: canEdit,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Giá *"),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Vui lòng nhập giá.";
                }
                final parsed = int.tryParse(value.trim());
                if (parsed == null || parsed <= 0) {
                  return "Giá phải là số hợp lệ.";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PaymentType>(
              value: _paymentType,
              decoration: const InputDecoration(labelText: "Thanh toán *"),
              items: const [
                DropdownMenuItem(
                  value: PaymentType.cash,
                  child: Text("Tiền mặt"),
                ),
                DropdownMenuItem(
                  value: PaymentType.transfer,
                  child: Text("Chuyển khoản"),
                ),
              ],
              onChanged: canEdit
                  ? (value) {
                      setState(() {
                        _paymentType = value;
                      });
                    }
                  : null,
              validator: (value) {
                if (value == null) {
                  return "Vui lòng chọn hình thức thanh toán.";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            if (!canEdit)
              Text(
                "Job chỉ có thể chỉnh sửa khi ở trạng thái Nháp hoặc Đang mở.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (canEdit)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isSubmitting ? null : _submit,
                  child: state.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEditing ? "Lưu thay đổi" : "Lưu nháp"),
                ),
              ),
            const SizedBox(height: 12),
            if (job != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Trạng thái hiện tại: ${jobStatusLabel(job.status)}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
