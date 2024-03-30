import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/chat_page.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView(
        children: [
          _buildMessageItem(
            context,
            'John Doe',
            'Hey, how are you?',
            '10:30 AM',
            Colors.blue,
          ),
          _buildMessageItem(
            context,
            'Jane Smith',
            'Can we meet tomorrow?',
            '9:45 AM',
            Colors.green,
          ),
          _buildMessageItem(
            context,
            'Alex Johnson',
            'Thanks for your help!',
            'Yesterday',
            Colors.orange,
          ),
          _buildMessageItem(
            context,
            'Sarah Brown',
            'I have a question for you.',
            '2 days ago',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(
    BuildContext context,
    String name,
    String message,
    String time,
    Color color,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(name[0]),
      ),
      title: Text(name),
      subtitle: Text(message),
      trailing: Text(time),
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
}
