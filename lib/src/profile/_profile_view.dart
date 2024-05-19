import '_profile_body.dart';
import '_profile_body_item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';
import 'package:pcic_mobile_app/src/profile/_profile_edit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  String profilePicUrl = '';
  final String documentId =
      '8rpFSBLQRgCGCFyVrW96'; // Move documentId to a class variable

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    // Fetch user data from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .get();

    if (userDoc.exists) {
      setState(() {
        name = userDoc['name'];
        email = userDoc['email'];
        profilePicUrl = userDoc['profilePicUrl'];
      });
    }
  }

  void navigateToEditProfile() async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          documentId: documentId,
          name: name,
          email: email,
          profilePicUrl: profilePicUrl,
        ),
      ),
    );

    if (result == true) {
      fetchUserData(); // Refresh data after returning from edit page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } else if (result == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: t?.headline,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2.0, color: const Color(0xFF0F7D40)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: profilePicUrl.isNotEmpty
                        ? NetworkImage(profilePicUrl)
                        : null,
                    child: profilePicUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          )
                        : null,
                  )),
              const SizedBox(
                height: 8,
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: t?.headline, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(email,
                  style: TextStyle(
                      fontSize: t?.body, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: navigateToEditProfile,
                style: ElevatedButton.styleFrom(
                  splashFactory: NoSplash.splashFactory, // Remove splash effect
                  elevation: 0.0,
                  backgroundColor: const Color(0xFF0F7D40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Border radius
                  ),
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: t?.caption ?? 14.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
              const Divider(),
              const ProfileBody(),
              const Divider(),
              const SizedBox(
                height: 8,
              ),
              const ProfileBodyItem(
                  label: 'Logout', svgPath: 'assets/storage/images/logout.svg')
            ],
          ),
        ),
      ),
    );
  }
}
