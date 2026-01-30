class Fee {
  const Fee({
    required this.id,
    required this.jobId,
    required this.amount,
    required this.feeType,
    required this.status,
    this.jobTitle,
    this.userName,
    this.userPhone,
    this.note,
    this.paidAt,
    this.createdAt,
  });

  final String id;
  final String jobId;
  final int amount;
  final String feeType;
  final String status;
  final String? jobTitle;
  final String? userName;
  final String? userPhone;
  final String? note;
  final DateTime? paidAt;
  final DateTime? createdAt;

  Fee copyWith({
    String? id,
    String? jobId,
    int? amount,
    String? feeType,
    String? status,
    String? jobTitle,
    String? userName,
    String? userPhone,
    String? note,
    DateTime? paidAt,
    DateTime? createdAt,
  }) {
    return Fee(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      amount: amount ?? this.amount,
      feeType: feeType ?? this.feeType,
      status: status ?? this.status,
      jobTitle: jobTitle ?? this.jobTitle,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      note: note ?? this.note,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Fee.fromJson(Map<String, dynamic> json) {
    final jobData = json["job"];
    final userData = json["user"];
    return Fee(
      id: json["id"]?.toString() ?? "",
      jobId: json["job_id"]?.toString() ?? "",
      amount: _readInt(json["amount"]),
      feeType: json["fee_type"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "",
      jobTitle: json["job_title"]?.toString() ??
          (jobData is Map<String, dynamic> ? jobData["title"]?.toString() : null),
      userName: json["user_name"]?.toString() ??
          (userData is Map<String, dynamic> ? userData["name"]?.toString() : null),
      userPhone: json["user_phone"]?.toString() ??
          (userData is Map<String, dynamic> ? userData["phone"]?.toString() : null),
      note: json["note"]?.toString(),
      paidAt: _readDateTime(json["paid_at"]),
      createdAt: _readDateTime(json["created_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "job_id": jobId,
      "amount": amount,
      "fee_type": feeType,
      "status": status,
      "job_title": jobTitle,
      "user_name": userName,
      "user_phone": userPhone,
      "note": note,
      "paid_at": paidAt?.toIso8601String(),
      "created_at": createdAt?.toIso8601String(),
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
