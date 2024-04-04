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
  Map<String, bool> columnStatus = {};
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
    _initializeColumnStatus();
  }

  void _initializeFormData() {
    formData = widget.task.csvData?.map((key, value) =>
            MapEntry(key, value != null ? value.toString() : '')) ??
        {};
  }

  void _initializeColumnStatus() {
    columnStatus = widget.task.getColumnStatus();
  }

  void _updateColumnStatus(String label, String value) {
    setState(() {
      columnStatus[label] = value.isNotEmpty;
    });
  }

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
        actions: [
          IconButton(
            onPressed: isEditing ? _saveFormData : _startEditing,
            icon: Icon(isEditing ? Icons.save : Icons.edit),
          ),
        ],
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
            _buildFormFields(),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _saveFormData,
              child: const Text('Save'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _navigateToGeotagPage(context),
              child: const Text('Go to Geotag'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: formData.entries.map((entry) {
        final label = entry.key;
        final value = entry.value;
        return _buildFormField(label, value);
      }).toList(),
    );
  }

  Widget _buildFormField(String label, String initialValue) {
    bool hasValue = columnStatus[label] ?? false;
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
              enabled: isEditing && !hasValue,
              onChanged: (value) {
                setState(() {
                  formData[label] = value;
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                filled: true,
                fillColor:
                    isEditing && !hasValue ? Colors.white : Colors.grey[200],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveFormData() {
    // Update the task's CSV data with the form data
    widget.task.updateCsvData(formData);

    // Update the task's column status based on the form data
    Map<String, bool> updatedColumnStatus = {};
    formData.forEach((key, value) {
      updatedColumnStatus[key] = value.isNotEmpty;
    });
    widget.task.updateColumnStatus(updatedColumnStatus);

    // Save the updated CSV data back to the file
    widget.task.saveCsvData().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form data saved successfully')),
      );
      setState(() {
        isEditing = false;
        columnStatus = widget.task.getColumnStatus();
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving form data')),
      );
    });
  }

  void _startEditing() {
    setState(() {
      isEditing = true;
    });
  }
}
