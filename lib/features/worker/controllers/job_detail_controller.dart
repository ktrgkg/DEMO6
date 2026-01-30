import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/models/job.dart";
import "../../../core/network/dio_error_mapper.dart";
import "../../../core/repositories/job_repository.dart";
import "fee_summary_controller.dart";
import "worker_jobs_controller.dart";

class JobDetailState {
  const JobDetailState({
    required this.job,
    this.isSubmitting = false,
  });

  final Job job;
  final bool isSubmitting;

  JobDetailState copyWith({
    Job? job,
    bool? isSubmitting,
  }) {
    return JobDetailState(
      job: job ?? this.job,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class JobDetailController
    extends AutoDisposeFamilyAsyncNotifier<JobDetailState, String> {
  late final String _jobId;

  @override
  Future<JobDetailState> build(String jobId) async {
    _jobId = jobId;
    final repository = ref.read(jobRepositoryProvider);
    final job = await repository.getJob(_jobId);
    return JobDetailState(job: job);
  }

  Future<String?> acceptJob() async {
    final current = state.valueOrNull;
    if (current == null) {
      return "Không thể tải thông tin công việc.";
    }
    state = AsyncData(current.copyWith(isSubmitting: true));
    try {
      final repository = ref.read(jobRepositoryProvider);
      final job = await repository.acceptJob(_jobId);
      state = AsyncData(current.copyWith(job: job, isSubmitting: false));
      ref.read(workerJobsControllerProvider.notifier).refresh();
      ref.read(feeSummaryProvider.notifier).refresh();
      return null;
    } on DioException catch (error) {
      state = AsyncData(current.copyWith(isSubmitting: false));
      return mapDioExceptionToMessage(error);
    } catch (_) {
      state = AsyncData(current.copyWith(isSubmitting: false));
      return "Đã có lỗi xảy ra. Vui lòng thử lại.";
    }
  }

  Future<String?> startJob() async {
    final current = state.valueOrNull;
    if (current == null) {
      return "Không thể tải thông tin công việc.";
    }
    state = AsyncData(current.copyWith(isSubmitting: true));
    try {
      final repository = ref.read(jobRepositoryProvider);
      final job = await repository.startJob(_jobId);
      state = AsyncData(current.copyWith(job: job, isSubmitting: false));
      ref.read(workerJobsControllerProvider.notifier).refresh();
      ref.read(feeSummaryProvider.notifier).refresh();
      return null;
    } on DioException catch (error) {
      state = AsyncData(current.copyWith(isSubmitting: false));
      return mapDioExceptionToMessage(error);
    } catch (_) {
      state = AsyncData(current.copyWith(isSubmitting: false));
      return "Đã có lỗi xảy ra. Vui lòng thử lại.";
    }
  }
}

final jobDetailControllerProvider =
    AutoDisposeAsyncNotifierProviderFamily<JobDetailController, JobDetailState, String>(
  JobDetailController.new,
);
