class FeeSummary {
  const FeeSummary({
    required this.blocked,
    this.totalDue = 0,
  });

  final bool blocked;
  final int totalDue;

  factory FeeSummary.fromJson(Map<String, dynamic> json) {
    return FeeSummary(
      blocked: _readBool(json["blocked"] ?? json["is_blocked"]),
      totalDue: _readInt(json["total_due"] ?? json["amount_due"]),
    );
  }
}

int _readInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is double) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

bool _readBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  if (value is String) {
    return value.toLowerCase() == "true" || value == "1";
  }
  if (value is num) {
    return value != 0;
  }
  return false;
}
