import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<Map<String, dynamic>> _data = [
    {'taskID': '1231123', 'jobID': '123 Main St', 'isComplete': 'june 1, 2022', 'dateAdded': 'june 1, 2022', 'dateAccess': 'june 1, 2022'},
    {'taskID': '213123w', 'jobID': '123 Main St', 'isComplete': 'june 1, 2022', 'dateAdded': 'june 1, 2022', 'dateAccess': 'june 1, 2022'},
    {'taskID': '11d1', 'jobID': '123 Main St', 'isComplete': 'june 1, 2022', 'dateAdded': 'june 1, 2022', 'dateAccess': 'june 1, 2022'},
  ];

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