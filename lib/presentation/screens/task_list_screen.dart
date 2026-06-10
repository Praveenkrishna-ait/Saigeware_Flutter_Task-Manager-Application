import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/constants/app_constants.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/domain/repositories/task_repository.dart';
import 'package:task_manager/presentation/providers/filter_provider.dart';
import 'package:task_manager/presentation/providers/task_list_provider.dart';
import 'package:task_manager/presentation/screens/add_edit_task_screen.dart';
import 'package:task_manager/presentation/screens/filtered_task_list_screen.dart';
import 'package:task_manager/presentation/widgets/empty_state_widget.dart';
import 'package:task_manager/presentation/widgets/error_state_widget.dart';
import 'package:task_manager/presentation/widgets/gravity_list_item.dart';
import 'package:task_manager/presentation/widgets/loading_widget.dart';
import 'package:task_manager/presentation/widgets/task_card.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabGlow;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskListProvider>().loadTasks();
    });
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _fabGlow = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

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
                color: AppTheme.backgroundDeep.withValues(alpha: 0.6),
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.dividerColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentColor.withValues(alpha: 0.7),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppConstants.appName,
                      style: GoogleFonts.inter(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
                actions: [
                  Consumer<TaskListProvider>(
                    builder: (context, provider, _) {
                      return PopupMenuButton<SortBy>(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceElevated,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.dividerColor),
                          ),
                          child: const Icon(Icons.sort_rounded,
                              color: AppTheme.textSecondary, size: 18),
                        ),
                        tooltip: 'Sort tasks',
                        onSelected: provider.setSortBy,
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: SortBy.createdDate, child: Text('Created Date')),
                          PopupMenuItem(value: SortBy.dueDate, child: Text('Due Date')),
                          PopupMenuItem(value: SortBy.priority, child: Text('Priority')),
                          PopupMenuItem(value: SortBy.title, child: Text('Title')),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        ),
      ),
      body: GravityBackground(
        child: SafeArea(
          child: RefreshIndicator(
            color: AppTheme.primaryColor,
            backgroundColor: AppTheme.surfaceCard,
            onRefresh: () => context.read<TaskListProvider>().refreshTasks(),
            child: Consumer<TaskListProvider>(
              builder: (context, taskProvider, _) {
                final state = taskProvider.state;
                final allTasks = state.tasks ?? [];
                final pendingTasks =
                    allTasks.where((t) => !t.isCompleted).toList();
                final completedTasks =
                    allTasks.where((t) => t.isCompleted).toList();

                if (state.isLoadingData) {
                  return const LoadingWidget(message: 'Loading tasks...');
                }
                if (state.hasError) {
                  return ErrorStateWidget(
                    message: state.errorMessage ?? 'Failed to load tasks',
                    onRetry: () =>
                        context.read<TaskListProvider>().loadTasks(),
                  );
                }

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // ── Dashboard Header ────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            // Gradient title
                            ShaderMask(
                              shaderCallback: (bounds) =>
                                  const LinearGradient(
                                colors: [
                                  AppTheme.textPrimary,
                                  AppTheme.primaryColor,
                                  AppTheme.accentColor,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Text(
                                'Your Tasks',
                                style: GoogleFonts.inter(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${allTasks.length} total · ${pendingTasks.length} pending',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // ── Dashboard Cards with gravity pointer ───────
                            Row(
                              children: [
                                Expanded(
                                  child: _GravityDashCard(
                                    title: 'Pending',
                                    count: pendingTasks.length,
                                    icon: Icons.hourglass_top_rounded,
                                    gradientColors: const [
                                      Color(0xFF7C6BFF),
                                      Color(0xFF5A4ECC),
                                    ],
                                    glowColor: AppTheme.primaryColor,
                                    onTap: () => _navigateFiltered(context,
                                        TaskFilter.pending, 'Pending Tasks'),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _GravityDashCard(
                                    title: 'Completed',
                                    count: completedTasks.length,
                                    icon: Icons.check_circle_rounded,
                                    gradientColors: const [
                                      Color(0xFF00C896),
                                      Color(0xFF00876A),
                                    ],
                                    glowColor: AppTheme.successColor,
                                    onTap: () => _navigateFiltered(
                                        context,
                                        TaskFilter.completed,
                                        'Completed Tasks'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            // ── Section label ──────────────────────────────
                            Row(
                              children: [
                                Text(
                                  'Recent Tasks',
                                  style: GoogleFonts.inter(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${allTasks.length}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),

                    // ── Task List ───────────────────────────────────────────
                    if (allTasks.isEmpty)
                      const SliverFillRemaining(
                        child: EmptyStateWidget(
                          title: 'No Tasks Yet',
                          subtitle: 'Tap + to create your first task',
                          icon: Icons.rocket_launch_rounded,
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.only(bottom: 100),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final task = allTasks[index];
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
                                    final result = await Navigator.of(context)
                                        .push(_slideRoute(
                                            AddEditTaskScreen(task: task)));
                                    if (result == true && context.mounted) {
                                      context
                                          .read<TaskListProvider>()
                                          .loadTasks();
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
                                          duration:
                                              const Duration(seconds: 4),
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
                            childCount: allTasks.length,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabGlow,
        builder: (_, child) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor
                    .withValues(alpha: 0.5 * _fabGlow.value),
                blurRadius: 28,
                spreadRadius: 6,
              ),
            ],
          ),
          child: child,
        ),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.of(context)
                .push(_slideRoute(const AddEditTaskScreen()));
            if (result == true && context.mounted) {
              context.read<TaskListProvider>().loadTasks();
            }
          },
          tooltip: 'Add New Task',
          backgroundColor: AppTheme.primaryColor,
          child: const Icon(Icons.add_rounded, size: 28, color: Colors.white),
        ),
      ),
    );
  }

  void _navigateFiltered(
      BuildContext context, TaskFilter filter, String title) {
    Navigator.of(context).push(
        _slideRoute(FilteredTaskListScreen(filter: filter, title: title)));
  }

  Route _slideRoute(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1, 0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOutCubic)),
          ),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Gravity Pointer Dashboard Card
// Tracks mouse position → applies 3D tilt + inner light spotlight effect
// giving an antigravity / magnetic feel
// ─────────────────────────────────────────────────────────────────────────────
class _GravityDashCard extends StatefulWidget {
  final String title;
  final int count;
  final IconData icon;
  final List<Color> gradientColors;
  final Color glowColor;
  final VoidCallback onTap;

  const _GravityDashCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.gradientColors,
    required this.glowColor,
    required this.onTap,
  });

  @override
  State<_GravityDashCard> createState() => _GravityDashCardState();
}

class _GravityDashCardState extends State<_GravityDashCard>
    with SingleTickerProviderStateMixin {
  // Tilt values: -1 to 1
  double _tiltX = 0;
  double _tiltY = 0;
  // Normalised spotlight position
  double _spotX = 0.5;
  double _spotY = 0.5;
  bool _hovering = false;

  late AnimationController _pressController;
  late Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 280),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleHover(PointerEvent event) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(event.position);
    final w = box.size.width;
    final h = box.size.height;
    setState(() {
      // Tilt: map position to -1..1, max 12 degrees
      _tiltY = ((local.dx / w) - 0.5) * 2; // left/right
      _tiltX = -((local.dy / h) - 0.5) * 2; // up/down (invert)
      _spotX = (local.dx / w).clamp(0.0, 1.0);
      _spotY = (local.dy / h).clamp(0.0, 1.0);
      _hovering = true;
    });
  }

  void _handleHoverExit(PointerEvent _) {
    setState(() {
      _tiltX = 0;
      _tiltY = 0;
      _spotX = 0.5;
      _spotY = 0.5;
      _hovering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const maxAngle = 12.0 * math.pi / 180; // 12 degrees in radians

    return MouseRegion(
      onHover: _handleHover,
      onExit: _handleHoverExit,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _pressController.forward(),
        onTapUp: (_) {
          _pressController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressController.reverse(),
        child: AnimatedBuilder(
          animation: _pressScale,
          builder: (_, child) => Transform.scale(
            scale: _pressScale.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateX(_tiltX * maxAngle)
              ..rotateY(_tiltY * maxAngle),
            transformAlignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: widget.glowColor.withValues(
                        alpha: _hovering ? 0.45 : 0.25),
                    blurRadius: _hovering ? 28 : 16,
                    offset: const Offset(0, 8),
                    spreadRadius: _hovering ? 4 : 1,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // ── Animated spotlight reflection ───────────────────────
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 150),
                    left: _spotX * 100 - 40,
                    top: _spotY * 80 - 30,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _hovering ? 0.25 : 0.0,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Colors.white, Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ── Card content ────────────────────────────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            Icon(widget.icon, color: Colors.white, size: 22),
                      ),
                      const SizedBox(height: 14),
                      // Animated count
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: widget.count.toDouble()),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        builder: (_, val, __) => Text(
                          '${val.round()}',
                          style: GoogleFonts.inter(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.title,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
