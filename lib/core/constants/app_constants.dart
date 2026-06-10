/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Task Manager';
  static const String appVersion = '1.0.0';

  // Hive box names
  static const String taskBoxName = 'tasks';

  // Validation
  static const int minTitleLength = 1;
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;

  // Pagination
  static const int itemsPerPage = 20;

  // Durations
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);

  // Error messages
  static const String errorLoadingTasks = 'Failed to load tasks';
  static const String errorCreatingTask = 'Failed to create task';
  static const String errorUpdatingTask = 'Failed to update task';
  static const String errorDeletingTask = 'Failed to delete task';
  static const String errorTitleRequired = 'Task title is required';
  static const String errorTitleTooLong =
      'Task title must be less than $maxTitleLength characters';
  static const String errorUnexpected = 'An unexpected error occurred';

  // Success messages
  static const String successTaskCreated = 'Task created successfully';
  static const String successTaskUpdated = 'Task updated successfully';
  static const String successTaskDeleted = 'Task deleted successfully';
  static const String successTaskCompleted = 'Task marked as completed';
  static const String successTaskUncompleted = 'Task marked as pending';
}

/// String constants for UI
class AppStrings {
  AppStrings._();

  // Screen titles
  static const String allTasks = 'All Tasks';
  static const String completedTasks = 'Completed';
  static const String pendingTasks = 'Pending';
  static const String addNewTask = 'Add New Task';
  static const String editTask = 'Edit Task';

  // Form labels
  static const String taskTitle = 'Task Title';
  static const String description = 'Description (Optional)';
  static const String dueDate = 'Due Date';
  static const String priority = 'Priority';
  static const String selectPriority = 'Select Priority';

  // Buttons
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String create = 'Create';
  static const String edit = 'Edit';
  static const String undo = 'Undo';
  static const String ok = 'OK';

  // Filter buttons
  static const String filterAll = 'All';
  static const String filterCompleted = 'Completed';
  static const String filterPending = 'Pending';

  // Empty state
  static const String noTasksTitle = 'No Tasks Yet';
  static const String noTasksSubtitle = 'Create your first task to get started';
  static const String noCompletedTasks = 'No completed tasks';
  static const String noPendingTasks = 'No pending tasks';

  // Error state
  static const String errorTitle = 'Something Went Wrong';
  static const String errorSubtitle = 'Please try again later';
  static const String retry = 'Retry';

  // Priority labels
  static const String low = 'Low';
  static const String medium = 'Medium';
  static const String high = 'High';

  // Delete confirmation
  static const String deleteTaskTitle = 'Delete Task?';
  static const String deleteTaskMessage = 'This action cannot be undone.';
  static const String confirmDelete = 'Delete';

  // Misc
  static const String loading = 'Loading...';
  static const String noDescription = 'No description';
  static const String markAsCompleted = 'Mark as completed';
  static const String markAsIncomplete = 'Mark as incomplete';
}
