import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/models/fee.dart";
import "../../../core/network/error_message.dart";
import "../../../core/repositories/fee_repository.dart";
import "fee_summary_controller.dart";

class WorkerFeesController extends AutoDisposeAsyncNotifier<List<Fee>> {
  @override
  Future<List<Fee>> build() async {
    return _fetchFees();
  }

  Future<List<Fee>> _fetchFees() async {
    final repository = ref.read(feeRepositoryProvider);
    return repository.myFees();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchFees);
  }

  Future<String?> submitPayment(
    String feeId,
    Map<String, dynamic> payload,
  ) async {
    final current = state.valueOrNull ?? [];
    try {
      final repository = ref.read(feeRepositoryProvider);
      final updatedFee = await repository.submitPayment(feeId, payload);
      final updatedList = current
          .map((fee) => fee.id == updatedFee.id ? updatedFee : fee)
          .toList();
      state = AsyncData(updatedList);
      await ref.read(feeSummaryProvider.notifier).refresh();
      return null;
    } on DioException catch (error) {
      return mapErrorToMessage(error);
    } catch (_) {
      return genericErrorMessage;
    }
  }

  String? errorMessage(Object error) {
    return mapErrorToMessage(error);
  }
}

final workerFeesControllerProvider =
    AutoDisposeAsyncNotifierProvider<WorkerFeesController, List<Fee>>(
  WorkerFeesController.new,
);
