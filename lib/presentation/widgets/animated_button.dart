// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String text;
  final bool progressEvent;
  const AnimatedButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.progressEvent,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        transform: Matrix4.translationValues(
            _isPressed ? 1 : 0, _isPressed ? 2 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.blue.shade400,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade600,
              spreadRadius: _isPressed ? 1 : 2,
              offset: _isPressed ? const Offset(1, 2) : const Offset(2, 5),
            ),
          ],
        ),
        child: Center(
          child: widget.progressEvent
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    );
  }
}
