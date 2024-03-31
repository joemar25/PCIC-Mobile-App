import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_chat.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_message.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final List<Map<String, String>> messages = [
    {
      'name': 'John Doe',
      'message': 'Hey, how are you?',
      'time': '10:30 AM',
      'color': 'blue',
    },
    {
      'name': 'Jane Smith',
      'message': 'Can we meet tomorrow?',
      'time': '9:45 AM',
      'color': 'green',
    },
    {
      'name': 'Alex Johnson',
      'message': 'Thanks for your help!',
      'time': 'Yesterday',
      'color': 'orange',
    },
    {
      'name': 'Sarah Brown',
      'message': 'I have a question for you.',
      'time': '2 days ago',
      'color': 'purple',
    },
  ];

  List<Map<String, String>> filteredMessages = [];

  @override
  void initState() {
    super.initState();
    filteredMessages = messages;
  }

  void _filterMessages(String query) {
    setState(() {
      filteredMessages = messages
          .where((message) =>
              message['name']!.toLowerCase().contains(query.toLowerCase()) ||
              message['message']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Color _getColorFromString(String colorString) {
    switch (colorString) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildMessageItem(
    BuildContext context,
    String name,
    String message,
    String time,
    Color color,
  ) {
    return MessageItem(
      name: name,
      message: message,
      time: time,
      color: color,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(name: name),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search messages...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              onChanged: _filterMessages,
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.separated(
              itemCount: filteredMessages.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final message = filteredMessages[index];
                return _buildMessageItem(
                  context,
                  message['name']!,
                  message['message']!,
                  message['time']!,
                  _getColorFromString(message['color']!),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to compose message screen
        },
      ),
    );
  }
}
