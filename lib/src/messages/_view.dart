// src/messages/_view.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/_searchMessage.dart';
import 'controllers/_detail.dart';

import '../theme/_theme.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      // debugPrint("Firebase Messaging Token: $token");
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
      await _fetchUsersWithConversations();
    } else {
      debugPrint("No current user logged in");
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchUsersWithConversations() async {
    if (_currentUser == null) return;

    try {
      QuerySnapshot conversationSnapshot = await _firestore
          .collection('conversations')
          .where('participants', arrayContains: _currentUser!.uid)
          .get();

      List<Map<String, dynamic>> tempUsersWithConversations = [];
      int unseenMessagesCount = 0;

      for (var conversation in conversationSnapshot.docs) {
        List<dynamic> participants = conversation['participants'];
        String lastMessage = '';
        Timestamp lastMessageTime = Timestamp.now();
        bool isSeen = true;
        bool isUserMessage = false;

        QuerySnapshot messageSnapshot = await _firestore
            .collection('conversations')
            .doc(conversation.id)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (messageSnapshot.docs.isNotEmpty) {
          var messageDoc = messageSnapshot.docs.first;
          Map<String, dynamic>? messageData =
              messageDoc.data() as Map<String, dynamic>?;
          lastMessage = messageData?['message'] ?? '';
          lastMessageTime = messageData?['timestamp'] ?? Timestamp.now();
          isUserMessage = messageData?['senderId'] == _currentUser!.uid;
          isSeen = messageData?['seen'] == true;

          if (!isSeen && !isUserMessage) {
            unseenMessagesCount++;
          }
        }

        if (lastMessage.isNotEmpty) {
          for (var participantUid in participants) {
            if (participantUid != _currentUser!.uid) {
              DocumentSnapshot userSnapshot = await _firestore
                  .collection('users')
                  .doc(participantUid)
                  .get();
              Map<String, dynamic>? userData =
                  userSnapshot.data() as Map<String, dynamic>?;

              if (userData != null) {
                userData['authUid'] = participantUid;
                userData['lastMessage'] =
                    isUserMessage ? 'you: $lastMessage' : lastMessage;
                userData['lastMessageTime'] = lastMessageTime;
                userData['isSeen'] = isSeen;
                userData['isUserMessage'] = isUserMessage;

                tempUsersWithConversations.add(userData);
              } else {
                debugPrint(
                    "User data is null for participantUid: $participantUid");
              }
            }
          }
        }
      }

      // Save the unseen messages count to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('unseenMessagesCount', unseenMessagesCount);

      // debugPrint('Unseen Messages Count: $unseenMessagesCount');

      setState(() {
        usersWithConversations.clear();
        usersWithConversations.addAll(tempUsersWithConversations);
        filteredUsers = usersWithConversations;
        _filterUsers();
      });
    } catch (e) {
      debugPrint("Error fetching users with conversations: $e");
    }
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

  Future<void> _navigateToMessageDetails(Map<String, dynamic> user) async {
    if (user['authUid'] == null) {
      debugPrint("User authUid is null");
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailsPage(message: {
          'authUid': user['authUid'],
          'name': user['name'],
          'profilePicUrl': user['profilePicUrl'],
        }),
      ),
    );

    if (result == true) {
      _fetchUsersWithConversations();
    }
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

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchUsersWithConversations();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _isLoading
            ? Center(
                child: Image.asset(
                  'assets/icons/pccc.gif',
                  width: 175,
                  height: 175,
                ),
              )
            : Builder(
                builder: (context) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 48.0, 16, 2),
                        child: Text(
                          'Messages',
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 22,
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
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            bool isSeen = user['isSeen'] ?? false;
                            bool isUserMessage = user['isUserMessage'] ?? false;

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: SizedBox(
                                    height: 60.0,
                                    width: 60.0,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user['profilePicUrl']),
                                    ),
                                  ),
                                  title: Text(
                                    _getFirstName(user['name']),
                                    style: const TextStyle(
                                      color: mainColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    user['lastMessage'],
                                    style: TextStyle(
                                      fontSize: isSeen ? 14 : 16,
                                      fontWeight: isSeen
                                          ? FontWeight.normal
                                          : FontWeight.w700,
                                    ),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                        _formatTimestamp(
                                            user['lastMessageTime']),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      if (isUserMessage && isSeen)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: SvgPicture.asset(
                                            'assets/icons/seen.svg',
                                            width: 20,
                                            height: 20,
                                            color: mainColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                  onTap: () => _navigateToMessageDetails(user),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
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
