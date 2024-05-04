import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageDetailsPage extends StatefulWidget {
  final Map<String, dynamic> message;

  const MessageDetailsPage({super.key, required this.message});

  @override
  MessageDetailsPageState createState() => MessageDetailsPageState();
}

class MessageDetailsPageState extends State<MessageDetailsPage> {
  late Map<String, dynamic> _message;

  @override
  void initState() {
    super.initState();
    _message = widget.message;
  }

  Future<void> _refreshMessage() async {
    // Simulate fetching updated message data from a server
    await Future.delayed(const Duration(seconds: 1)); // Simulating a delay
    // setState to update the UI with new data
    setState(() {
      // Update the message data
      // For demonstration, let's just update the message time
      _message['time'] = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Details'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshMessage,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _message['color'] ?? Colors.grey,
                      child: Text(
                        _message['name'][0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _message['name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            DateFormat('MMM d, yyyy hh:mm a')
                                .format(_message['time']),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Message:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    _message['message'] ?? 'No message content available.',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // Implement sending message logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
