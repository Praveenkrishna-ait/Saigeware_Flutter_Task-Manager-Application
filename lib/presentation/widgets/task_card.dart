import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/core/utils/extensions.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/presentation/widgets/priority_badge.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    required this.task,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _checkController;
  late Animation<double> _checkPulse;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _checkPulse = Tween<double>(begin: 1.0, end: 1.45).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.task.isCompleted && widget.task.isCompleted) {
      _checkController.forward().then((_) => _checkController.reverse());
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = AppTheme.getPriorityColor(widget.task.priority.index);
    final isCompleted = widget.task.isCompleted;

    return Dismissible(
      key: Key(widget.task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF2A1020),
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.4)),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_rounded, color: AppTheme.errorColor, size: 26),
            const SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: AppTheme.errorColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => widget.onDelete(),
      child: GestureDetector(
        onTap: widget.onEdit,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            // Solid card — no BackdropFilter (breaks Flutter Web in slivers)
            color: isCompleted
                ? const Color(0xFF0F1420)
                : const Color(0xFF141B2E),
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.05), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: (isCompleted ? AppTheme.successColor : priorityColor)
                    .withValues(alpha: 0.10),
                blurRadius: 22,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 4,
                  child: Container(
                    color: isCompleted
                        ? AppTheme.successColor.withValues(alpha: 0.6)
                        : priorityColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 12, 14),
                  child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title row ───────────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animated circular checkbox
                    GestureDetector(
                      onTap: widget.onToggleComplete,
                      child: AnimatedBuilder(
                        animation: _checkPulse,
                        builder: (_, child) => Transform.scale(
                          scale: _checkPulse.value,
                          child: child,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 26,
                          height: 26,
                          margin: const EdgeInsets.only(top: 1, right: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? AppTheme.successColor
                                : Colors.transparent,
                            border: isCompleted
                                ? Border.all(color: Colors.transparent, width: 2)
                                : Border.all(
                                    color: AppTheme.textMuted,
                                    width: 2,
                                  ),
                            boxShadow: isCompleted
                                ? [
                                    BoxShadow(
                                      color: AppTheme.successColor
                                          .withValues(alpha: 0.45),
                                      blurRadius: 12,
                                    )
                                  ]
                                : [
                                    const BoxShadow(
                                      color: Colors.transparent,
                                      blurRadius: 0,
                                    )
                                  ],
                          ),
                          child: isCompleted
                              ? const Icon(Icons.check, color: Colors.white, size: 16)
                              : null,
                        ),
                      ),
                    ),
                    // Title + description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.task.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isCompleted
                                  ? AppTheme.textMuted
                                  : AppTheme.textPrimary,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor: AppTheme.textMuted,
                            ),
                          ),
                          if (widget.task.description != null &&
                              widget.task.description!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.task.description!,
                              style: TextStyle(
                                fontSize: 12,
                                color: isCompleted
                                    ? AppTheme.textMuted.withValues(alpha: 0.5)
                                    : AppTheme.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    PriorityBadge(priorityIndex: widget.task.priority.index),
                  ],
                ),
                const SizedBox(height: 12),
                // ── Footer row ───────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.task.dueDate != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: _dueDateColor(
                                widget.task.dueDate!, isCompleted),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.task.dueDate!.formattedDateShort,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _dueDateColor(
                                  widget.task.dueDate!, isCompleted),
                            ),
                          ),
                        ],
                      )
                    else
                      const SizedBox.shrink(),
                    // Action buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ActionBtn(
                          icon: Icons.edit_rounded,
                          color: AppTheme.primaryColor,
                          onTap: widget.onEdit,
                        ),
                        const SizedBox(width: 6),
                        _ActionBtn(
                          icon: Icons.delete_rounded,
                          color: AppTheme.errorColor,
                          onTap: widget.onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
),
);
}

  Color _dueDateColor(DateTime date, bool isCompleted) {
    if (isCompleted) return AppTheme.textMuted;
    final now = DateTime.now();
    if (date.isBefore(now)) return AppTheme.errorColor;
    if (date.difference(now).inDays <= 2) return AppTheme.warningColor;
    return AppTheme.textSecondary;
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: color.withValues(alpha: 0.25), width: 1),
        ),
        child: Icon(icon, size: 15, color: color),
      ),
    );
  }
}
