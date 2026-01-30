import "package:dio/dio.dart";

String mapDioExceptionToMessage(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return "Kết nối quá thời gian. Vui lòng thử lại.";
    case DioExceptionType.connectionError:
      return "Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.";
    case DioExceptionType.badCertificate:
      return "Kết nối không an toàn. Vui lòng thử lại.";
    case DioExceptionType.cancel:
      return "Yêu cầu đã bị hủy.";
    case DioExceptionType.badResponse:
      final status = error.response?.statusCode ?? 0;
      if (status == 400) {
        return "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.";
      }
      if (status == 401 || status == 403) {
        return "Thông tin đăng nhập không đúng hoặc đã hết hạn.";
      }
      if (status >= 500) {
        return "Máy chủ đang gặp sự cố. Vui lòng thử lại sau.";
      }
      return "Yêu cầu thất bại. Vui lòng thử lại.";
    case DioExceptionType.unknown:
      return "Đã có lỗi xảy ra. Vui lòng thử lại.";
  }
}
