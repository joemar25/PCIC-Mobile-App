import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class MessageDetailsPage extends StatefulWidget {
  final Map<String, dynamic> message;
  const MessageDetailsPage({super.key, required this.message});

  @override
  _MessageDetailsPageState createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _userMessages = [];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _userMessages.add(_messageController.text);
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // header (appbar)
      appBar: AppBar(
        elevation: 0,
        iconTheme:
            IconThemeData(color: const Color(0xFF89C53F).withOpacity(0.8)),
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
                        color: Color(0xFF89C53F),
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

      // body (scrollable)
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          widget.message['profilepic'],
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF89C53F).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(32.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(4, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.message['message'],
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
                  const SizedBox(height: 16),
                  ..._userMessages.map(
                    (message) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(97, 97, 97, 1)
                                .withOpacity(0.85),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(4, 5),
                              ),
                            ],
                          ),
                          child: Text(
                            message,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Inter',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 80), // Add space for the footer
          ],
        ),
      ),

      // footer (text field)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
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
                offset: Offset(0, 3),
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
                color: const Color(0xFF89C53F).withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
