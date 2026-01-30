import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/models/fee_summary.dart";
import "../../../core/network/error_message.dart";
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
    return mapErrorToMessage(error);
  }
}

final feeSummaryProvider =
    AutoDisposeAsyncNotifierProvider<FeeSummaryController, FeeSummary>(
  FeeSummaryController.new,
);
