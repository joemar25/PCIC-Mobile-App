import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('tasks');
  List<Map<dynamic, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _databaseReference.onValue.listen((event) {
      final data = Map<dynamic, dynamic>.from(event.snapshot.value as dynamic);
      final List<Map<dynamic, dynamic>> tasks = [];

      data.forEach((key, value) {
        tasks.add(Map<dynamic, dynamic>.from(value));
      });

      setState(() {
        _data = tasks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('taskID')),
            DataColumn(label: Text('jobID')),
            DataColumn(label: Text('isComplete')),
            DataColumn(label: Text('dateAdded')),
            DataColumn(label: Text('dateAccess')),
          ],
          rows: _data.map((entry) {
            return DataRow(
              cells: [
                DataCell(Text(entry['taskID'].toString())),
                DataCell(Text(entry['jobID'].toString())),
                DataCell(Text(entry['isComplete'].toString())),
                DataCell(Text(entry['dateAdded'].toString())),
                DataCell(Text(entry['dateAccess'].toString())),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}