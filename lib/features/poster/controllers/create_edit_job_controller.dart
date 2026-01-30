import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/models/enums.dart";
import "../../../core/models/job.dart";
import "../../../core/network/error_message.dart";
import "../../../core/repositories/job_repository.dart";
import "../../worker/controllers/job_detail_controller.dart";
import "poster_jobs_controller.dart";

class CreateEditJobState {
  const CreateEditJobState({this.isSubmitting = false});

  final bool isSubmitting;

  CreateEditJobState copyWith({bool? isSubmitting}) {
    return CreateEditJobState(isSubmitting: isSubmitting ?? this.isSubmitting);
  }
}

class CreateEditJobController extends AutoDisposeNotifier<CreateEditJobState> {
  @override
  CreateEditJobState build() {
    return const CreateEditJobState();
  }

  Future<String?> submit({
    Job? job,
    required String title,
    required String description,
    required JobType jobType,
    required Province province,
    required String district,
    required int price,
    required PaymentType paymentType,
  }) async {
    state = state.copyWith(isSubmitting: true);
    try {
      final repository = ref.read(jobRepositoryProvider);
      final payload = {
        "title": title,
        "description": description,
        "job_type": jobTypeToString(jobType),
        "province": provinceToString(province),
        "district": district,
        "price": price,
        "payment_type": paymentTypeToString(paymentType),
      };
      if (job == null) {
        await repository.createJob(payload);
      } else {
        await repository.updateJob(job.id, payload);
      }
      ref.invalidate(posterJobsControllerProvider);
      if (job != null) {
        ref.invalidate(jobDetailControllerProvider(job.id));
      }
      state = state.copyWith(isSubmitting: false);
      return null;
    } on DioException catch (error) {
      state = state.copyWith(isSubmitting: false);
      return mapErrorToMessage(error);
    } catch (_) {
      state = state.copyWith(isSubmitting: false);
      return genericErrorMessage;
    }
  }
}

final createEditJobControllerProvider =
    AutoDisposeNotifierProvider<CreateEditJobController, CreateEditJobState>(
  CreateEditJobController.new,
);
