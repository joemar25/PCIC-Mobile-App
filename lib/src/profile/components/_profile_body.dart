// src/profile/components/_profile_body.dart
import 'package:flutter/material.dart';

import '_profile_body_item.dart';

import '../../settings/_view.dart';
import '../../settings/_controller.dart';
import '../../settings/_service.dart';

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
    final settingsService = SettingsService();
    _settingsController = SettingsController(settingsService);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsView(controller: _settingsController),
                ),
              );
            },
            child: const ProfileBodyItem(
              label: 'Settings',
              svgPath: 'assets/storage/images/settings.svg',
            ),
          ),
        ],
      ),
    );
  }
}
