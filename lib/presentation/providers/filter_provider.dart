import 'package:flutter/foundation.dart';

/// Enum for filter options
enum TaskFilter { all, completed, pending }

/// Provider for managing task filter state
class FilterProvider extends ChangeNotifier {
  TaskFilter _currentFilter = TaskFilter.all;

  /// Get current filter
  TaskFilter get currentFilter => _currentFilter;

  /// Check if showing all tasks
  bool get showAll => _currentFilter == TaskFilter.all;

  /// Check if showing completed tasks
  bool get showCompleted => _currentFilter == TaskFilter.completed;

  /// Check if showing pending tasks
  bool get showPending => _currentFilter == TaskFilter.pending;

  /// Set filter
  void setFilter(TaskFilter filter) {
    if (_currentFilter != filter) {
      _currentFilter = filter;
      notifyListeners();
    }
  }

  /// Reset to all tasks
  void resetFilter() {
    _currentFilter = TaskFilter.all;
    notifyListeners();
  }
}
