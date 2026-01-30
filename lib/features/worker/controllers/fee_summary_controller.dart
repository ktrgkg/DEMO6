import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/models/fee_summary.dart";
import "../../../core/network/dio_error_mapper.dart";
import "../../../core/repositories/fee_repository.dart";

class FeeSummaryController extends AutoDisposeAsyncNotifier<FeeSummary> {
  @override
  Future<FeeSummary> build() async {
    return _fetchSummary();
  }

  Future<FeeSummary> _fetchSummary() async {
    final repository = ref.read(feeRepositoryProvider);
    final data = await repository.myFeeSummary();
    return FeeSummary.fromJson(data);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchSummary);
  }

  String? errorMessage(Object error) {
    if (error is DioException) {
      return mapDioExceptionToMessage(error);
    }
    return "Đã có lỗi xảy ra. Vui lòng thử lại.";
  }
}

final feeSummaryProvider =
    AutoDisposeAsyncNotifierProvider<FeeSummaryController, FeeSummary>(
  FeeSummaryController.new,
);
