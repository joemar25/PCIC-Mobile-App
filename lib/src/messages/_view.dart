import 'package:intl/intl.dart';
import 'controllers/_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pcic_mobile_app/src/messages/components/_searchMessage.dart';
// filename: messages_page.dart

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  MessagesPageState createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final List<Map<String, dynamic>> allUsers = [];
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
      // Save the token in Firestore or use it as needed
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages
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
      _fetchAllUsers();
      _fetchUsersWithConversations();
    }
  }

  Future<void> _fetchAllUsers() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    List<Map<String, dynamic>> fetchedUsers =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    // Remove current user from the list
    fetchedUsers.removeWhere((user) => user['authUid'] == _currentUser?.uid);

    setState(() {
      allUsers.clear();
      allUsers.addAll(fetchedUsers);
    });
  }

  Future<void> _fetchUsersWithConversations() async {
    if (_currentUser == null) return;

    QuerySnapshot snapshot = await _firestore.collection('users').get();
    List<Map<String, dynamic>> fetchedUsers =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    for (var user in fetchedUsers) {
      if (user['authUid'] == _currentUser?.uid) {
        continue; // Skip the current user
      }

      String userId = user['authUid'];
      QuerySnapshot messageSnapshot = await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('conversations')
          .doc(userId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (messageSnapshot.docs.isNotEmpty) {
        user['lastMessage'] = messageSnapshot.docs.first['message'];
        user['lastMessageTime'] = messageSnapshot.docs.first['timestamp'];
        usersWithConversations.add(user);
      }
    }

    setState(() {
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailsPage(message: {
          'authUid': user['authUid'],
          'name': user['name'],
          'profilePicUrl': user['profilePicUrl'], // Passing profilePicUrl
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
            Expanded(
              child: ListView.builder(
                itemCount: allUsers.length,
                itemBuilder: (context, index) {
                  final user = allUsers[index];
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
                      subtitle: Text(user['lastMessage'] ?? 'No messages yet'),
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
