import 'package:flutter/material.dart';

class CountdownTimer extends StatelessWidget {
  final int countdown;

  const CountdownTimer({super.key, required this.countdown});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54.withOpacity(0.8),
        child: Center(
          child: AnimatedOpacity(
            opacity: countdown > 0 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Text(
              '$countdown',
              style: const TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
