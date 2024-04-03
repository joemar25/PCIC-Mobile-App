import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_test.dart';


class HomeHeader extends StatelessWidget {
  final VoidCallback onLogout;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('agents');

  HomeHeader({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataSnapshot>(
      future: databaseReference.child(auth.currentUser!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final agentName = snapshot.data!.child('name').value.toString();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hi, $agentName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Logout') {
                    onLogout();
                  } else {
                    // Handle other menu item selections
                    switch (value) {
                      case 'Profile':
                        // Navigate to the profile screen
                        break;
                      case 'Settings':
                         Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Test()),
                        );
                        break;
                    }
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Profile',
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Settings',
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}