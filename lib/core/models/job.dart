import "enums.dart";
import "user_lite.dart";

class Job {
  const Job({
    required this.id,
    required this.title,
    required this.description,
    required this.jobType,
    required this.province,
    required this.district,
    required this.price,
    required this.paymentType,
    required this.status,
    this.poster,
    this.worker,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final JobType jobType;
  final Province province;
  final String district;
  final int price;
  final PaymentType paymentType;
  final JobStatus status;
  final UserLite? poster;
  final UserLite? worker;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Job copyWith({
    String? id,
    String? title,
    String? description,
    JobType? jobType,
    Province? province,
    String? district,
    int? price,
    PaymentType? paymentType,
    JobStatus? status,
    UserLite? poster,
    UserLite? worker,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      jobType: jobType ?? this.jobType,
      province: province ?? this.province,
      district: district ?? this.district,
      price: price ?? this.price,
      paymentType: paymentType ?? this.paymentType,
      status: status ?? this.status,
      poster: poster ?? this.poster,
      worker: worker ?? this.worker,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json["id"]?.toString() ?? "",
      title: json["title"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      jobType: jobTypeFromString(json["job_type"]?.toString()),
      province: provinceFromString(json["province"]?.toString()),
      district: json["district"]?.toString() ?? "",
      price: _readInt(json["price"]),
      paymentType: paymentTypeFromString(json["payment_type"]?.toString()),
      status: jobStatusFromString(json["status"]?.toString()),
      poster: _readUser(json["poster"]),
      worker: _readUser(json["worker"]),
      createdAt: _readDateTime(json["created_at"]),
      updatedAt: _readDateTime(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "job_type": jobTypeToString(jobType),
      "province": provinceToString(province),
      "district": district,
      "price": price,
      "payment_type": paymentTypeToString(paymentType),
      "status": jobStatusToString(status),
      "poster": poster?.toJson(),
      "worker": worker?.toJson(),
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
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

UserLite? _readUser(dynamic value) {
  if (value is Map<String, dynamic>) {
    return UserLite.fromJson(value);
  }
  return null;
}

DateTime? _readDateTime(dynamic value) {
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}
