import 'package:flutter/material.dart';

class AnimatedScreenTransition extends PageRouteBuilder {
  final Widget Function(BuildContext, Animation<double>, Animation<double>)
  pageBuilder;

  AnimatedScreenTransition({
    required this.pageBuilder,
    Duration transitionDuration = const Duration(milliseconds: 300),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) {
           return pageBuilder(context, animation, secondaryAnimation);
         },
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return SlideTransition(
             position:
                 Tween<Offset>(
                   begin: const Offset(1, 0),
                   end: Offset.zero,
                 ).animate(
                   CurvedAnimation(
                     parent: animation,
                     curve: Curves.easeInOutCubic,
                   ),
                 ),
             child: FadeTransition(opacity: animation, child: child),
           );
         },
         transitionDuration: transitionDuration,
       );
}

class AnimatedListEntry extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const AnimatedListEntry({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<AnimatedListEntry> createState() => _AnimatedListEntryState();
}

class _AnimatedListEntryState extends State<AnimatedListEntry>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
    );
  }
}
