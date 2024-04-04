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
  Map<String, String> formData = {};

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
            Text(
              'Task ${widget.task.csvData?['serviceGroup'] ?? ''} ${widget.task.ppirInsuranceId}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            _buildFormFields(widget.task.csvData),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _saveFormData,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields(Map<String, dynamic>? csvData) {
    if (csvData == null) {
      return const Text('No data available');
    }

    return Column(
      children: csvData.entries.map((entry) {
        final label = entry.key;
        final value = entry.value != null ? entry.value.toString() : '';

        return _buildFormField(label, value);
      }).toList(),
    );
  }

  Widget _buildFormField(String label, String initialValue) {
    bool hasValue = initialValue.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: initialValue,
              readOnly: hasValue,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: hasValue ? Colors.grey[200] : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveFormData() {
    // Here you can save formData to your desired storage or perform any other action
    print(formData);
  }
}
