import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/models/enums.dart";
import "../../../core/models/job.dart";
import "../../../core/network/dio_error_mapper.dart";
import "../../../core/repositories/job_repository.dart";

class PosterJobsState {
  const PosterJobsState({
    required this.jobs,
    required this.status,
  });

  final List<Job> jobs;
  final JobStatus status;

  PosterJobsState copyWith({
    List<Job>? jobs,
    JobStatus? status,
  }) {
    return PosterJobsState(
      jobs: jobs ?? this.jobs,
      status: status ?? this.status,
    );
  }
}

class PosterJobsController
    extends AutoDisposeFamilyAsyncNotifier<PosterJobsState, JobStatus> {
  @override
  Future<PosterJobsState> build(JobStatus status) async {
    return _fetchJobs(status);
  }

  Future<PosterJobsState> _fetchJobs(JobStatus status) async {
    final repository = ref.read(jobRepositoryProvider);
    final jobs = await repository.myJobs(status: jobStatusToString(status));
    return PosterJobsState(jobs: jobs, status: status);
  }

  Future<void> refresh() async {
    final current = state.valueOrNull;
    final status = current?.status ?? arg;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchJobs(status));
  }

  String? errorMessage(Object error) {
    if (error is DioException) {
      return mapDioExceptionToMessage(error);
    }
    return "Đã có lỗi xảy ra. Vui lòng thử lại.";
  }
}

final posterJobsControllerProvider = AutoDisposeAsyncNotifierProviderFamily<
    PosterJobsController, PosterJobsState, JobStatus>(
  PosterJobsController.new,
);
