import 'package:flutter/material.dart';

class RecentTaskFooter extends StatelessWidget {
  const RecentTaskFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Row(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/storage/images/clock.png',
                color: const Color(0xFFC5C23F),
              ),
              const SizedBox(width: 4),
              const Text(
                '03-23-24',
                style: TextStyle(color: Color(0xFFC5C23F)),
              )
            ],
          ),
          const SizedBox(
            width: 32,
          ),
          Row(
            children: [
              Image.asset(
                'assets/storage/images/clock.png',
                color: const Color(0xFF45C53F),
              ),
              const SizedBox(width: 4),
              const Text(
                '04-25-24',
                style: TextStyle(color: Color(0xFF45C53F)),
              )
            ],
          )
          // Row(),
        ],
      ),
    );
  }
}
