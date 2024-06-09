// import 'package:intl/intl.dart';
// import 'controllers/_detail.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pcic_mobile_app/src/theme/_theme.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:pcic_mobile_app/src/messages/components/_searchMessage.dart';

// class MessagesPage extends StatefulWidget {
//   const MessagesPage({super.key});

//   @override
//   MessagesPageState createState() => MessagesPageState();
// }

// class MessagesPageState extends State<MessagesPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final List<Map<String, dynamic>> allUsers = [];
//   final List<Map<String, dynamic>> usersWithConversations = [];
//   List<Map<String, dynamic>> filteredUsers = [];
//   String _searchQuery = '';
//   User? _currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _firebaseMessaging.requestPermission();
//     _firebaseMessaging.getToken().then((token) {
//       debugPrint("Firebase Messaging Token: $token");
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         debugPrint('Message data: ${message.data}');
//         debugPrint('Message notification: ${message.notification}');
//       }
//     });

//     _getCurrentUser();
//   }

//   void _getCurrentUser() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         _currentUser = user;
//       });
//       _fetchAllUsers();
//       _fetchUsersWithConversations();
//     }
//   }

//   // Future<void> _fetchAllUsers() async {
//   //   QuerySnapshot snapshot = await _firestore.collection('users').get();
//   //   List<Map<String, dynamic>> fetchedUsers =
//   //       snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

//   //   // Remove current user from the list
//   //   fetchedUsers.removeWhere((user) => user['authUid'] == _currentUser?.uid);

//   //   setState(() {
//   //     allUsers.clear();
//   //     allUsers.addAll(fetchedUsers);
//   //   });
//   // }

//   Future<void> _fetchAllUsers() async {
//     QuerySnapshot snapshot = await _firestore.collection('users').get();
//     List<Map<String, dynamic>> fetchedUsers = snapshot.docs.map((doc) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       data['authUid'] = doc.id; // Ensure authUid is included
//       return data;
//     }).toList();

//     // Remove current user from the list
//     fetchedUsers.removeWhere((user) => user['authUid'] == _currentUser?.uid);

//     setState(() {
//       allUsers.clear();
//       allUsers.addAll(fetchedUsers);
//     });
//   }

//   // Future<void> _fetchUsersWithConversations() async {
//   //   if (_currentUser == null) return;

//   //   QuerySnapshot conversationSnapshot = await _firestore
//   //       .collection('conversations')
//   //       .where('participants', arrayContains: _currentUser!.uid)
//   //       .get();

//   //   for (var conversation in conversationSnapshot.docs) {
//   //     List<dynamic> participants = conversation['participants'];
//   //     String lastMessage = '';
//   //     Timestamp lastMessageTime = Timestamp.now();

//   //     // Fetch the last message
//   //     QuerySnapshot messageSnapshot = await _firestore
//   //         .collection('conversations')
//   //         .doc(conversation.id)
//   //         .collection('messages')
//   //         .orderBy('timestamp', descending: true)
//   //         .limit(1)
//   //         .get();

//   //     if (messageSnapshot.docs.isNotEmpty) {
//   //       lastMessage = messageSnapshot.docs.first.get('message') ?? '';
//   //       lastMessageTime =
//   //           messageSnapshot.docs.first.get('timestamp') ?? Timestamp.now();
//   //     }

//   //     for (var participantUid in participants) {
//   //       if (participantUid != _currentUser!.uid) {
//   //         DocumentSnapshot userSnapshot =
//   //             await _firestore.collection('users').doc(participantUid).get();
//   //         Map<String, dynamic> userData =
//   //             userSnapshot.data() as Map<String, dynamic>;

//   //         userData['lastMessage'] = lastMessage;
//   //         userData['lastMessageTime'] = lastMessageTime;

//   //         usersWithConversations.add(userData);
//   //       }
//   //     }
//   //   }

//   //   setState(() {
//   //     filteredUsers = usersWithConversations;
//   //     _filterUsers();
//   //   });
//   // }

//   Future<void> _fetchUsersWithConversations() async {
//     if (_currentUser == null) return;

//     QuerySnapshot conversationSnapshot = await _firestore
//         .collection('conversations')
//         .where('participants', arrayContains: _currentUser!.uid)
//         .get();

//     for (var conversation in conversationSnapshot.docs) {
//       List<dynamic> participants = conversation['participants'];
//       String lastMessage = '';
//       Timestamp lastMessageTime = Timestamp.now();

//       // Fetch the last message
//       QuerySnapshot messageSnapshot = await _firestore
//           .collection('conversations')
//           .doc(conversation.id)
//           .collection('messages')
//           .orderBy('timestamp', descending: true)
//           .limit(1)
//           .get();

//       if (messageSnapshot.docs.isNotEmpty) {
//         lastMessage = messageSnapshot.docs.first.get('message') ?? '';
//         lastMessageTime =
//             messageSnapshot.docs.first.get('timestamp') ?? Timestamp.now();
//       }

//       for (var participantUid in participants) {
//         if (participantUid != _currentUser!.uid) {
//           DocumentSnapshot userSnapshot =
//               await _firestore.collection('users').doc(participantUid).get();
//           Map<String, dynamic> userData =
//               userSnapshot.data() as Map<String, dynamic>;

//           userData['authUid'] = participantUid; // Ensure authUid is included
//           userData['lastMessage'] = lastMessage;
//           userData['lastMessageTime'] = lastMessageTime;

//           usersWithConversations.add(userData);
//         }
//       }
//     }

//     setState(() {
//       filteredUsers = usersWithConversations;
//       _filterUsers();
//     });
//   }

//   void _filterUsers() {
//     final filteredList = usersWithConversations
//         .where((user) =>
//             user['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
//             user['email'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
//             user['lastMessage']
//                 .toLowerCase()
//                 .contains(_searchQuery.toLowerCase()))
//         .toList();

//     setState(() {
//       filteredUsers = filteredList;
//     });
//   }

//   // void _navigateToMessageDetails(Map<String, dynamic> user) {
//   //   if (user['authUid'] == null) {
//   //     debugPrint("User authUid is null");
//   //     return;
//   //   }

//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute(
//   //       builder: (context) => MessageDetailsPage(message: {
//   //         'authUid': user['authUid'],
//   //         'name': user['name'],
//   //         'profilePicUrl': user['profilePicUrl'],
//   //       }),
//   //     ),
//   //   );
//   // }

//   void _navigateToMessageDetails(Map<String, dynamic> user) {
//     if (user['authUid'] == null) {
//       debugPrint("User authUid is null");
//       return;
//     }

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MessageDetailsPage(message: {
//           'authUid': user['authUid'],
//           'name': user['name'],
//           'profilePicUrl': user['profilePicUrl'],
//         }),
//       ),
//     );
//   }

//   void _showUserListModal() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 'Chat with',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 400, // You can adjust the height as needed
//               child: ListView.builder(
//                 itemCount: allUsers.length,
//                 itemBuilder: (context, index) {
//                   final user = allUsers[index];
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(user['profilePicUrl']),
//                     ),
//                     title: Text(user['name']),
//                     onTap: () {
//                       Navigator.pop(context);
//                       _navigateToMessageDetails(user);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String _formatTimestamp(Timestamp? timestamp) {
//     if (timestamp == null) {
//       return '';
//     }
//     DateTime date = timestamp.toDate();
//     return DateFormat('MMM dd, hh:mm a').format(date);
//   }

//   String _getFirstName(String name) {
//     return name.split(' ').first;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Builder(
//         builder: (context) {
//           return Column(
//             children: [
//               const Padding(
//                 padding: EdgeInsets.fromLTRB(16, 48.0, 16, 2),
//                 child: Text(
//                   'Messages',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//                 child: SearchMessageButton(
//                   searchQuery: _searchQuery,
//                   onUpdateValue: (value) {
//                     setState(() {
//                       _searchQuery = value;
//                       _filterUsers();
//                     });
//                   },
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: filteredUsers.length,
//                   itemBuilder: (context, index) {
//                     final user = filteredUsers[index];
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(user['profilePicUrl']),
//                       ),
//                       title: Text(
//                         _getFirstName(user['name']),
//                         style: const TextStyle(
//                           color: mainColor,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       subtitle: Text(user['lastMessage'] ?? 'No messages yet'),
//                       trailing: Text(
//                         _formatTimestamp(user['lastMessageTime']),
//                         style: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                         ),
//                       ),
//                       onTap: () => _navigateToMessageDetails(user),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.fromLTRB(0, 0, 5, 100),
//         child: FloatingActionButton(
//           onPressed: _showUserListModal,
//           backgroundColor: mainColor,
//           child: const Icon(Icons.add, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }

import 'package:intl/intl.dart';
import 'controllers/_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pcic_mobile_app/src/messages/components/_searchMessage.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  MessagesPageState createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final List<Map<String, dynamic>> usersWithConversations = [];
  List<Map<String, dynamic>> filteredUsers = [];
  String _searchQuery = '';
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      debugPrint("Firebase Messaging Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        debugPrint('Message data: ${message.data}');
        debugPrint('Message notification: ${message.notification}');
      }
    });

    _getCurrentUser();
  }

  void _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
      _fetchUsersWithConversations();
    }
  }

  Future<void> _fetchUsersWithConversations() async {
    if (_currentUser == null) return;

    QuerySnapshot conversationSnapshot = await _firestore
        .collection('conversations')
        .where('participants', arrayContains: _currentUser!.uid)
        .get();

    List<Map<String, dynamic>> tempUsersWithConversations = [];

    for (var conversation in conversationSnapshot.docs) {
      List<dynamic> participants = conversation['participants'];
      String lastMessage = '';
      Timestamp lastMessageTime = Timestamp.now();

      // Fetch the last message
      QuerySnapshot messageSnapshot = await _firestore
          .collection('conversations')
          .doc(conversation.id)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (messageSnapshot.docs.isNotEmpty) {
        lastMessage = messageSnapshot.docs.first.get('message') ?? '';
        lastMessageTime =
            messageSnapshot.docs.first.get('timestamp') ?? Timestamp.now();
      }

      // Only include users if the last message is not empty
      if (lastMessage.isNotEmpty) {
        for (var participantUid in participants) {
          if (participantUid != _currentUser!.uid) {
            DocumentSnapshot userSnapshot =
                await _firestore.collection('users').doc(participantUid).get();
            Map<String, dynamic> userData =
                userSnapshot.data() as Map<String, dynamic>;

            userData['authUid'] = participantUid; // Ensure authUid is included
            userData['lastMessage'] = lastMessage;
            userData['lastMessageTime'] = lastMessageTime;

            tempUsersWithConversations.add(userData);
          }
        }
      }
    }

    setState(() {
      usersWithConversations.clear();
      usersWithConversations.addAll(tempUsersWithConversations);
      filteredUsers = usersWithConversations;
      _filterUsers();
    });
  }

  void _filterUsers() {
    final filteredList = usersWithConversations
        .where((user) =>
            user['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user['email'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user['lastMessage']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();

    setState(() {
      filteredUsers = filteredList;
    });
  }

  void _navigateToMessageDetails(Map<String, dynamic> user) {
    if (user['authUid'] == null) {
      debugPrint("User authUid is null");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailsPage(message: {
          'authUid': user['authUid'],
          'name': user['name'],
          'profilePicUrl': user['profilePicUrl'],
        }),
      ),
    );
  }

  void _showUserListModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Chat with',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 400, // You can adjust the height as needed
              child: ListView.builder(
                itemCount: usersWithConversations.length,
                itemBuilder: (context, index) {
                  final user = usersWithConversations[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['profilePicUrl']),
                    ),
                    title: Text(user['name']),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToMessageDetails(user);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return '';
    }
    DateTime date = timestamp.toDate();
    return DateFormat('MMM dd, hh:mm a').format(date);
  }

  String _getFirstName(String name) {
    return name.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 48.0, 16, 2),
                child: Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: SearchMessageButton(
                  searchQuery: _searchQuery,
                  onUpdateValue: (value) {
                    setState(() {
                      _searchQuery = value;
                      _filterUsers();
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user['profilePicUrl']),
                      ),
                      title: Text(
                        _getFirstName(user['name']),
                        style: const TextStyle(
                          color: mainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(user['lastMessage']),
                      trailing: Text(
                        _formatTimestamp(user['lastMessageTime']),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      onTap: () => _navigateToMessageDetails(user),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 100),
        child: FloatingActionButton(
          onPressed: _showUserListModal,
          backgroundColor: mainColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
