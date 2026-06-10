import 'package:task_manager/data/models/task_model.dart';

/// Abstract data source for local task storage
abstract class LocalTaskDataSource {
  /// Initialize the data source
  Future<void> init();

  /// Get all tasks from local storage
  Future<List<TaskModel>> getAllTasks();

  /// Create a new task in local storage
  Future<TaskModel> createTask(TaskModel taskModel);

  /// Update an existing task in local storage
  Future<TaskModel> updateTask(TaskModel taskModel);

  /// Delete a task from local storage
  Future<void> deleteTask(String taskId);

  /// Delete all tasks
  Future<void> deleteAllTasks();

  /// Get a specific task by ID
  Future<TaskModel?> getTaskById(String taskId);

  /// Check if task exists
  Future<bool> taskExists(String taskId);
}
