import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final snapshot = await _databaseReference.child('agentsTask').get();
      if (snapshot.exists) {
        final value = snapshot.value;
        if (value != null) {
          if (value is List<Object?>) {
            _data = _processData(value);
          } else {
            print('Unexpected data format');
          }
        } else {
          print('The "agents" node is empty');
        }
        setState(() {});
      } else {
        print('The "agents" node does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  List<Map<String, dynamic>> _processData(List<Object?> data) {
    List<Map<String, dynamic>> result = [];
    for (var item in data) {
      if (item is Map<Object?, Object?>) {
        Map<String, dynamic> agentData = {};
        item.forEach((key, value) {
          agentData[key.toString()] = value;
        });
        result.add(agentData);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
      ),
      body: _data.isNotEmpty
          ? ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final agent = _data[index];
                return ListTile(
                  title: Text('Agent ${index + 1}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Job ID: ${agent['jobID'] ?? ''}'),
                      Text('Task ID: ${agent['taskID'] ?? ''}'),
                      Text('Date Access: ${agent['dateAccess'] ?? ''}'),
                      Text('Date Added: ${agent['dateAdded'] ?? ''}'),
                      Text('Is Complete: ${agent['isComplete'] ?? ''}'),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text('No data available'),
            ),
    );
  }
}