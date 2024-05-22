import '_model.dart';
import '_detail.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  MessagesPageState createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
  final List<Map<String, dynamic>> messages = [
    // {
    //   'profilepic': 'assets/image/mar.png',
    //   'name': 'Joemar Cardiño',
    //   'message': 'Hey, how are you?',
    //   'time': DateTime(2023, 6, 5, 10, 30),
    //   'color': Colors.blue,
    // },
    // {
    //   'profilepic': 'assets/image/sean.jpg',
    //   'name': 'Sean Palacay',
    //   'message': 'I have a question for you.',
    //   'time': DateTime(24, 6, 3, 11, 15),
    // },
    // {
    //   'profilepic': 'assets/image/tonnn.jpg',
    //   'name': 'Anton Cabais',
    //   'message': 'Hello?',
    //   'time': DateTime(24, 6, 3, 11, 13),
    // },
  ];

  List<Map<String, dynamic>> filteredMessages = [];

  String _searchQuery = '';
  final bool _sortEarliest = true;

  @override
  void initState() {
    super.initState();
    _filterMessagesAsync();
  }

  Future<void> _filterMessagesAsync() async {
    final filteredList = messages
        .where((message) =>
            message['name']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            message['message']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();

    filteredList.sort((a, b) {
      if (_sortEarliest) {
        return a['time'].compareTo(b['time']);
      } else {
        return b['time'].compareTo(a['time']);
      }
    });

    setState(() {
      filteredMessages = filteredList;
    });
  }

  void _navigateToMessageDetails(Map<String, dynamic> message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailsPage(message: message),
      ),
    );
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
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _filterMessagesAsync();
                  },
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: 'Search Message...',
                    hintStyle: const TextStyle(color: mainColor),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: mainColor, width: 1.0),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: mainColor, width: 1.0),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    suffixIconConstraints:
                        const BoxConstraints(minWidth: 50, minHeight: 50),
                    suffixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(end: 12.0),
                      child: Icon(
                        Icons.search,
                        color: mainColor,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredMessages.length,
                  itemBuilder: (context, index) {
                    final message = filteredMessages[index];
                    return MessageItem(
                      profilepic: message['profilepic'],
                      name: message['name'],
                      message: message['message'],
                      time:
                          DateFormat('M/d/yy hh:mm a').format(message['time']),
                      onTap: () => _navigateToMessageDetails(message),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
