import 'package:flutter/material.dart';
import 'package:task_manager/core/theme/app_theme.dart';

class PriorityBadge extends StatelessWidget {
  final int priorityIndex;
  final bool isSmall;

  const PriorityBadge({
    super.key,
    required this.priorityIndex,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getPriorityColor(priorityIndex);
    final label = AppTheme.getPriorityLabel(priorityIndex);
    final icon  = AppTheme.getPriorityIcon(priorityIndex);

    if (isSmall) {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 6)],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 10, spreadRadius: 1),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
