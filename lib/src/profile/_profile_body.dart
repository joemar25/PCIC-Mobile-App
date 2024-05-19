import '_profile_body_item.dart';
import 'package:flutter/material.dart';
import '../settings/_view.dart';
import '../settings/_controller.dart';
import '../settings/_service.dart';  // Import the service

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  late final SettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    final settingsService = SettingsService(); // Instantiate the service
    _settingsController = SettingsController(settingsService); // Pass the service to the controller
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Handle "Settings" tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsView(controller: _settingsController),
                ),
              );
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
