import "package:flutter/material.dart";

import "../../../core/models/enums.dart";
import "job_labels.dart";

class JobStatusBadge extends StatelessWidget {
  const JobStatusBadge({super.key, required this.status});

  final JobStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(context, status);
    return Chip(
      label: Text(jobStatusLabel(status)),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
      side: BorderSide(color: color.withOpacity(0.4)),
    );
  }
}

Color _statusColor(BuildContext context, JobStatus status) {
  switch (status) {
    case JobStatus.open:
      return Colors.green;
    case JobStatus.accepted:
      return Colors.blue;
    case JobStatus.working:
      return Colors.orange;
    case JobStatus.completed:
      return Colors.teal;
    case JobStatus.cancelled:
      return Colors.red;
    case JobStatus.draft:
      return Theme.of(context).colorScheme.outline;
  }
}
