import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/_settings.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100)),
            Text(
              'Hi Agent!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
          child: const Icon(Icons.menu),
        ),
      ],
    );
  }
}
