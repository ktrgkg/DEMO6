import "package:flutter/material.dart";

import "../../../core/models/job.dart";
import "../../worker/widgets/job_labels.dart";
import "../../worker/widgets/job_status_badge.dart";

class PosterJobCard extends StatelessWidget {
  const PosterJobCard({
    super.key,
    required this.job,
    required this.onTap,
  });

  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final worker = job.worker;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      job.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 12),
                  JobStatusBadge(status: job.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "${provinceLabel(job.province)} • ${job.district}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                "Giá: ${job.price} đ",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                "Thanh toán: ${paymentTypeLabel(job.paymentType)}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (worker != null && worker.name.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  "Ứng viên: ${worker.name}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (worker.phone.isNotEmpty)
                  Text(
                    "SĐT: ${worker.phone}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
