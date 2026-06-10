/// Priority enum for tasks
enum Priority { low, medium, high }

/// Task entity representing a task in the domain layer
class Task {
  /// Unique identifier
  final String id;

  /// Task title (required)
  final String title;

  /// Task description (optional)
  final String? description;

  /// Due date (optional)
  final DateTime? dueDate;

  /// Priority level
  final Priority priority;

  /// Whether the task is completed
  final bool isCompleted;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy of this task with modified fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          dueDate == other.dueDate &&
          priority == other.priority &&
          isCompleted == other.isCompleted &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      dueDate.hashCode ^
      priority.hashCode ^
      isCompleted.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'Task(id: $id, title: $title, priority: $priority, isCompleted: $isCompleted)';
}
