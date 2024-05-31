import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../utils/agent/_logout_view.dart';
import '../theme/_theme.dart';
import 'components/_profile_body.dart';
import 'components/_profile_body_item.dart';
import 'components/_profile_edit.dart';
import '../../utils/agent/_session.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  String profilePicUrl = '';
  String documentId = '';
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isPickerActive = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String authUid = currentUser.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(authUid)
          .get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc['name'];
          email = userDoc['email'];
          profilePicUrl = userDoc['profilePicUrl'];
          documentId = userDoc.id;
        });
      } else {
        print("User document not found");
      }
    } else {
      print("No authenticated user");
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
        ),
      ),
    );

    if (result == true) {
      fetchUserData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } else if (result == false) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile.')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    if (_isPickerActive) return;
    _isPickerActive = true;

    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isUploading = true;
      });

      if (_imageFile != null) {
        String fileName =
            'profile_pics/${DateTime.now().millisecondsSinceEpoch}.png';
        UploadTask uploadTask =
            FirebaseStorage.instance.ref().child(fileName).putFile(_imageFile!);

        try {
          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(documentId)
              .update({'profilePicUrl': downloadUrl});

          setState(() {
            profilePicUrl = downloadUrl;
          });
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to upload profile picture: $e')),
            );
          }
        } finally {
          setState(() {
            _isUploading = false;
          });
        }
      }
    }

    _isPickerActive = false;
  }

  Future<String> _getProfilePicUrl() async {
    try {
      if (profilePicUrl.isNotEmpty) {
        await FirebaseStorage.instance
            .refFromURL(profilePicUrl)
            .getDownloadURL();
        return profilePicUrl;
      } else {
        return await FirebaseStorage.instance
            .ref('profile_pics/default.png')
            .getDownloadURL();
      }
    } catch (e) {
      return await FirebaseStorage.instance
          .ref('profile_pics/default.png')
          .getDownloadURL();
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
              Stack(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2.0, color: const Color(0xFF0F7D40)),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: FutureBuilder<String>(
                        future: _getProfilePicUrl(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError || !snapshot.hasData) {
                            return const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage('URL_OF_DEFAULT_IMAGE'),
                            );
                          } else {
                            return CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(snapshot.data!),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (_isUploading)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black45,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                    fontSize: t?.headline, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style:
                    TextStyle(fontSize: t?.body, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: navigateToEditProfile,
                style: ElevatedButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  elevation: 0.0,
                  backgroundColor: const Color(0xFF0F7D40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                      color: Colors.white, fontSize: t?.caption ?? 14.0),
                ),
              ),
              const SizedBox(height: 32.0),
              const Divider(),
              const ProfileBody(),
              const Divider(),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  _logout(context);
                },
                child: const ProfileBodyItem(
                  label: 'Logout',
                  svgPath: 'assets/storage/images/logout.svg',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    await Session().stop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LogoutSuccessPage()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error logging out: $e')),
    );
  }
}
