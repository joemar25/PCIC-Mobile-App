import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_geotag.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  void _navigateToGeotagPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GeotagPage(task: widget.task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'ASSIGNMENT ID ${widget.task.id}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => _navigateToGeotagPage(context),
                  child: const Text('Go to Job Page'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildFormField(
                'Service Group', widget.task.csvData?['serviceGroup']),
            _buildFormField(
                'Service Type', widget.task.csvData?['serviceType']),
            _buildFormField('Priority', widget.task.csvData?['priority']),
            _buildFormField('Task Status', widget.task.csvData?['taskStatus']),
            _buildFormField('Assignee', widget.task.csvData?['assignee']),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                color: value != null ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
