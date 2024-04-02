import 'package:flutter/material.dart';

class ProfileChildTwo extends StatelessWidget {
  const ProfileChildTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/storage/images/checked.png',
              height: 16,
            ),
            const SizedBox(
              width: 4,
            ),
            const Text(
              'Task Completed: 3',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/storage/images/list.png',
              height: 16,
            ),
            const SizedBox(
              width: 4,
            ),
            const Text(
              'Remaining Tasks: 4',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        )
      ],
    );
  }
}
