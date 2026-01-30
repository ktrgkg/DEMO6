enum UserRole { admin, poster, worker }

enum Province { anGiang, kienGiang }

enum JobType { shift, task, shortTerm }

enum PaymentType { cash, transfer }

enum JobStatus { draft, open, accepted, working, completed, cancelled }

UserRole userRoleFromString(String? value) {
  switch (value) {
    case "admin":
      return UserRole.admin;
    case "poster":
      return UserRole.poster;
    case "worker":
      return UserRole.worker;
    default:
      return UserRole.worker;
  }
}

String userRoleToString(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return "admin";
    case UserRole.poster:
      return "poster";
    case UserRole.worker:
      return "worker";
  }
}

Province provinceFromString(String? value) {
  switch (value) {
    case "AG":
      return Province.anGiang;
    case "KG":
      return Province.kienGiang;
    default:
      return Province.anGiang;
  }
}

String provinceToString(Province province) {
  switch (province) {
    case Province.anGiang:
      return "AG";
    case Province.kienGiang:
      return "KG";
  }
}

JobType jobTypeFromString(String? value) {
  switch (value) {
    case "shift":
      return JobType.shift;
    case "task":
      return JobType.task;
    case "short_term":
      return JobType.shortTerm;
    default:
      return JobType.task;
  }
}

String jobTypeToString(JobType type) {
  switch (type) {
    case JobType.shift:
      return "shift";
    case JobType.task:
      return "task";
    case JobType.shortTerm:
      return "short_term";
  }
}

PaymentType paymentTypeFromString(String? value) {
  switch (value) {
    case "cash":
      return PaymentType.cash;
    case "transfer":
      return PaymentType.transfer;
    default:
      return PaymentType.cash;
  }
}

String paymentTypeToString(PaymentType type) {
  switch (type) {
    case PaymentType.cash:
      return "cash";
    case PaymentType.transfer:
      return "transfer";
  }
}

JobStatus jobStatusFromString(String? value) {
  switch (value) {
    case "draft":
      return JobStatus.draft;
    case "open":
      return JobStatus.open;
    case "accepted":
      return JobStatus.accepted;
    case "working":
      return JobStatus.working;
    case "completed":
      return JobStatus.completed;
    case "cancelled":
      return JobStatus.cancelled;
    default:
      return JobStatus.draft;
  }
}

String jobStatusToString(JobStatus status) {
  switch (status) {
    case JobStatus.draft:
      return "draft";
    case JobStatus.open:
      return "open";
    case JobStatus.accepted:
      return "accepted";
    case JobStatus.working:
      return "working";
    case JobStatus.completed:
      return "completed";
    case JobStatus.cancelled:
      return "cancelled";
  }
}
