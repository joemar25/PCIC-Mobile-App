import '../../theme/_theme.dart';
import 'package:flutter/material.dart';
import '../../profile/_profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeHeader extends StatefulWidget {
  final VoidCallback onLogout;

  const HomeHeader({super.key, required this.onLogout});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String? userName;
  String profilePicUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    // Cancel any active asynchronous operations or subscriptions
    // For example:
    // _streamSubscription?.cancel();
    // _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // debugPrint("uid is ${user.uid}");

        if (userDoc.exists) {
          String fetchedProfilePicUrl = userDoc['profilePicUrl'] ?? '';
          if (mounted) {
            setState(() {
              userName = userDoc['name'];
              profilePicUrl = fetchedProfilePicUrl.isNotEmpty
                  ? fetchedProfilePicUrl
                  : 'assets/storage/images/default.png';
              // debugPrint('Fetched profile picture URL: $profilePicUrl');
            });
          }
        } else {
          debugPrint('User document does not exist.');
          if (mounted) {
            setState(() {
              profilePicUrl = 'assets/storage/images/default.png';
            });
          }
        }
      } catch (e) {
        debugPrint('Error fetching user document: $e');
        if (mounted) {
          setState(() {
            profilePicUrl = 'assets/storage/images/default.png';
          });
        }
      }
    } else {
      debugPrint('No user is logged in.');
      if (mounted) {
        setState(() {
          profilePicUrl = 'assets/storage/images/default.png';
        });
      }
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
            const SizedBox(height: 10),
            Text(
              'Hi $userName 👋 ' ?? 'Agent 007 ',
              style: TextStyle(
                color: Colors.white,
                fontSize: t?.title ?? 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Welcome back,',
              style: TextStyle(
                fontSize: t?.title ?? 22.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF0F7D40)),
              borderRadius: BorderRadius.circular(100),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: profilePicUrl.startsWith('http')
                    ? Image.network(
                        profilePicUrl,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      )
                    : Image.asset(
                        'assets/storage/images/default.png',
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
