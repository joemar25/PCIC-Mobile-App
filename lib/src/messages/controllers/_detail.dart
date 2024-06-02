import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

class MessageDetailsPage extends StatefulWidget {
  final Map<String, dynamic> message;
  const MessageDetailsPage({super.key, required this.message});

  @override
  MessageDetailsPageState createState() => MessageDetailsPageState();
}

class MessageDetailsPageState extends State<MessageDetailsPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _userMessages = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserMessages();
  }

  void _fetchUserMessages() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('conversations')
        .doc(widget.message['authUid'])
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();

    List<Map<String, dynamic>> fetchedMessages = snapshot.docs.map((doc) {
      return {
        'message': doc['message'],
        'timestamp': doc['timestamp'],
        'senderId': doc['senderId'],
      };
    }).toList();

    setState(() {
      _userMessages.addAll(fetchedMessages);
    });
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String message = _messageController.text;
      String currentUserUid = _auth.currentUser!.uid;

      debugPrint("Sending message: $message");

      try {
        DocumentReference currentUserDoc = _firestore
            .collection('users')
            .doc(currentUserUid)
            .collection('conversations')
            .doc(widget.message['authUid']);

        DocumentReference recipientUserDoc = _firestore
            .collection('users')
            .doc(widget.message['authUid'])
            .collection('conversations')
            .doc(currentUserUid);

        await currentUserDoc.collection('messages').add({
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
          'senderId': currentUserUid,
        });

        await recipientUserDoc.collection('messages').add({
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
          'senderId': currentUserUid,
        });

        debugPrint("Message sent successfully");

        setState(() {
          _userMessages.add({
            'message': message,
            'timestamp': Timestamp.now(),
            'senderId': currentUserUid,
          });
          _messageController.clear();
        });
      } catch (e) {
        debugPrint("Error sending message: $e");
      }
    } else {
      debugPrint("Message text is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: mainColor),
        title: Center(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.message['name'],
                      style: const TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _userMessages.length,
                itemBuilder: (context, index) {
                  final message =
                      _userMessages[_userMessages.length - 1 - index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Align(
                      alignment: message['senderId'] == _auth.currentUser?.uid
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (message['senderId'] != _auth.currentUser?.uid)
                            ClipOval(
                              child: Image.network(
                                widget.message['profilePicUrl'],
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (message['senderId'] != _auth.currentUser?.uid)
                            const SizedBox(width: 8.0),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color:
                                  message['senderId'] == _auth.currentUser?.uid
                                      ? const Color.fromRGBO(97, 97, 97, 1)
                                          .withOpacity(0.85)
                                      : mainColor,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(4, 5),
                                ),
                              ],
                            ),
                            child: Text(
                              message['message'],
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Inter',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewInsets.top,
              ),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Reply here... ',
                              hintStyle: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_upward_sharp),
                          onPressed: _sendMessage,
                          color: mainColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
