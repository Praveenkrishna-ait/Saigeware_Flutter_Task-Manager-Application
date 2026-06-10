import 'package:flutter/foundation.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/domain/repositories/task_repository.dart';

/// State class for task list
class TaskListState {
  final List<Task>? tasks;
  final bool isLoading;
  final String? errorMessage;

  TaskListState({this.tasks, this.isLoading = false, this.errorMessage});

  /// Success state with tasks
  factory TaskListState.success(List<Task> tasks) {
    return TaskListState(tasks: tasks, isLoading: false, errorMessage: null);
  }

  /// Loading state
  factory TaskListState.loading() {
    return TaskListState(tasks: null, isLoading: true, errorMessage: null);
  }

  /// Error state
  factory TaskListState.error(String message) {
    return TaskListState(tasks: null, isLoading: false, errorMessage: message);
  }

  /// Empty state
  factory TaskListState.empty() {
    return TaskListState(tasks: const [], isLoading: false, errorMessage: null);
  }

  /// Check if state is loading
  bool get isLoadingData => isLoading;

  /// Check if state has error
  bool get hasError => errorMessage != null;

  /// Check if state has tasks
  bool get hasTasks => tasks != null && tasks!.isNotEmpty;

  /// Check if state is empty
  bool get isEmpty => tasks != null && tasks!.isEmpty;
}

/// Provider for managing task list state and operations
class TaskListProvider extends ChangeNotifier {
  final TaskRepository _taskRepository;

  TaskListState _state = TaskListState.loading();
  SortBy _currentSort = SortBy.createdDate;

  TaskListProvider(this._taskRepository) {
    loadTasks();
  }

  /// Get current state
  TaskListState get state => _state;

  /// Get current sort
  SortBy get currentSort => _currentSort;

  /// Get current tasks
  List<Task>? get tasks => _state.tasks;

  /// Load all tasks
  Future<void> loadTasks() async {
    _state = TaskListState.loading();
    notifyListeners();

    try {
      final tasks = await _taskRepository.getAllTasks();
      if (tasks.isEmpty) {
        _state = TaskListState.empty();
      } else {
        final sortedTasks = await _taskRepository.sortTasks(tasks, _currentSort);
        _state = TaskListState.success(sortedTasks);
      }
    } catch (e) {
      _state = TaskListState.error(e.toString());
    }
    notifyListeners();
  }

  /// Get completed tasks
  Future<List<Task>> getCompletedTasks() async {
    try {
      return await _taskRepository.getCompletedTasks();
    } catch (e) {
      _state = TaskListState.error(e.toString());
      notifyListeners();
      return [];
    }
  }

  /// Get pending tasks
  Future<List<Task>> getPendingTasks() async {
    try {
      return await _taskRepository.getPendingTasks();
    } catch (e) {
      _state = TaskListState.error(e.toString());
      notifyListeners();
      return [];
    }
  }

  /// Create a new task
  Future<void> createTask(Task task) async {
    try {
      await _taskRepository.createTask(task);
      await loadTasks();
    } catch (e) {
      _state = TaskListState.error('Failed to create task: $e');
      notifyListeners();
    }
  }

  /// Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      await _taskRepository.updateTask(task);
      await loadTasks();
    } catch (e) {
      _state = TaskListState.error('Failed to update task: $e');
      notifyListeners();
    }
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskRepository.deleteTask(taskId);
      await loadTasks();
    } catch (e) {
      _state = TaskListState.error('Failed to delete task: $e');
      notifyListeners();
    }
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      await _taskRepository.toggleTaskCompletion(taskId);
      await loadTasks();
    } catch (e) {
      _state = TaskListState.error('Failed to toggle task: $e');
      notifyListeners();
    }
  }

  /// Search tasks
  Future<List<Task>> searchTasks(String query) async {
    try {
      return await _taskRepository.searchTasks(query);
    } catch (e) {
      _state = TaskListState.error('Failed to search tasks: $e');
      notifyListeners();
      return [];
    }
  }

  /// Refresh tasks
  Future<void> refreshTasks() async {
    await loadTasks();
  }

  /// Set sort option
  Future<void> setSortBy(SortBy sortBy) async {
    _currentSort = sortBy;
    if (_state.tasks != null && _state.tasks!.isNotEmpty) {
      final sortedTasks = await _taskRepository.sortTasks(_state.tasks!, sortBy);
      _state = TaskListState.success(sortedTasks);
      notifyListeners();
    }
  }
}
