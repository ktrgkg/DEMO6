import "package:flutter/material.dart";

import "../../../core/constants/app_strings.dart";
import "../../../core/models/enums.dart";
import "../models/worker_job_filters.dart";
import "job_labels.dart";

class WorkerJobFilterSheet extends StatefulWidget {
  const WorkerJobFilterSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
    required this.onReset,
  });

  final WorkerJobFilters initialFilters;
  final ValueChanged<WorkerJobFilters> onApply;
  final VoidCallback onReset;

  @override
  State<WorkerJobFilterSheet> createState() => _WorkerJobFilterSheetState();
}

class _WorkerJobFilterSheetState extends State<WorkerJobFilterSheet> {
  late Province _province;
  late JobType? _jobType;
  late TextEditingController _districtController;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    final filters = widget.initialFilters;
    _province = filters.province;
    _jobType = filters.jobType;
    _districtController = TextEditingController(text: filters.district);
    _minPriceController =
        TextEditingController(text: _priceText(filters.minPrice));
    _maxPriceController =
        TextEditingController(text: _priceText(filters.maxPrice));
  }

  @override
  void dispose() {
    _districtController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Bộ lọc công việc",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Province>(
              value: _province,
              items: Province.values
                  .map(
                    (province) => DropdownMenuItem(
                      value: province,
                      child: Text(provinceLabel(province)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() => _province = value);
              },
              decoration: const InputDecoration(
                labelText: AppStrings.provinceLabel,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _districtController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: AppStrings.districtLabel,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<JobType?>(
              value: _jobType,
              items: [
                const DropdownMenuItem<JobType?>(
                  value: null,
                  child: Text("Tất cả loại việc"),
                ),
                ...JobType.values.map(
                  (type) => DropdownMenuItem<JobType?>(
                    value: type,
                    child: Text(jobTypeLabel(type)),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _jobType = value),
              decoration: const InputDecoration(
                labelText: "Loại công việc",
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Giá tối thiểu",
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Giá tối đa",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    widget.onReset();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Đặt lại"),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    widget.onApply(_buildFilters());
                    Navigator.of(context).pop();
                  },
                  child: const Text("Áp dụng"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  WorkerJobFilters _buildFilters() {
    return widget.initialFilters.copyWith(
      province: _province,
      district: _districtController.text.trim(),
      jobType: _jobType,
      clearJobType: _jobType == null,
      minPrice: _parseInt(_minPriceController.text),
      maxPrice: _parseInt(_maxPriceController.text),
    );
  }

  String _priceText(int? value) => value == null ? "" : value.toString();

  int? _parseInt(String value) {
    if (value.trim().isEmpty) {
      return null;
    }
    return int.tryParse(value.trim());
  }
}
