// filename: home/_home_header.dart
import '../theme/_theme.dart';
// import '../settings/_view.dart';
// import '../settings/_service.dart';
// import 'package:flutter_svg/svg.dart';
// import '../settings/_controller.dart';
import 'package:flutter/material.dart';
import '../profile/_profile_view.dart';
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
    _fetchUserName();
    _getUserProfilePic();
  }

  Future<void> _getUserProfilePic() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('User ID: ${user.uid}');

      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc('8rpFSBLQRgCGCFyVrW96')
            .get();

        if (userDoc.exists) {
          print('User document data: ${userDoc.data()}');
          setState(() {
            profilePicUrl = userDoc['profilePicUrl'] ?? '';
          });
          print('Profile Pic URL: $profilePicUrl');
        } else {
          print('User document does not exist.');
        }
      } catch (e) {
        print('Error fetching user document: $e');
      }
    } else {
      print('No user is logged in.');
    }
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

          if (userData != null && userData.containsKey('name')) {
            if (mounted) {
              setState(() {
                userName = userData['name'] as String?;
              });
            }
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
                child: profilePicUrl.isNotEmpty
                    ? Image.network(
                        profilePicUrl,
                        fit: BoxFit.cover,
                        width: 48,
                        height: 48,
                      )
                    : Image.asset(
                        'assets/storage/images/cool.png',
                        fit: BoxFit.cover,
                        width: 48,
                        height: 48,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
