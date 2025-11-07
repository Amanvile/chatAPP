// In TypeWriterLogoAnimated.dart

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class TypeWriterLogoAnimated extends StatelessWidget {
  // --- WIDGET PROPERTIES ---
  final String text;
  final TextStyle textStyle;
  final Duration speed;

  const TypeWriterLogoAnimated({
    super.key,
    required this.text,
    this.textStyle = const TextStyle(
      fontSize: 45.0,
      fontWeight: FontWeight.w900,
      color: Colors.black, // Text color is now fixed
    ),
    this.speed = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    // This widget is now stateless.
    // All animation logic is handled by the AnimatedTextKit package.
    return AnimatedTextKit(
      totalRepeatCount: 10,
      animatedTexts: [
        TypewriterAnimatedText(
          text,
          speed: speed,
          textStyle: textStyle,
        ),
      ],
    );
  }
}