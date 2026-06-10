import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/presentation/providers/filter_provider.dart';
import 'package:task_manager/presentation/providers/task_list_provider.dart';
import 'package:task_manager/presentation/screens/add_edit_task_screen.dart';
import 'package:task_manager/presentation/widgets/empty_state_widget.dart';
import 'package:task_manager/presentation/widgets/error_state_widget.dart';
import 'package:task_manager/presentation/widgets/gravity_list_item.dart';
import 'package:task_manager/presentation/widgets/loading_widget.dart';
import 'package:task_manager/presentation/widgets/task_card.dart';

class FilteredTaskListScreen extends StatelessWidget {
  final TaskFilter filter;
  final String title;

  const FilteredTaskListScreen({
    super.key,
    required this.filter,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBase,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.backgroundDeep.withOpacity(0.6),
                border: Border(
                  bottom: BorderSide(
                      color: AppTheme.dividerColor.withOpacity(0.5), width: 1),
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.only(left: 16),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.dividerColor),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppTheme.textSecondary, size: 16),
                  ),
                ),
                title: Text(
                  title,
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                centerTitle: true,
              ),
            ),
          ),
        ),
      ),
      body: GravityBackground(
        child: SafeArea(
          child: Consumer<TaskListProvider>(
            builder: (context, taskProvider, _) {
              final state = taskProvider.state;
              final allTasks = state.tasks ?? [];
              final tasks = filter == TaskFilter.completed
                  ? allTasks.where((t) => t.isCompleted).toList()
                  : allTasks.where((t) => !t.isCompleted).toList();

              if (state.isLoadingData) {
                return const LoadingWidget(message: 'Loading tasks...');
              }
              if (state.hasError) {
                return ErrorStateWidget(
                  message: state.errorMessage ?? 'Failed to load tasks',
                  onRetry: () => taskProvider.loadTasks(),
                );
              }

              if (tasks.isEmpty) {
                return EmptyStateWidget(
                  title: filter == TaskFilter.completed
                      ? 'No Completed Tasks'
                      : 'No Pending Tasks',
                  subtitle: filter == TaskFilter.completed
                      ? 'Complete some tasks to see them here'
                      : 'All caught up! 🎉',
                  icon: filter == TaskFilter.completed
                      ? Icons.check_circle_rounded
                      : Icons.done_all_rounded,
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      children: [
                        Text(
                          '${tasks.length} task${tasks.length == 1 ? '' : 's'}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: filter == TaskFilter.completed
                                ? AppTheme.successColor
                                : AppTheme.warningColor,
                            boxShadow: [
                              BoxShadow(
                                color: (filter == TaskFilter.completed
                                        ? AppTheme.successColor
                                        : AppTheme.warningColor)
                                    .withOpacity(0.6),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 80, top: 4),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return GravityListItem(
                          index: index,
                          child: TaskCard(
                            task: task,
                            onToggleComplete: () async {
                              await context
                                  .read<TaskListProvider>()
                                  .toggleTaskCompletion(task.id);
                            },
                            onEdit: () async {
                              final result =
                                  await Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      AddEditTaskScreen(task: task),
                                  transitionsBuilder:
                                      (_, animation, __, child) =>
                                          SlideTransition(
                                    position: animation.drive(
                                      Tween(
                                              begin: const Offset(1, 0),
                                              end: Offset.zero)
                                          .chain(CurveTween(
                                              curve: Curves.easeOutCubic)),
                                    ),
                                    child: child,
                                  ),
                                  transitionDuration:
                                      const Duration(milliseconds: 350),
                                ),
                              );
                              if (result == true && context.mounted) {
                                context.read<TaskListProvider>().loadTasks();
                              }
                            },
                            onDelete: () async {
                              await context
                                  .read<TaskListProvider>()
                                  .deleteTask(task.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                  ..clearSnackBars()
                                  ..showSnackBar(SnackBar(
                                    content: const Text('Task deleted'),
                                    duration: const Duration(seconds: 4),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () async {
                                        await context
                                            .read<TaskListProvider>()
                                            .createTask(task);
                                      },
                                    ),
                                  ));
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
