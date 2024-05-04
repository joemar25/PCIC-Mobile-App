import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '_detail.dart';
import 'model.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  MessagesPageState createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
  final List<Map<String, dynamic>> messages = [
    {
      'name': 'Joemar Cardiño',
      'message': 'Hey, how are you?',
      'time': DateTime(2023, 6, 5, 10, 30),
      'color': Colors.blue,
    },
    {
      'name': 'Sean Palacay',
      'message': 'Can we meet tomorrow?',
      'time': DateTime(2023, 6, 5, 9, 45),
      'color': Colors.green,
    },
    {
      'name': 'JC Bea',
      'message': 'Thanks for your help!',
      'time': DateTime(2023, 6, 4, 14, 0),
      'color': Colors.orange,
    },
    {
      'name': 'Mr John Doe',
      'message': 'I have a question for you.',
      'time': DateTime(2023, 6, 3, 11, 15),
      'color': Colors.purple,
    },
  ];

  List<Map<String, dynamic>> filteredMessages = [];

  String _searchQuery = '';
  bool _sortEarliest = true;

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
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate refreshing messages from server
          await Future.delayed(const Duration(seconds: 1));
          _filterMessagesAsync();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      'Messages',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // Implement filter functionality
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  _filterMessagesAsync();
                },
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sort by:'),
                  DropdownButton<bool>(
                    value: _sortEarliest,
                    onChanged: (value) {
                      setState(() {
                        _sortEarliest = value!;
                      });
                      _filterMessagesAsync();
                    },
                    items: const [
                      DropdownMenuItem(value: true, child: Text('Earliest')),
                      DropdownMenuItem(value: false, child: Text('Latest')),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredMessages.length,
                itemBuilder: (context, index) {
                  final message = filteredMessages[index];
                  return MessageModel(
                    name: message['name'],
                    message: message['message'],
                    time: DateFormat('MMM d, yyyy hh:mm a')
                        .format(message['time']),
                    color: message['color'],
                    onTap: () => _navigateToMessageDetails(message),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
