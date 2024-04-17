import 'package:flutter/material.dart';

class ProfileChildThree extends StatelessWidget {
  const ProfileChildThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Image.asset('assets/storage/images/calendar-2.png'),
              const SizedBox(width: 4),
              const Text(
                'Sunday, 5 March',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Row(
            children: [
              Image.asset('assets/storage/images/clock.png'),
              const SizedBox(width: 4),
              const Text(
                '2972 Westheimer..',
                style: TextStyle(color: Colors.white),
              )
            ],
          )
          // Row(),
        ],
      ),
    );
  }
}
