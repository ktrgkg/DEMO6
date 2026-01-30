import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/models/fee.dart";
import "../../../core/network/error_message.dart";
import "../../../core/repositories/fee_repository.dart";

class AdminFeesState {
  const AdminFeesState({
    required this.status,
    required this.fees,
    this.isSubmitting = false,
  });

  final String status;
  final List<Fee> fees;
  final bool isSubmitting;

  AdminFeesState copyWith({
    String? status,
    List<Fee>? fees,
    bool? isSubmitting,
  }) {
    return AdminFeesState(
      status: status ?? this.status,
      fees: fees ?? this.fees,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class AdminFeesController extends AutoDisposeAsyncNotifier<AdminFeesState> {
  @override
  Future<AdminFeesState> build() async {
    return _fetchFees("unpaid");
  }

  Future<AdminFeesState> _fetchFees(String status) async {
    final repository = ref.read(feeRepositoryProvider);
    final fees = await repository.adminFees(status: status);
    return AdminFeesState(status: status, fees: fees);
  }

  Future<void> refresh() async {
    final current = state.valueOrNull;
    final status = current?.status ?? "unpaid";
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchFees(status));
  }

  Future<void> updateStatus(String status) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchFees(status));
  }

  Future<String?> markPaid(String feeId, Map<String, dynamic> payload) async {
    final current = state.valueOrNull;
    if (current == null) {
      return genericErrorMessage;
    }
    state = AsyncData(current.copyWith(isSubmitting: true));
    try {
      final repository = ref.read(feeRepositoryProvider);
      final updatedFee = await repository.adminMarkPaid(feeId, payload);
      final updatedFees = current.status == "paid"
          ? current.fees
              .map((fee) => fee.id == updatedFee.id ? updatedFee : fee)
              .toList()
          : current.fees.where((fee) => fee.id != updatedFee.id).toList();
      state = AsyncData(
        current.copyWith(fees: updatedFees, isSubmitting: false),
      );
      return null;
    } on DioException catch (error) {
      state = AsyncData(current.copyWith(isSubmitting: false));
      return mapErrorToMessage(error);
    } catch (_) {
      state = AsyncData(current.copyWith(isSubmitting: false));
      return genericErrorMessage;
    }
  }

  String? errorMessage(Object error) {
    return mapErrorToMessage(error);
  }
}

final adminFeesControllerProvider =
    AutoDisposeAsyncNotifierProvider<AdminFeesController, AdminFeesState>(
  AdminFeesController.new,
);
