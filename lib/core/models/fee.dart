class Fee {
  const Fee({
    required this.id,
    required this.jobId,
    required this.amount,
    required this.feeType,
    required this.status,
    this.note,
    this.paidAt,
  });

  final String id;
  final String jobId;
  final int amount;
  final String feeType;
  final String status;
  final String? note;
  final DateTime? paidAt;

  Fee copyWith({
    String? id,
    String? jobId,
    int? amount,
    String? feeType,
    String? status,
    String? note,
    DateTime? paidAt,
  }) {
    return Fee(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      amount: amount ?? this.amount,
      feeType: feeType ?? this.feeType,
      status: status ?? this.status,
      note: note ?? this.note,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      id: json["id"]?.toString() ?? "",
      jobId: json["job_id"]?.toString() ?? "",
      amount: _readInt(json["amount"]),
      feeType: json["fee_type"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "",
      note: json["note"]?.toString(),
      paidAt: _readDateTime(json["paid_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "job_id": jobId,
      "amount": amount,
      "fee_type": feeType,
      "status": status,
      "note": note,
      "paid_at": paidAt?.toIso8601String(),
    };
  }
}

int _readInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  if (value is double) {
    return value.toInt();
  }
  return 0;
}

DateTime? _readDateTime(dynamic value) {
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}
