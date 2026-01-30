import "../../../core/constants/app_strings.dart";
import "../../../core/models/enums.dart";

String provinceLabel(Province province) {
  switch (province) {
    case Province.anGiang:
      return AppStrings.provinceAnGiang;
    case Province.kienGiang:
      return AppStrings.provinceKienGiang;
  }
}

String jobTypeLabel(JobType type) {
  switch (type) {
    case JobType.shift:
      return "Ca làm";
    case JobType.task:
      return "Công việc";
    case JobType.shortTerm:
      return "Ngắn hạn";
  }
}

String paymentTypeLabel(PaymentType type) {
  switch (type) {
    case PaymentType.cash:
      return "Tiền mặt";
    case PaymentType.transfer:
      return "Chuyển khoản";
  }
}

String jobStatusLabel(JobStatus status) {
  switch (status) {
    case JobStatus.draft:
      return "Nháp";
    case JobStatus.open:
      return "Đang tuyển";
    case JobStatus.accepted:
      return "Đã nhận";
    case JobStatus.working:
      return "Đang làm";
    case JobStatus.completed:
      return "Hoàn tất";
    case JobStatus.cancelled:
      return "Đã hủy";
  }
}
