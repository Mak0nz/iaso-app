// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final onTap;
  final text;
  final progressEvent;

  const AnimatedButton({super.key, 
    required this.onTap,
    required this.text,
    required this.progressEvent,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.blue.shade400,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade600,
              spreadRadius: 2,
              offset: const Offset(2, 5),
            ),
          ],
        ),
        child: Center( child: widget.progressEvent ? const CircularProgressIndicator(color: Colors.white,):
          Text(widget.text, 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );

  }
}