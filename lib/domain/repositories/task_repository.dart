import 'package:task_manager/domain/entities/task.dart';

/// Abstract repository interface for Task operations
abstract class TaskRepository {
  /// Get all tasks
  Future<List<Task>> getAllTasks();

  /// Get completed tasks only
  Future<List<Task>> getCompletedTasks();

  /// Get pending (incomplete) tasks only
  Future<List<Task>> getPendingTasks();

  /// Create a new task
  Future<Task> createTask(Task task);

  /// Update an existing task
  Future<Task> updateTask(Task task);

  /// Delete a task by ID
  Future<void> deleteTask(String taskId);

  /// Toggle task completion status
  Future<Task> toggleTaskCompletion(String taskId);

  /// Search tasks by title
  Future<List<Task>> searchTasks(String query);

  /// Sort tasks
  Future<List<Task>> sortTasks(List<Task> tasks, SortBy sortBy);

  /// Delete all tasks
  Future<void> deleteAllTasks();
}

/// Enum for sorting options
enum SortBy { priority, dueDate, createdDate, title }
