import 'package:flutter/material.dart';
import 'package:iaso/src/constants/sizes.dart';

class Body extends StatefulWidget {
  final List<Widget> children;

  const Body({
    super.key,
    required this.children,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(edgeInset, 5, edgeInset, 0),
        child: SingleChildScrollView(
          child: Column(
              children: widget.children,
            ),
        ),
      );
  }
}