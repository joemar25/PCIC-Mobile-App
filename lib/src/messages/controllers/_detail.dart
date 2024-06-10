// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pcic_mobile_app/src/theme/_theme.dart';

// class MessageDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> message;
//   const MessageDetailsPage({super.key, required this.message});

//   @override
//   MessageDetailsPageState createState() => MessageDetailsPageState();
// }

// class MessageDetailsPageState extends State<MessageDetailsPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, dynamic>> _userMessages = [];
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserMessages();
//   }

//   void _fetchUserMessages() async {
//     User? currentUser = _auth.currentUser;
//     if (currentUser == null) return;

//     String conversationId =
//         _getConversationId(currentUser.uid, widget.message['authUid']);

//     QuerySnapshot snapshot = await _firestore
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .get();

//     List<Map<String, dynamic>> fetchedMessages = snapshot.docs.map((doc) {
//       return {
//         'message': doc.get('message') ?? '',
//         'timestamp': doc.get('timestamp') ?? Timestamp.now(),
//         'senderId': doc.get('senderId') ?? '',
//       };
//     }).toList();

//     setState(() {
//       _userMessages.addAll(fetchedMessages);
//     });
//   }

//   void _sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       String message = _messageController.text;
//       User? currentUser = _auth.currentUser;
//       String? recipientUid = widget.message['authUid'];

//       if (currentUser == null) {
//         debugPrint("No current user logged in");
//         return;
//       }

//       if (recipientUid == null) {
//         debugPrint("Recipient UID is null");
//         return;
//       }

//       String conversationId = _getConversationId(currentUser.uid, recipientUid);
//       debugPrint("Sending message in conversation ID: $conversationId");

//       try {
//         DocumentReference conversationDoc =
//             _firestore.collection('conversations').doc(conversationId);

//         // Add message to the messages subcollection
//         await conversationDoc.collection('messages').add({
//           'message': message,
//           'timestamp': FieldValue.serverTimestamp(),
//           'senderId': currentUser.uid,
//         });
//         debugPrint("Message added to Firestore");

//         // Ensure the participants array is updated in the conversation document
//         await conversationDoc.set({
//           'participants':
//               FieldValue.arrayUnion([currentUser.uid, recipientUid]),
//         }, SetOptions(merge: true));
//         debugPrint("Participants updated in Firestore");

//         setState(() {
//           _userMessages.add({
//             'message': message,
//             'timestamp': Timestamp.now(),
//             'senderId': currentUser.uid,
//           });
//           _messageController.clear();
//         });
//       } catch (e) {
//         debugPrint("Error sending message: $e");
//       }
//     } else {
//       debugPrint("Message text is empty");
//     }
//   }

//   String _getConversationId(String user1, String user2) {
//     return user1.compareTo(user2) < 0 ? '$user1-$user2' : '$user2-$user1';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         iconTheme: const IconThemeData(color: mainColor),
//         title: Center(
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       widget.message['name'],
//                       style: const TextStyle(
//                         color: mainColor,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Poppins',
//                         fontSize: 24.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 32),
//             ],
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 reverse: true,
//                 itemCount: _userMessages.length,
//                 itemBuilder: (context, index) {
//                   final message =
//                       _userMessages[_userMessages.length - 1 - index];
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Align(
//                       alignment: message['senderId'] == _auth.currentUser?.uid
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (message['senderId'] != _auth.currentUser?.uid)
//                             ClipOval(
//                               child: Image.network(
//                                 widget.message['profilePicUrl'] ?? '',
//                                 width: 55,
//                                 height: 55,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           if (message['senderId'] != _auth.currentUser?.uid)
//                             const SizedBox(width: 8.0),
//                           Container(
//                             padding: const EdgeInsets.all(16.0),
//                             decoration: BoxDecoration(
//                               color:
//                                   message['senderId'] == _auth.currentUser?.uid
//                                       ? const Color.fromRGBO(97, 97, 97, 1)
//                                           .withOpacity(0.85)
//                                       : mainColor,
//                               borderRadius: BorderRadius.circular(32),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.2),
//                                   spreadRadius: 2,
//                                   blurRadius: 10,
//                                   offset: const Offset(4, 5),
//                                 ),
//                               ],
//                             ),
//                             child: Text(
//                               message['message'],
//                               style: const TextStyle(
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.w300,
//                                 fontFamily: 'Inter',
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: MediaQuery.of(context).viewInsets.top,
//               ),
//               child: Container(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
//                   child: Container(
//                     padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(32),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 5,
//                           blurRadius: 7,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _messageController,
//                             decoration: const InputDecoration(
//                               hintText: 'Reply here... ',
//                               hintStyle: TextStyle(
//                                 fontFamily: 'Inter',
//                                 fontWeight: FontWeight.w300,
//                               ),
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.arrow_upward_sharp),
//                           onPressed: _sendMessage,
//                           color: mainColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pcic_mobile_app/src/theme/_theme.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class MessageDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> message;
//   const MessageDetailsPage({super.key, required this.message});

//   @override
//   MessageDetailsPageState createState() => MessageDetailsPageState();
// }

// class MessageDetailsPageState extends State<MessageDetailsPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, dynamic>> _userMessages = [];
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserMessages();
//   }

//   void _fetchUserMessages() async {
//     User? currentUser = _auth.currentUser;
//     if (currentUser == null) return;

//     String conversationId =
//         _getConversationId(currentUser.uid, widget.message['authUid']);

//     QuerySnapshot snapshot = await _firestore
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .get();

//     List<Map<String, dynamic>> fetchedMessages = snapshot.docs.map((doc) {
//       return {
//         'messageId': doc.id,
//         'message': doc.get('message') ?? '',
//         'timestamp': doc.get('timestamp') ?? Timestamp.now(),
//         'senderId': doc.get('senderId') ?? '',
//         'seen': doc.get('seen') ?? false,
//       };
//     }).toList();

//     setState(() {
//       _userMessages.addAll(fetchedMessages);
//     });

//     // Mark messages as seen
//     for (var message in fetchedMessages) {
//       if (message['senderId'] != currentUser.uid && !message['seen']) {
//         _markMessageAsSeen(conversationId, message['messageId']);
//       }
//     }
//   }

//   void _markMessageAsSeen(String conversationId, String messageId) async {
//     await _firestore
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .doc(messageId)
//         .update({'seen': true});
//   }

//   void _sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       String message = _messageController.text;
//       User? currentUser = _auth.currentUser;
//       String? recipientUid = widget.message['authUid'];

//       if (currentUser == null) {
//         debugPrint("No current user logged in");
//         return;
//       }

//       if (recipientUid == null) {
//         debugPrint("Recipient UID is null");
//         return;
//       }

//       String conversationId = _getConversationId(currentUser.uid, recipientUid);
//       debugPrint("Sending message in conversation ID: $conversationId");

//       try {
//         DocumentReference conversationDoc =
//             _firestore.collection('conversations').doc(conversationId);

//         // Add message to the messages subcollection
//         await conversationDoc.collection('messages').add({
//           'message': message,
//           'timestamp': FieldValue.serverTimestamp(),
//           'senderId': currentUser.uid,
//           'seen': false, // Initialize as unseen
//         });
//         debugPrint("Message added to Firestore");

//         // Ensure the participants array is updated in the conversation document
//         await conversationDoc.set({
//           'participants':
//               FieldValue.arrayUnion([currentUser.uid, recipientUid]),
//         }, SetOptions(merge: true));
//         debugPrint("Participants updated in Firestore");

//         setState(() {
//           _userMessages.add({
//             'message': message,
//             'timestamp': Timestamp.now(),
//             'senderId': currentUser.uid,
//             'seen': false, // Initialize as unseen
//           });
//           _messageController.clear();
//         });
//       } catch (e) {
//         debugPrint("Error sending message: $e");
//       }
//     } else {
//       debugPrint("Message text is empty");
//     }
//   }

//   String _getConversationId(String user1, String user2) {
//     return user1.compareTo(user2) < 0 ? '$user1-$user2' : '$user2-$user1';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         iconTheme: const IconThemeData(color: mainColor),
//         title: Center(
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       widget.message['name'],
//                       style: const TextStyle(
//                         color: mainColor,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Poppins',
//                         fontSize: 24.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 32),
//             ],
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 reverse: true,
//                 itemCount: _userMessages.length,
//                 itemBuilder: (context, index) {
//                   final message =
//                       _userMessages[_userMessages.length - 1 - index];
//                   bool isSeen = message['seen'];

//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Align(
//                       alignment: message['senderId'] == _auth.currentUser?.uid
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (message['senderId'] != _auth.currentUser?.uid)
//                             ClipOval(
//                               child: Image.network(
//                                 widget.message['profilePicUrl'] ?? '',
//                                 width: 55,
//                                 height: 55,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           if (message['senderId'] != _auth.currentUser?.uid)
//                             const SizedBox(width: 8.0),
//                           Container(
//                             padding: const EdgeInsets.all(16.0),
//                             decoration: BoxDecoration(
//                               color:
//                                   message['senderId'] == _auth.currentUser?.uid
//                                       ? const Color.fromRGBO(97, 97, 97, 1)
//                                           .withOpacity(0.85)
//                                       : mainColor,
//                               borderRadius: BorderRadius.circular(32),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.2),
//                                   spreadRadius: 2,
//                                   blurRadius: 10,
//                                   offset: const Offset(4, 5),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   message['message'],
//                                   style: const TextStyle(
//                                     fontSize: 16.0,
//                                     fontWeight: FontWeight.w300,
//                                     fontFamily: 'Inter',
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 if (isSeen)
//                                   SvgPicture.asset(
//                                     'assets/icons/seen.svg',
//                                     width: 20,
//                                     height: 20,
//                                     color: Colors.green,
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: MediaQuery.of(context).viewInsets.top,
//               ),
//               child: Container(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
//                   child: Container(
//                     padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(32),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 5,
//                           blurRadius: 7,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _messageController,
//                             decoration: const InputDecoration(
//                               hintText: 'Reply here... ',
//                               hintStyle: TextStyle(
//                                 fontFamily: 'Inter',
//                                 fontWeight: FontWeight.w300,
//                               ),
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.arrow_upward_sharp),
//                           onPressed: _sendMessage,
//                           color: mainColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pcic_mobile_app/src/theme/_theme.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class MessageDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> message;
//   const MessageDetailsPage({super.key, required this.message});

//   @override
//   MessageDetailsPageState createState() => MessageDetailsPageState();
// }

// class MessageDetailsPageState extends State<MessageDetailsPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, dynamic>> _userMessages = [];
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserMessages();
//   }

//   void _fetchUserMessages() async {
//     User? currentUser = _auth.currentUser;
//     if (currentUser == null) return;

//     String conversationId =
//         _getConversationId(currentUser.uid, widget.message['authUid']);

//     QuerySnapshot snapshot = await _firestore
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .get();

//     List<Map<String, dynamic>> fetchedMessages = snapshot.docs.map((doc) {
//       return {
//         'messageId': doc.id,
//         'message': doc.get('message') ?? '',
//         'timestamp': doc.get('timestamp') ?? Timestamp.now(),
//         'senderId': doc.get('senderId') ?? '',
//         'seen': doc.get('seen') ?? false,
//       };
//     }).toList();

//     setState(() {
//       _userMessages.addAll(fetchedMessages);
//     });

//     // Mark messages as seen
//     for (var message in fetchedMessages) {
//       if (message['senderId'] != currentUser.uid && !message['seen']) {
//         _markMessageAsSeen(conversationId, message['messageId']);
//       }
//     }
//   }

//   void _markMessageAsSeen(String conversationId, String messageId) async {
//     await _firestore
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .doc(messageId)
//         .update({'seen': true});
//   }

//   void _sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       String message = _messageController.text;
//       User? currentUser = _auth.currentUser;
//       String? recipientUid = widget.message['authUid'];

//       if (currentUser == null) {
//         debugPrint("No current user logged in");
//         return;
//       }

//       if (recipientUid == null) {
//         debugPrint("Recipient UID is null");
//         return;
//       }

//       String conversationId = _getConversationId(currentUser.uid, recipientUid);
//       debugPrint("Sending message in conversation ID: $conversationId");

//       try {
//         DocumentReference conversationDoc =
//             _firestore.collection('conversations').doc(conversationId);

//         // Add message to the messages subcollection
//         await conversationDoc.collection('messages').add({
//           'message': message,
//           'timestamp': FieldValue.serverTimestamp(),
//           'senderId': currentUser.uid,
//           'seen': false, // Initialize as unseen
//         });
//         debugPrint("Message added to Firestore");

//         // Ensure the participants array is updated in the conversation document
//         await conversationDoc.set({
//           'participants':
//               FieldValue.arrayUnion([currentUser.uid, recipientUid]),
//         }, SetOptions(merge: true));
//         debugPrint("Participants updated in Firestore");

//         setState(() {
//           _userMessages.add({
//             'message': message,
//             'timestamp': Timestamp.now(),
//             'senderId': currentUser.uid,
//             'seen': false, // Initialize as unseen
//           });
//           _messageController.clear();
//         });
//       } catch (e) {
//         debugPrint("Error sending message: $e");
//       }
//     } else {
//       debugPrint("Message text is empty");
//     }
//   }

//   String _getConversationId(String user1, String user2) {
//     return user1.compareTo(user2) < 0 ? '$user1-$user2' : '$user2-$user1';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         iconTheme: const IconThemeData(color: mainColor),
//         title: Center(
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       widget.message['name'],
//                       style: const TextStyle(
//                         color: mainColor,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Poppins',
//                         fontSize: 24.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 32),
//             ],
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 reverse: true,
//                 itemCount: _userMessages.length,
//                 itemBuilder: (context, index) {
//                   final message =
//                       _userMessages[_userMessages.length - 1 - index];
//                   bool isSeen = message['seen'];

//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Row(
//                       mainAxisAlignment:
//                           message['senderId'] == _auth.currentUser?.uid
//                               ? MainAxisAlignment.end
//                               : MainAxisAlignment.start,
//                       children: [
//                         if (message['senderId'] != _auth.currentUser?.uid)
//                           ClipOval(
//                             child: Image.network(
//                               widget.message['profilePicUrl'] ?? '',
//                               width: 55,
//                               height: 55,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         if (message['senderId'] != _auth.currentUser?.uid)
//                           const SizedBox(width: 8.0),
//                         Column(
//                           crossAxisAlignment:
//                               message['senderId'] == _auth.currentUser?.uid
//                                   ? CrossAxisAlignment.end
//                                   : CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(16.0),
//                               decoration: BoxDecoration(
//                                 color: message['senderId'] ==
//                                         _auth.currentUser?.uid
//                                     ? mainColor
//                                     : const Color.fromRGBO(97, 97, 97, 1)
//                                         .withOpacity(0.85),
//                                 borderRadius: BorderRadius.circular(32),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.2),
//                                     spreadRadius: 2,
//                                     blurRadius: 10,
//                                     offset: const Offset(4, 5),
//                                   ),
//                                 ],
//                               ),
//                               child: Text(
//                                 message['message'],
//                                 style: const TextStyle(
//                                   fontSize: 16.0,
//                                   fontWeight: FontWeight.w300,
//                                   fontFamily: 'Inter',
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             if (message['senderId'] == _auth.currentUser?.uid &&
//                                 isSeen)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 0.0),
//                                 child: SvgPicture.asset(
//                                   'assets/icons/seen.svg',
//                                   width: 20,
//                                   height: 20,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: MediaQuery.of(context).viewInsets.top,
//               ),
//               child: Container(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
//                   child: Container(
//                     padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(32),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 5,
//                           blurRadius: 7,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _messageController,
//                             decoration: const InputDecoration(
//                               hintText: 'Reply here... ',
//                               hintStyle: TextStyle(
//                                 fontFamily: 'Inter',
//                                 fontWeight: FontWeight.w300,
//                               ),
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.arrow_upward_sharp),
//                           onPressed: _sendMessage,
//                           color: mainColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pcic_mobile_app/src/theme/_theme.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class MessageDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> message;
//   const MessageDetailsPage({super.key, required this.message});

//   @override
//   MessageDetailsPageState createState() => MessageDetailsPageState();
// }

// class MessageDetailsPageState extends State<MessageDetailsPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, dynamic>> _userMessages = [];
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserMessages();
//   }

//   void _fetchUserMessages() async {
//     User? currentUser = _auth.currentUser;
//     if (currentUser == null) return;

//     String conversationId =
//         _getConversationId(currentUser.uid, widget.message['authUid']);

//     QuerySnapshot snapshot = await _firestore
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .get();

//     List<Map<String, dynamic>> fetchedMessages = snapshot.docs.map((doc) {
//       return {
//         'messageId': doc.id,
//         'message': doc.get('message') ?? '',
//         'timestamp': doc.get('timestamp') ?? Timestamp.now(),
//         'senderId': doc.get('senderId') ?? '',
//         'seen': doc.get('seen') ?? false,
//       };
//     }).toList();

//     setState(() {
//       _userMessages.addAll(fetchedMessages);
//     });

//     // Mark messages as seen
//     for (var message in fetchedMessages) {
//       if (message['senderId'] != currentUser.uid && !message['seen']) {
//         _markMessageAsSeen(conversationId, message['messageId']);
//       }
//     }
//   }

//   void _markMessageAsSeen(String conversationId, String messageId) async {
//     await _firestore
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .doc(messageId)
//         .update({'seen': true});
//   }

//   void _sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       String message = _messageController.text;
//       User? currentUser = _auth.currentUser;
//       String? recipientUid = widget.message['authUid'];

//       if (currentUser == null) {
//         debugPrint("No current user logged in");
//         return;
//       }

//       if (recipientUid == null) {
//         debugPrint("Recipient UID is null");
//         return;
//       }

//       String conversationId = _getConversationId(currentUser.uid, recipientUid);
//       debugPrint("Sending message in conversation ID: $conversationId");

//       try {
//         DocumentReference conversationDoc =
//             _firestore.collection('conversations').doc(conversationId);

//         // Add message to the messages subcollection
//         await conversationDoc.collection('messages').add({
//           'message': message,
//           'timestamp': FieldValue.serverTimestamp(),
//           'senderId': currentUser.uid,
//           'seen': false, // Initialize as unseen
//         });
//         debugPrint("Message added to Firestore");

//         // Ensure the participants array is updated in the conversation document
//         await conversationDoc.set({
//           'participants':
//               FieldValue.arrayUnion([currentUser.uid, recipientUid]),
//         }, SetOptions(merge: true));
//         debugPrint("Participants updated in Firestore");

//         setState(() {
//           _userMessages.add({
//             'message': message,
//             'timestamp': Timestamp.now(),
//             'senderId': currentUser.uid,
//             'seen': false, // Initialize as unseen
//           });
//           _messageController.clear();
//         });
//       } catch (e) {
//         debugPrint("Error sending message: $e");
//       }
//     } else {
//       debugPrint("Message text is empty");
//     }
//   }

//   String _getConversationId(String user1, String user2) {
//     return user1.compareTo(user2) < 0 ? '$user1-$user2' : '$user2-$user1';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pop(context, true);
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           iconTheme: const IconThemeData(color: mainColor),
//           title: Center(
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         widget.message['name'],
//                         style: const TextStyle(
//                           color: mainColor,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'Poppins',
//                           fontSize: 24.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 32),
//               ],
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   reverse: true,
//                   itemCount: _userMessages.length,
//                   itemBuilder: (context, index) {
//                     final message =
//                         _userMessages[_userMessages.length - 1 - index];
//                     bool isSeen = message['seen'];

//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Row(
//                         mainAxisAlignment:
//                             message['senderId'] == _auth.currentUser?.uid
//                                 ? MainAxisAlignment.end
//                                 : MainAxisAlignment.start,
//                         children: [
//                           if (message['senderId'] != _auth.currentUser?.uid)
//                             ClipOval(
//                               child: Image.network(
//                                 widget.message['profilePicUrl'] ?? '',
//                                 width: 55,
//                                 height: 55,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           if (message['senderId'] != _auth.currentUser?.uid)
//                             const SizedBox(width: 8.0),
//                           Column(
//                             crossAxisAlignment:
//                                 message['senderId'] == _auth.currentUser?.uid
//                                     ? CrossAxisAlignment.end
//                                     : CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(16.0),
//                                 decoration: BoxDecoration(
//                                   color: message['senderId'] ==
//                                           _auth.currentUser?.uid
//                                       ? mainColor
//                                       : const Color.fromRGBO(97, 97, 97, 1)
//                                           .withOpacity(0.85),
//                                   borderRadius: BorderRadius.circular(32),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.2),
//                                       spreadRadius: 2,
//                                       blurRadius: 10,
//                                       offset: const Offset(4, 5),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Text(
//                                   message['message'],
//                                   style: const TextStyle(
//                                     fontSize: 16.0,
//                                     fontWeight: FontWeight.w300,
//                                     fontFamily: 'Inter',
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                               if (message['senderId'] ==
//                                       _auth.currentUser?.uid &&
//                                   isSeen)
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 0.0),
//                                   child: SvgPicture.asset(
//                                     'assets/icons/seen.svg',
//                                     width: 20,
//                                     height: 20,
//                                     color: Colors.green,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: MediaQuery.of(context).viewInsets.top,
//                 ),
//                 child: Container(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
//                     child: Container(
//                       padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(32),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 5,
//                             blurRadius: 7,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: _messageController,
//                               decoration: const InputDecoration(
//                                 hintText: 'Reply here... ',
//                                 hintStyle: TextStyle(
//                                   fontFamily: 'Inter',
//                                   fontWeight: FontWeight.w300,
//                                 ),
//                                 border: InputBorder.none,
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.arrow_upward_sharp),
//                             onPressed: _sendMessage,
//                             color: mainColor,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pcic_mobile_app/src/theme/_theme.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class MessageDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> message;
//   const MessageDetailsPage({super.key, required this.message});

//   @override
//   MessageDetailsPageState createState() => MessageDetailsPageState();
// }

// class MessageDetailsPageState extends State<MessageDetailsPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, dynamic>> _userMessages = [];
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserMessages();
//   }

//   void _fetchUserMessages() async {
//     User? currentUser = _auth.currentUser;
//     if (currentUser == null) return;

//     String conversationId =
//         _getConversationId(currentUser.uid, widget.message['authUid']);

//     QuerySnapshot snapshot = await _firestore
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .get();

//     List<Map<String, dynamic>> fetchedMessages = snapshot.docs.map((doc) {
//       return {
//         'messageId': doc.id,
//         'message': doc.get('message') ?? '',
//         'timestamp': doc.get('timestamp') ?? Timestamp.now(),
//         'senderId': doc.get('senderId') ?? '',
//         'seen': doc.get('seen') ?? false,
//       };
//     }).toList();

//     setState(() {
//       _userMessages.addAll(fetchedMessages);
//     });

//     // Mark messages as seen
//     for (var message in fetchedMessages) {
//       if (message['senderId'] != currentUser.uid && !message['seen']) {
//         _markMessageAsSeen(conversationId, message['messageId']);
//       }
//     }
//   }

//   void _markMessageAsSeen(String conversationId, String messageId) async {
//     await _firestore
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .doc(messageId)
//         .update({'seen': true});
//   }

//   void _sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       String message = _messageController.text;
//       User? currentUser = _auth.currentUser;
//       String? recipientUid = widget.message['authUid'];

//       if (currentUser == null) {
//         debugPrint("No current user logged in");
//         return;
//       }

//       if (recipientUid == null) {
//         debugPrint("Recipient UID is null");
//         return;
//       }

//       String conversationId = _getConversationId(currentUser.uid, recipientUid);
//       debugPrint("Sending message in conversation ID: $conversationId");

//       try {
//         DocumentReference conversationDoc =
//             _firestore.collection('conversations').doc(conversationId);

//         // Add message to the messages subcollection
//         await conversationDoc.collection('messages').add({
//           'message': message,
//           'timestamp': FieldValue.serverTimestamp(),
//           'senderId': currentUser.uid,
//           'seen': false, // Initialize as unseen
//         });
//         debugPrint("Message added to Firestore");

//         // Ensure the participants array is updated in the conversation document
//         await conversationDoc.set({
//           'participants':
//               FieldValue.arrayUnion([currentUser.uid, recipientUid]),
//         }, SetOptions(merge: true));
//         debugPrint("Participants updated in Firestore");

//         setState(() {
//           _userMessages.add({
//             'message': message,
//             'timestamp': Timestamp.now(),
//             'senderId': currentUser.uid,
//             'seen': false, // Initialize as unseen
//           });
//           _messageController.clear();
//         });
//       } catch (e) {
//         debugPrint("Error sending message: $e");
//       }
//     } else {
//       debugPrint("Message text is empty");
//     }
//   }

//   String _getConversationId(String user1, String user2) {
//     return user1.compareTo(user2) < 0 ? '$user1-$user2' : '$user2-$user1';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         iconTheme: const IconThemeData(color: mainColor),
//         title: Center(
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       widget.message['name'],
//                       style: const TextStyle(
//                         color: mainColor,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Poppins',
//                         fontSize: 24.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 32),
//             ],
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context, true); // Pass true to indicate a reload
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 reverse: true,
//                 itemCount: _userMessages.length,
//                 itemBuilder: (context, index) {
//                   final message =
//                       _userMessages[_userMessages.length - 1 - index];
//                   bool isSeen = message['seen'];

//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Row(
//                       mainAxisAlignment:
//                           message['senderId'] == _auth.currentUser?.uid
//                               ? MainAxisAlignment.end
//                               : MainAxisAlignment.start,
//                       children: [
//                         if (message['senderId'] != _auth.currentUser?.uid)
//                           ClipOval(
//                             child: Image.network(
//                               widget.message['profilePicUrl'] ?? '',
//                               width: 55,
//                               height: 55,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         if (message['senderId'] != _auth.currentUser?.uid)
//                           const SizedBox(width: 8.0),
//                         Column(
//                           crossAxisAlignment:
//                               message['senderId'] == _auth.currentUser?.uid
//                                   ? CrossAxisAlignment.end
//                                   : CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(16.0),
//                               decoration: BoxDecoration(
//                                 color: message['senderId'] ==
//                                         _auth.currentUser?.uid
//                                     ? mainColor
//                                     : const Color.fromRGBO(97, 97, 97, 1)
//                                         .withOpacity(0.85),
//                                 borderRadius: BorderRadius.circular(32),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.2),
//                                     spreadRadius: 2,
//                                     blurRadius: 10,
//                                     offset: const Offset(4, 5),
//                                   ),
//                                 ],
//                               ),
//                               child: Text(
//                                 message['message'],
//                                 style: const TextStyle(
//                                   fontSize: 16.0,
//                                   fontWeight: FontWeight.w300,
//                                   fontFamily: 'Inter',
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             if (message['senderId'] == _auth.currentUser?.uid &&
//                                 isSeen)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 0.0),
//                                 child: SvgPicture.asset(
//                                   'assets/icons/seen.svg',
//                                   width: 20,
//                                   height: 20,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: MediaQuery.of(context).viewInsets.top,
//               ),
//               child: Container(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
//                   child: Container(
//                     padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(32),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 5,
//                           blurRadius: 7,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _messageController,
//                             decoration: const InputDecoration(
//                               hintText: 'Reply here... ',
//                               hintStyle: TextStyle(
//                                 fontFamily: 'Inter',
//                                 fontWeight: FontWeight.w300,
//                               ),
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.arrow_upward_sharp),
//                           onPressed: _sendMessage,
//                           color: mainColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pcic_mobile_app/src/theme/_theme.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class MessageDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> message;
//   const MessageDetailsPage({super.key, required this.message});

//   @override
//   MessageDetailsPageState createState() => MessageDetailsPageState();
// }

// class MessageDetailsPageState extends State<MessageDetailsPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, dynamic>> _userMessages = [];
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserMessages();
//   }

//   void _fetchUserMessages() async {
//     User? currentUser = _auth.currentUser;
//     if (currentUser == null) return;

//     String conversationId =
//         _getConversationId(currentUser.uid, widget.message['authUid']);

//     QuerySnapshot snapshot = await _firestore
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .get();

//     List<Map<String, dynamic>> fetchedMessages = snapshot.docs.map((doc) {
//       return {
//         'messageId': doc.id,
//         'message': doc.get('message') ?? '',
//         'timestamp': doc.get('timestamp') ?? Timestamp.now(),
//         'senderId': doc.get('senderId') ?? '',
//         'seen': doc.get('seen') ?? false,
//       };
//     }).toList();

//     setState(() {
//       _userMessages.addAll(fetchedMessages);
//     });

//     // Mark messages as seen
//     for (var message in fetchedMessages) {
//       if (message['senderId'] != currentUser.uid && !message['seen']) {
//         _markMessageAsSeen(conversationId, message['messageId']);
//       }
//     }
//   }

//   void _markMessageAsSeen(String conversationId, String messageId) async {
//     await _firestore
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .doc(messageId)
//         .update({'seen': true});
//   }

//   void _sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       String message = _messageController.text;
//       User? currentUser = _auth.currentUser;
//       String? recipientUid = widget.message['authUid'];

//       if (currentUser == null) {
//         debugPrint("No current user logged in");
//         return;
//       }

//       if (recipientUid == null) {
//         debugPrint("Recipient UID is null");
//         return;
//       }

//       String conversationId = _getConversationId(currentUser.uid, recipientUid);
//       debugPrint("Sending message in conversation ID: $conversationId");

//       try {
//         DocumentReference conversationDoc =
//             _firestore.collection('conversations').doc(conversationId);

//         // Add message to the messages subcollection
//         await conversationDoc.collection('messages').add({
//           'message': message,
//           'timestamp': FieldValue.serverTimestamp(),
//           'senderId': currentUser.uid,
//           'seen': false, // Initialize as unseen
//         });
//         debugPrint("Message added to Firestore");

//         // Ensure the participants array is updated in the conversation document
//         await conversationDoc.set({
//           'participants':
//               FieldValue.arrayUnion([currentUser.uid, recipientUid]),
//         }, SetOptions(merge: true));
//         debugPrint("Participants updated in Firestore");

//         setState(() {
//           _userMessages.add({
//             'message': message,
//             'timestamp': Timestamp.now(),
//             'senderId': currentUser.uid,
//             'seen': false, // Initialize as unseen
//           });
//           _messageController.clear();
//         });
//       } catch (e) {
//         debugPrint("Error sending message: $e");
//       }
//     } else {
//       debugPrint("Message text is empty");
//     }
//   }

//   String _getConversationId(String user1, String user2) {
//     return user1.compareTo(user2) < 0 ? '$user1-$user2' : '$user2-$user1';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         iconTheme: const IconThemeData(color: mainColor),
//         title: Center(
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       widget.message['name'],
//                       style: const TextStyle(
//                         color: mainColor,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Poppins',
//                         fontSize: 24.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 32),
//             ],
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 reverse: true,
//                 itemCount: _userMessages.length,
//                 itemBuilder: (context, index) {
//                   final message =
//                       _userMessages[_userMessages.length - 1 - index];
//                   bool isSeen = message['seen'];

//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Row(
//                       mainAxisAlignment:
//                           message['senderId'] == _auth.currentUser?.uid
//                               ? MainAxisAlignment.end
//                               : MainAxisAlignment.start,
//                       children: [
//                         if (message['senderId'] != _auth.currentUser?.uid)
//                           ClipOval(
//                             child: Image.network(
//                               widget.message['profilePicUrl'] ?? '',
//                               width: 55,
//                               height: 55,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         if (message['senderId'] != _auth.currentUser?.uid)
//                           const SizedBox(width: 8.0),
//                         Column(
//                           crossAxisAlignment:
//                               message['senderId'] == _auth.currentUser?.uid
//                                   ? CrossAxisAlignment.end
//                                   : CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(16.0),
//                               decoration: BoxDecoration(
//                                 color: message['senderId'] ==
//                                         _auth.currentUser?.uid
//                                     ? const Color.fromRGBO(97, 97, 97, 1)
//                                         .withOpacity(0.85)
//                                     : mainColor,
//                                 borderRadius: BorderRadius.circular(32),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.2),
//                                     spreadRadius: 2,
//                                     blurRadius: 10,
//                                     offset: const Offset(4, 5),
//                                   ),
//                                 ],
//                               ),
//                               child: Text(
//                                 message['message'],
//                                 style: const TextStyle(
//                                   fontSize: 16.0,
//                                   fontWeight: FontWeight.w300,
//                                   fontFamily: 'Inter',
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             if (message['senderId'] == _auth.currentUser?.uid &&
//                                 isSeen)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 4.0),
//                                 child: SvgPicture.asset(
//                                   'assets/icons/seen.svg',
//                                   width: 20,
//                                   height: 20,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: MediaQuery.of(context).viewInsets.top,
//               ),
//               child: Container(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
//                   child: Container(
//                     padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(32),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 5,
//                           blurRadius: 7,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _messageController,
//                             decoration: const InputDecoration(
//                               hintText: 'Reply here... ',
//                               hintStyle: TextStyle(
//                                 fontFamily: 'Inter',
//                                 fontWeight: FontWeight.w300,
//                               ),
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.arrow_upward_sharp),
//                           onPressed: _sendMessage,
//                           color: mainColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

    String conversationId =
        _getConversationId(currentUser.uid, widget.message['authUid']);

    QuerySnapshot snapshot = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();

    List<Map<String, dynamic>> fetchedMessages = snapshot.docs.map((doc) {
      return {
        'messageId': doc.id,
        'message': doc.get('message') ?? '',
        'timestamp': doc.get('timestamp') ?? Timestamp.now(),
        'senderId': doc.get('senderId') ?? '',
        'seen': doc.get('seen') ?? false,
      };
    }).toList();

    setState(() {
      _userMessages.addAll(fetchedMessages);
    });

    // Mark messages as seen
    for (var message in fetchedMessages) {
      if (message['senderId'] != currentUser.uid && !message['seen']) {
        _markMessageAsSeen(conversationId, message['messageId']);
      }
    }
  }

  void _markMessageAsSeen(String conversationId, String messageId) async {
    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(messageId)
        .update({'seen': true});
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String message = _messageController.text;
      User? currentUser = _auth.currentUser;
      String? recipientUid = widget.message['authUid'];

      if (currentUser == null) {
        debugPrint("No current user logged in");
        return;
      }

      if (recipientUid == null) {
        debugPrint("Recipient UID is null");
        return;
      }

      String conversationId = _getConversationId(currentUser.uid, recipientUid);
      debugPrint("Sending message in conversation ID: $conversationId");

      try {
        DocumentReference conversationDoc =
            _firestore.collection('conversations').doc(conversationId);

        // Add message to the messages subcollection
        await conversationDoc.collection('messages').add({
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
          'senderId': currentUser.uid,
          'seen': false, // Initialize as unseen
        });
        debugPrint("Message added to Firestore");

        // Ensure the participants array is updated in the conversation document
        await conversationDoc.set({
          'participants':
              FieldValue.arrayUnion([currentUser.uid, recipientUid]),
        }, SetOptions(merge: true));
        debugPrint("Participants updated in Firestore");

        setState(() {
          _userMessages.add({
            'message': message,
            'timestamp': Timestamp.now(),
            'senderId': currentUser.uid,
            'seen': false, // Initialize as unseen
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

  String _getConversationId(String user1, String user2) {
    return user1.compareTo(user2) < 0 ? '$user1-$user2' : '$user2-$user1';
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context, true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                    bool isSeen = message['seen'];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment:
                            message['senderId'] == _auth.currentUser?.uid
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          if (message['senderId'] != _auth.currentUser?.uid)
                            ClipOval(
                              child: Image.network(
                                widget.message['profilePicUrl'] ?? '',
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (message['senderId'] != _auth.currentUser?.uid)
                            const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment:
                                message['senderId'] == _auth.currentUser?.uid
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: message['senderId'] ==
                                          _auth.currentUser?.uid
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
                              if (message['senderId'] ==
                                      _auth.currentUser?.uid &&
                                  isSeen)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/seen.svg',
                                    width: 20,
                                    height: 20,
                                    color: Colors.green,
                                  ),
                                ),
                            ],
                          ),
                        ],
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
      ),
    );
  }
}
