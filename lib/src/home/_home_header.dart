// filename: _home_header.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../theme/_theme.dart';
import '../settings/_view.dart';
import '../settings/_service.dart';
import '../settings/_controller.dart';
import '../profile/_profile_view.dart';

class HomeHeader extends StatefulWidget {
  final VoidCallback onLogout;

  const HomeHeader({super.key, required this.onLogout});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String? userName;
  late final VoidCallback onLogout;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final String userId = currentUser.uid;
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('authUid', isEqualTo: userId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDocSnapshot = querySnapshot.docs.first;
          Map<String, dynamic>? userData =
              userDocSnapshot.data() as Map<String, dynamic>?;

          // debugPrint('User ID: $userId');
          // debugPrint('User data: $userData');

          if (userData != null && userData.containsKey('name')) {
            setState(() {
              userName = userData['name'] as String?;
            });
          }
        } else {
          debugPrint('User document not found');
        }
      }
    } catch (e) {
      debugPrint('Error fetching user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: TextStyle(
                fontSize: t?.caption ?? 14.0,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              userName ?? 'Agent 007 👋',
              style: TextStyle(
                fontSize: t?.title ?? 14.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        PopupMenuButton<String>(
          splashRadius: 0.0,
          color: Colors.white,
          offset: const Offset(-8, 55),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          padding: EdgeInsets.zero,
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF0F7D40)),
                borderRadius: BorderRadius.circular(100),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.transparent,
                child: Image.asset(
                  'assets/storage/images/cool.png',
                  fit: BoxFit.cover,
                  height: 30,
                ),
              )),
          onSelected: (value) {
            if (value == 'Logout') {
              onLogout();
            } else {
              // Handle other menu item selections
              switch (value) {
                case 'Profile':
                  Navigator.push(
                    // Navigate to the SettingsScreen
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                  break;
                case 'Settings':
                  Navigator.push(
                    // Navigate to the SettingsScreen
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsView(
                            controller: SettingsController(SettingsService()))),
                  );
                  break;
              }
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Profile',
              child: ListTile(
                leading: SizedBox(
                  width: 28,
                  height: 28,
                  child: SvgPicture.asset(
                    'assets/storage/images/person.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                title: const Text('Profile'),
              ),
            ),
            PopupMenuItem<String>(
              value: 'Settings',
              child: ListTile(
                leading: SizedBox(
                  width: 28,
                  height: 28,
                  child: SvgPicture.asset(
                    'assets/storage/images/settings.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                title: const Text('Settings'),
              ),
            ),
            PopupMenuItem<String>(
              value: 'Logout',
              child: ListTile(
                leading: SizedBox(
                  width: 28,
                  height: 28,
                  child: SvgPicture.asset(
                    'assets/storage/images/logout.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                title: const Text('Logout'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
