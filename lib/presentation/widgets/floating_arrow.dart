import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FloatingArrow extends StatefulWidget {
  const FloatingArrow({super.key});

  @override
  State<FloatingArrow> createState() => _FloatingArrowState();
}

class _FloatingArrowState extends State<FloatingArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: const Offset(0, 0.25),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: const Icon(
        FontAwesomeIcons.arrowDown,
        size: 40,
      ),
    );
  }
}
