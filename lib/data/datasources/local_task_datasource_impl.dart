import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/core/constants/app_constants.dart';
import 'package:task_manager/core/errors/exceptions.dart';
import 'package:task_manager/data/datasources/local_task_datasource.dart';
import 'package:task_manager/data/models/task_model.dart';

/// Implementation of LocalTaskDataSource using Hive
class LocalTaskDataSourceImpl implements LocalTaskDataSource {
  late Box<TaskModel> _taskBox;

  @override
  Future<void> init() async {
    try {
      if (!Hive.isBoxOpen(AppConstants.taskBoxName)) {
        _taskBox = await Hive.openBox<TaskModel>(AppConstants.taskBoxName);
      } else {
        _taskBox = Hive.box<TaskModel>(AppConstants.taskBoxName);
      }
    } catch (e) {
      throw DatabaseException('Failed to initialize task database: $e');
    }
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    try {
      return _taskBox.values.toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch tasks: $e');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel taskModel) async {
    try {
      await _taskBox.put(taskModel.id, taskModel);
      return taskModel;
    } catch (e) {
      throw DatabaseException('Failed to create task: $e');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel taskModel) async {
    try {
      if (!_taskBox.containsKey(taskModel.id)) {
        throw NotFoundException('Task with id ${taskModel.id} not found');
      }
      await _taskBox.put(taskModel.id, taskModel);
      return taskModel;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw DatabaseException('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      if (!_taskBox.containsKey(taskId)) {
        throw NotFoundException('Task with id $taskId not found');
      }
      await _taskBox.delete(taskId);
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw DatabaseException('Failed to delete task: $e');
    }
  }

  @override
  Future<void> deleteAllTasks() async {
    try {
      await _taskBox.clear();
    } catch (e) {
      throw DatabaseException('Failed to delete all tasks: $e');
    }
  }

  @override
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      return _taskBox.get(taskId);
    } catch (e) {
      throw DatabaseException('Failed to fetch task: $e');
    }
  }

  @override
  Future<bool> taskExists(String taskId) async {
    try {
      return _taskBox.containsKey(taskId);
    } catch (e) {
      throw DatabaseException('Failed to check task existence: $e');
    }
  }
}
