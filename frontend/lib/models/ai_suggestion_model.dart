class PrioritizedTask {
  final String id;
  final String priority;
  final String reason;

  PrioritizedTask({
    required this.id,
    required this.priority,
    required this.reason,
  });

  factory PrioritizedTask.fromJson(Map<String, dynamic> json) {
    return PrioritizedTask(
      id: json['id'],
      priority: json['priority'],
      reason: json['reason'],
    );
  }
}

class PrioritizationResponse {
  final String message;
  final List<PrioritizedTask> prioritizedTasks;

  PrioritizationResponse({
    required this.message,
    required this.prioritizedTasks,
  });

  factory PrioritizationResponse.fromJson(Map<String, dynamic> json) {
    return PrioritizationResponse(
      message: json['message'],
      prioritizedTasks: (json['prioritizedTasks'] as List)
          .map((task) => PrioritizedTask.fromJson(task))
          .toList(),
    );
  }
}

class TimeEstimateResponse {
  final String message;
  final String estimatedTime;

  TimeEstimateResponse({
    required this.message,
    required this.estimatedTime,
  });

  factory TimeEstimateResponse.fromJson(Map<String, dynamic> json) {
    return TimeEstimateResponse(
      message: json['message'],
      estimatedTime: json['estimatedTime'],
    );
  }
}

class TaskRewriteResponse {
  final String message;
  final String rewrittenTitle;
  final String rewrittenDescription;

  TaskRewriteResponse({
    required this.message,
    required this.rewrittenTitle,
    required this.rewrittenDescription,
  });

  factory TaskRewriteResponse.fromJson(Map<String, dynamic> json) {
    return TaskRewriteResponse(
      message: json['message'],
      rewrittenTitle: json['rewrittenTitle'],
      rewrittenDescription: json['rewrittenDescription'],
    );
  }
}
