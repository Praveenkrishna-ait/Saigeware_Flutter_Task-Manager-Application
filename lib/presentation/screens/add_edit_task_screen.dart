import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/presentation/providers/task_list_provider.dart';
import 'package:task_manager/presentation/widgets/gravity_list_item.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime? _dueDate;
  late int _priority;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.task?.title ?? '');
    _descController =
        TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate;
    _priority = widget.task?.priority.index ?? 1;

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryColor,
              surface: AppTheme.surfaceCard,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    try {
      final provider = context.read<TaskListProvider>();
      if (widget.task == null) {
        final newTask = Task(
          id: const Uuid().v4(),
          title: _titleController.text.trim(),
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          dueDate: _dueDate,
          priority: Priority.values[_priority],
          isCompleted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await provider.createTask(newTask);
      } else {
        final updated = widget.task!.copyWith(
          title: _titleController.text.trim(),
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          dueDate: _dueDate,
          priority: Priority.values[_priority],
          updatedAt: DateTime.now(),
        );
        await provider.updateTask(updated);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

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
                  isEditing ? 'Edit Task' : 'New Task',
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // ── Title field ───────────────────────────────────────────
                  GravityListItem(
                    index: 0,
                    child: _SectionLabel('Task Title'),
                  ),
                  const SizedBox(height: 8),
                  GravityListItem(
                    index: 1,
                    child: _GlassField(
                      child: TextFormField(
                        controller: _titleController,
                        style: GoogleFonts.inter(
                            color: AppTheme.textPrimary, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'What needs to be done?',
                          hintStyle: GoogleFonts.inter(
                              color: AppTheme.textMuted, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          prefixIcon: const Icon(Icons.edit_note_rounded,
                              color: AppTheme.primaryColor, size: 22),
                        ),
                        validator: (v) =>
                            (v?.isEmpty ?? true) ? 'Title is required' : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Description field ─────────────────────────────────────
                  GravityListItem(
                    index: 2,
                    child: _SectionLabel('Description'),
                  ),
                  const SizedBox(height: 8),
                  GravityListItem(
                    index: 3,
                    child: _GlassField(
                      child: TextFormField(
                        controller: _descController,
                        style: GoogleFonts.inter(
                            color: AppTheme.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Add details (optional)',
                          hintStyle: GoogleFonts.inter(
                              color: AppTheme.textMuted, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          prefixIcon: const Icon(Icons.notes_rounded,
                              color: AppTheme.textSecondary, size: 20),
                        ),
                        maxLines: 4,
                        minLines: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Priority ──────────────────────────────────────────────
                  GravityListItem(
                    index: 4,
                    child: _SectionLabel('Priority'),
                  ),
                  const SizedBox(height: 10),
                  GravityListItem(
                    index: 5,
                    child: Row(
                      children: [
                        _PriorityPill(
                          label: 'Low',
                          icon: Icons.arrow_downward_rounded,
                          color: AppTheme.lowPriorityColor,
                          selected: _priority == 0,
                          onTap: () => setState(() => _priority = 0),
                        ),
                        const SizedBox(width: 10),
                        _PriorityPill(
                          label: 'Medium',
                          icon: Icons.remove_rounded,
                          color: AppTheme.mediumPriorityColor,
                          selected: _priority == 1,
                          onTap: () => setState(() => _priority = 1),
                        ),
                        const SizedBox(width: 10),
                        _PriorityPill(
                          label: 'High',
                          icon: Icons.arrow_upward_rounded,
                          color: AppTheme.highPriorityColor,
                          selected: _priority == 2,
                          onTap: () => setState(() => _priority = 2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Due Date ──────────────────────────────────────────────
                  GravityListItem(
                    index: 6,
                    child: _SectionLabel('Due Date'),
                  ),
                  const SizedBox(height: 8),
                  GravityListItem(
                    index: 7,
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: _GlassField(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: _dueDate != null
                                    ? AppTheme.accentColor
                                    : AppTheme.textSecondary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _dueDate == null
                                    ? 'Select due date'
                                    : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                                style: GoogleFonts.inter(
                                  color: _dueDate != null
                                      ? AppTheme.textPrimary
                                      : AppTheme.textMuted,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              if (_dueDate != null)
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _dueDate = null),
                                  child: const Icon(Icons.close_rounded,
                                      color: AppTheme.textMuted, size: 18),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Save Button ───────────────────────────────────────────
                  GravityListItem(
                    index: 8,
                    child: SizedBox(
                      width: double.infinity,
                      child: _HoverBounceButton(
                        onTap: _isSaving ? null : _handleSave,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 54,
                          decoration: BoxDecoration(
                            color: _isSaving
                                ? AppTheme.surfaceElevated
                                : AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: _isSaving
                                ? [const BoxShadow(color: Colors.transparent)]
                                : [
                                    BoxShadow(
                                      color: AppTheme.primaryGlow,
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                          ),
                          child: Center(
                            child: _isSaving
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: AppTheme.primaryColor,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isEditing
                                            ? Icons.save_rounded
                                            : Icons.add_task_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isEditing ? 'Save Changes' : 'Create Task',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Cancel
                  GravityListItem(
                    index: 9,
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _GlassField extends StatelessWidget {
  final Widget child;
  const _GlassField({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141B2E),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.dividerColor.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PriorityPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _PriorityPill({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.2) : AppTheme.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? color : AppTheme.dividerColor,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected
                ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 12)]
                : [const BoxShadow(color: Colors.transparent)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: selected ? color : AppTheme.textMuted, size: 18),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? color : AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoverBounceButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;
  const _HoverBounceButton({required this.onTap, required this.child});

  @override
  State<_HoverBounceButton> createState() => _HoverBounceButtonState();
}

class _HoverBounceButtonState extends State<_HoverBounceButton> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed ? 0.95 : (_isHovering ? 1.02 : 1.0);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: widget.onTap != null ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: widget.onTap != null ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: widget.onTap != null ? () => setState(() => _isPressed = false) : null,
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutBack,
          child: widget.child,
        ),
      ),
    );
  }
}
