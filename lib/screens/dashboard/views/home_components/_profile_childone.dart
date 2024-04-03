import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileChildOne extends StatelessWidget {
  const ProfileChildOne({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('agents');

    return FutureBuilder<DataSnapshot>(
      future: databaseReference.child(auth.currentUser!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final agentName = snapshot.data!.child('name').value.toString();
          final agentID = snapshot.data!.child('agentID').value.toString();

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Image(
                        image: AssetImage('assets/storage/images/icon.png'),
                        height: 55,
                        width: 55,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(agentName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                          Text(
                            "Agent $agentID",
                            style: const TextStyle(
                              color: Color(0xFFD2FFCB),
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Image(image: AssetImage('assets/storage/images/arrow-right.png')),
              ],
            ),
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