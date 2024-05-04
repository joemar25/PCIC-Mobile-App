import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/profile/_profile_body_item.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            ProfileBodyItem(
              label: 'My Tasks',
              svgPath: 'assets/storage/images/mytask.svg',
            ),
            SizedBox(height: 16.0),
            ProfileBodyItem(
              label: 'Settings',
              svgPath: 'assets/storage/images/settings.svg',
            ),
            SizedBox(height: 16.0),
            ProfileBodyItem(
              label: 'Change Password',
              svgPath: 'assets/storage/images/lock.svg',
            )
          ],
        ));
  }
}
