class Task {
  final String? id;
  final String title;
  final String? description;
  final DateTime? deadline;
  final List<String>? tags;
  final String priority;
  final String? estimatedTime;
  final bool completed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Task({
    this.id,
    required this.title,
    this.description,
    this.deadline,
    this.tags,
    this.priority = 'Medium',
    this.estimatedTime,
    this.completed = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      priority: json['priority'] ?? 'Medium',
      estimatedTime: json['estimatedTime'],
      completed: json['completed'] ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      if (description != null) 'description': description,
      if (deadline != null) 'deadline': deadline!.toIso8601String(),
      if (tags != null) 'tags': tags,
      'priority': priority,
      if (estimatedTime != null) 'estimatedTime': estimatedTime,
      'completed': completed,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    List<String>? tags,
    String? priority,
    String? estimatedTime,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
