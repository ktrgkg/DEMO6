import "enums.dart";

class UserLite {
  const UserLite({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.province,
    required this.district,
    this.status,
  });

  final String id;
  final String name;
  final String phone;
  final UserRole role;
  final Province province;
  final String district;
  final String? status;

  UserLite copyWith({
    String? id,
    String? name,
    String? phone,
    UserRole? role,
    Province? province,
    String? district,
    String? status,
  }) {
    return UserLite(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      province: province ?? this.province,
      district: district ?? this.district,
      status: status ?? this.status,
    );
  }

  factory UserLite.fromJson(Map<String, dynamic> json) {
    return UserLite(
      id: json["id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      phone: json["phone"]?.toString() ?? "",
      role: userRoleFromString(json["role"]?.toString()),
      province: provinceFromString(json["province"]?.toString()),
      district: json["district"]?.toString() ?? "",
      status: json["status"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "role": userRoleToString(role),
      "province": provinceToString(province),
      "district": district,
      "status": status,
    };
  }
}
