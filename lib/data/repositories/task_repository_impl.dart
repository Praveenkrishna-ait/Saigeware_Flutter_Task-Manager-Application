import 'package:task_manager/data/datasources/local_task_datasource.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/domain/repositories/task_repository.dart';

/// Implementation of TaskRepository using local data source
class TaskRepositoryImpl implements TaskRepository {
  final LocalTaskDataSource _localDataSource;

  TaskRepositoryImpl(this._localDataSource);

  @override
  Future<List<Task>> getAllTasks() async {
    final taskModels = await _localDataSource.getAllTasks();
    return taskModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Task>> getCompletedTasks() async {
    final taskModels = await _localDataSource.getAllTasks();
    return taskModels
        .where((model) => model.isCompleted)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<Task>> getPendingTasks() async {
    final taskModels = await _localDataSource.getAllTasks();
    return taskModels
        .where((model) => !model.isCompleted)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<Task> createTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    final createdModel = await _localDataSource.createTask(taskModel);
    return createdModel.toEntity();
  }

  @override
  Future<Task> updateTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    final updatedModel = await _localDataSource.updateTask(taskModel);
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _localDataSource.deleteTask(taskId);
  }

  @override
  Future<Task> toggleTaskCompletion(String taskId) async {
    final taskModel = await _localDataSource.getTaskById(taskId);
    if (taskModel == null) {
      throw Exception('Task not found');
    }
    final updatedModel = taskModel.copyWith(
      isCompleted: !taskModel.isCompleted,
      updatedAt: DateTime.now(),
    );
    return (await _localDataSource.updateTask(updatedModel)).toEntity();
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    final taskModels = await _localDataSource.getAllTasks();
    final lowerQuery = query.toLowerCase();
    return taskModels
        .where(
          (model) =>
              model.title.toLowerCase().contains(lowerQuery) ||
              (model.description?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<Task>> sortTasks(List<Task> tasks, SortBy sortBy) async {
    final sortedTasks = List<Task>.from(tasks);
    switch (sortBy) {
      case SortBy.priority:
        sortedTasks.sort(
          (a, b) => b.priority.index.compareTo(a.priority.index),
        );
      case SortBy.dueDate:
        sortedTasks.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
      case SortBy.createdDate:
        sortedTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case SortBy.title:
        sortedTasks.sort((a, b) => a.title.compareTo(b.title));
    }
    return sortedTasks;
  }

  @override
  Future<void> deleteAllTasks() async {
    await _localDataSource.deleteAllTasks();
  }
}
