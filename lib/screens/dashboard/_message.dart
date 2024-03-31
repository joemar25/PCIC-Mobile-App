import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pcic_mobile_app/screens/dashboard/controllers/_filter_message.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_chat.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_message_items.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
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
      'name': 'Mr Johny Makasalanan',
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
    _loadFilters();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postFrameCallback();
    });
  }

  void _postFrameCallback() {
    _filterMessagesAsync();
    // Add any other state-related logic here
  }

  void _loadFilters() {
    final filters =
        Provider.of<MessageFiltersNotifier>(context, listen: false).filters;
    setState(() {
      _searchQuery = filters.searchQuery;
      _sortEarliest = filters.sortEarliest;
    });
  }

  Future<void> _filterMessagesAsync() async {
    final filteredList = await Future.value(messages
        .where((message) =>
            message['name']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            message['message']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList());

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

    Provider.of<MessageFiltersNotifier>(context, listen: false).updateFilters(
      MessageFilters(
        searchQuery: _searchQuery,
        sortEarliest: _sortEarliest,
      ),
    );
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
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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
                    return MessageItem(
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
          );
        },
      ),
    );
  }
}
