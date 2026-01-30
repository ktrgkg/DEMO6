import "package:dio/dio.dart";

import "dio_error_mapper.dart";

const String genericErrorMessage = "Đã có lỗi xảy ra. Vui lòng thử lại.";

String mapErrorToMessage(Object error) {
  if (error is DioException) {
    return mapDioExceptionToMessage(error);
  }
  return genericErrorMessage;
}
