import "package:flutter/material.dart";

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const AppText(
    this.text,
    this.style, {
      super.key,
  });

  const AppText.heading(this.text, {super.key})
    : style = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

  const AppText.subHeading(this.text, {super.key})
  : style = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  const AppText.bold(this.text, {super.key})
  : style = const TextStyle(
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}