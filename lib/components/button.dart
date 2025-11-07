import 'package:flutter/material.dart';
class Button extends StatelessWidget {
  final String? id;
  final String label;
  final Color color;
  final void Function() onPressed;

  const Button({
    super.key,
     this.id,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
              label, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}