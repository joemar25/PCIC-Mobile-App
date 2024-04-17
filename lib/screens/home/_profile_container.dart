import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/home/_profile_childone.dart';
import 'package:pcic_mobile_app/screens/home/_profile_childthree.dart';
import 'package:pcic_mobile_app/screens/home/_profile_childtwo.dart';

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: const Color(0xFF0F7D40),
            borderRadius: BorderRadius.circular(14)),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileChildOne(),
            ProfileChildTwo(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              child: Divider(
                color: Colors.white24,
              ),
            ),
            ProfileChildThree(),
          ],
        ));
  }
}
