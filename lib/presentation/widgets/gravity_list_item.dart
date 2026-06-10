import 'package:flutter/material.dart';
import 'package:task_manager/core/theme/app_theme.dart';

/// Stateless gravity drop-in animation using TweenAnimationBuilder.
/// Safer than AnimationController + Future.delayed in SliverList on Flutter Web
/// because it never resets to opacity=0 on widget tree rebuilds.
class GravityListItem extends StatelessWidget {
  final Widget child;
  final int index;

  const GravityListItem({
    super.key,
    required this.child,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Stagger via longer duration — no Future.delayed needed
    final duration = Duration(milliseconds: 400 + (index * 60).clamp(0, 350));

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (_, value, child) {
        return Transform.translate(
          // Drop from 60px above, settle at 0
          offset: Offset(0, 60.0 * (1.0 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated background with floating neon orbs
// ─────────────────────────────────────────────────────────────────────────────
class GravityBackground extends StatefulWidget {
  final Widget child;
  const GravityBackground({super.key, required this.child});

  @override
  State<GravityBackground> createState() => _GravityBackgroundState();
}

class _GravityBackgroundState extends State<GravityBackground>
    with TickerProviderStateMixin {
  late AnimationController _orb1Controller;
  late AnimationController _orb2Controller;
  late AnimationController _orb3Controller;
  Offset _cursorPos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _orb1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat(reverse: true);

    _orb2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5600),
    )..repeat(reverse: true);

    _orb3Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _orb1Controller.dispose();
    _orb2Controller.dispose();
    _orb3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) {
        setState(() {
          _cursorPos = e.localPosition;
        });
      },
      child: Stack(
        children: [
          // Deep gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.backgroundDeep,
                  AppTheme.backgroundBase,
                  Color(0xFF0D1527),
                ],
              ),
            ),
          ),
          
          // Gravity Dot (Cursor Follower)
          if (_cursorPos != Offset.zero)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCirc,
              left: _cursorPos.dx - 150,
              top: _cursorPos.dy - 150,
              child: IgnorePointer(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accentColor.withValues(alpha: 0.15),
                        AppTheme.primaryColor.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Orb 1 — top left violet
          AnimatedBuilder(
            animation: _orb1Controller,
            builder: (_, __) => Positioned(
              top: -80 + (_orb1Controller.value * 40),
              left: -60 + (_orb1Controller.value * 30),
              child: IgnorePointer(
                child: _Orb(
                  size: 280,
                  color: AppTheme.primaryColor,
                  opacity: 0.10 + _orb1Controller.value * 0.06,
                ),
              ),
            ),
          ),
          // Orb 2 — bottom right teal
          AnimatedBuilder(
            animation: _orb2Controller,
            builder: (_, __) => Positioned(
              bottom: -100 + (_orb2Controller.value * 50),
              right: -80 + (_orb2Controller.value * 35),
              child: IgnorePointer(
                child: _Orb(
                  size: 320,
                  color: AppTheme.accentColor,
                  opacity: 0.07 + _orb2Controller.value * 0.05,
                ),
              ),
            ),
          ),
          // Orb 3 — mid-right
          AnimatedBuilder(
            animation: _orb3Controller,
            builder: (_, __) => Positioned(
              top: 240 + (_orb3Controller.value * 60),
              right: 30 + (_orb3Controller.value * 20),
              child: IgnorePointer(
                child: _Orb(
                  size: 180,
                  color: AppTheme.primaryColor,
                  opacity: 0.06 + _orb3Controller.value * 0.04,
                ),
              ),
            ),
          ),
          // Content on top
          widget.child,
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _Orb({required this.size, required this.color, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: opacity), Colors.transparent],
        ),
      ),
    );
  }
}
