import "../../../core/models/enums.dart";
import "../../../core/models/user_lite.dart";

class WorkerJobFilters {
  const WorkerJobFilters({
    required this.province,
    this.district = "",
    this.jobType,
    this.minPrice,
    this.maxPrice,
    this.keyword = "",
  });

  final Province province;
  final String district;
  final JobType? jobType;
  final int? minPrice;
  final int? maxPrice;
  final String keyword;

  factory WorkerJobFilters.defaultForUser(UserLite? user) {
    return WorkerJobFilters(
      province: user?.province ?? Province.anGiang,
      district: user?.district ?? "",
    );
  }

  WorkerJobFilters copyWith({
    Province? province,
    String? district,
    JobType? jobType,
    int? minPrice,
    int? maxPrice,
    String? keyword,
    bool clearJobType = false,
  }) {
    return WorkerJobFilters(
      province: province ?? this.province,
      district: district ?? this.district,
      jobType: clearJobType ? null : jobType ?? this.jobType,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      keyword: keyword ?? this.keyword,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{
      "province": provinceToString(province),
      "status": "open",
    };
    if (district.trim().isNotEmpty) {
      params["district"] = district.trim();
    }
    if (jobType != null) {
      params["job_type"] = jobTypeToString(jobType!);
    }
    if (minPrice != null) {
      params["min_price"] = minPrice;
    }
    if (maxPrice != null) {
      params["max_price"] = maxPrice;
    }
    if (keyword.trim().isNotEmpty) {
      params["keyword"] = keyword.trim();
    }
    return params;
  }
}
