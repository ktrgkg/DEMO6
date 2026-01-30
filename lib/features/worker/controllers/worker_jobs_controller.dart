import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/auth/auth_state.dart";
import "../../../core/models/job.dart";
import "../../../core/network/dio_error_mapper.dart";
import "../../../core/repositories/job_repository.dart";
import "../models/worker_job_filters.dart";

class WorkerJobsState {
  const WorkerJobsState({
    required this.jobs,
    required this.filters,
  });

  final List<Job> jobs;
  final WorkerJobFilters filters;

  WorkerJobsState copyWith({
    List<Job>? jobs,
    WorkerJobFilters? filters,
  }) {
    return WorkerJobsState(
      jobs: jobs ?? this.jobs,
      filters: filters ?? this.filters,
    );
  }
}

class WorkerJobsController extends AutoDisposeAsyncNotifier<WorkerJobsState> {
  @override
  Future<WorkerJobsState> build() async {
    final authState = ref.watch(authSessionProvider);
    final filters = WorkerJobFilters.defaultForUser(authState.user);
    return _fetchJobs(filters);
  }

  Future<WorkerJobsState> _fetchJobs(WorkerJobFilters filters) async {
    final repository = ref.read(jobRepositoryProvider);
    final jobs = await repository.listJobs(
      filters: filters.toQueryParameters(),
    );
    return WorkerJobsState(jobs: jobs, filters: filters);
  }

  Future<void> refresh() async {
    final current = state.valueOrNull;
    final filters = current?.filters ??
        WorkerJobFilters.defaultForUser(ref.read(authSessionProvider).user);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchJobs(filters));
  }

  Future<void> applyFilters(WorkerJobFilters filters) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchJobs(filters));
  }

  Future<void> updateKeyword(String keyword) async {
    final current = state.valueOrNull;
    final filters = (current?.filters ??
            WorkerJobFilters.defaultForUser(
              ref.read(authSessionProvider).user,
            ))
        .copyWith(keyword: keyword);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchJobs(filters));
  }

  Future<void> resetFilters() async {
    final authState = ref.read(authSessionProvider);
    final filters = WorkerJobFilters.defaultForUser(authState.user);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchJobs(filters));
  }

  String? errorMessage(Object error) {
    if (error is DioException) {
      return mapDioExceptionToMessage(error);
    }
    return "Đã có lỗi xảy ra. Vui lòng thử lại.";
  }
}

final workerJobsControllerProvider =
    AutoDisposeAsyncNotifierProvider<WorkerJobsController, WorkerJobsState>(
  WorkerJobsController.new,
);
