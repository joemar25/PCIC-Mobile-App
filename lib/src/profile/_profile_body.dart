import '_profile_body_item.dart';
import 'package:flutter/material.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          GestureDetector(
            // Add GestureDetector for interactivity
            onTap: () {},
            child: const ProfileBodyItem(
              label: 'My Tasks',
              svgPath: 'assets/storage/images/mytask.svg',
            ),
          ),
          const SizedBox(height: 16.0),
          GestureDetector(
            onTap: () {
              // Handle "Settings" tap
            },
            child: const ProfileBodyItem(
              label: 'Settings',
              svgPath: 'assets/storage/images/settings.svg',
            ),
          ),
          const SizedBox(height: 16.0),
          GestureDetector(
            onTap: () {
              // Handle "Change Password" tap
            },
            child: const ProfileBodyItem(
              label: 'Change Password',
              svgPath: 'assets/storage/images/lock.svg',
            ),
          ),
        ],
      ),
    );
  }
}
