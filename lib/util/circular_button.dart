import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CircularButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        primary: Colors.red,
        onPrimary: Colors.white,
        side: BorderSide(color: Colors.white),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white,
            fontSize: 8.5
        ),
      ),
    );
  }
}
