import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/tasks_components/_signature_section.dart';
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
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
    _initializeColumnStatus();
  }

  void _initializeFormData() {
    formData = widget.task.csvData
            ?.map((key, value) => MapEntry(key, value?.toString() ?? '')) ??
        {};
  }

  void _initializeColumnStatus() {
    columnStatus = widget.task.getColumnStatus();
  }

  void _navigateToGeotagPage() {
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
          if (isEditing)
            IconButton(
              onPressed: _saveFormData,
              icon: const Icon(Icons.save),
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
              onPressed: _navigateToGeotagPage,
              child: const Text('Go to Geotag'),
            ),
            const SizedBox(height: 20),
            SignatureSection(task: widget.task),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: formData.entries
          .where((entry) =>
              !_shouldExcludeField(entry.key) &&
              (!_hasValue(entry.key) || isEditing))
          .map((entry) {
        final label = entry.key;
        final value = entry.value;
        return _buildFormField(label, value);
      }).toList(),
    );
  }

  bool _shouldExcludeField(String key) {
    // Define fields to exclude from the form
    const excludeFields = {
      'serviceGroup',
      'serviceType',
      'taskStatus',
      'ppirNameInsured',
      'ppirNameIuia',
      'ppirSigInsured',
      'ppirSigIuia'
    };
    return excludeFields.contains(key);
  }

  bool _hasValue(String key) {
    // Check if a field has a value or is marked as completed
    bool hasValueInFormData = formData[key]?.isNotEmpty ?? false;
    bool isCompleted = columnStatus[key] ?? false;
    return hasValueInFormData || isCompleted;
  }

  Widget _buildFormField(String label, String initialValue) {
    bool canEdit = true; // Assume fields displayed can always be edited

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
              enabled: canEdit,
              onChanged: (value) {
                setState(() {
                  formData[label] = value;
                  isEditing = true;
                  hasChanges = true;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveFormData() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Save'),
          content: const Text('Are you sure you want to save changes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _performSave();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _performSave() async {
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
        hasChanges = false;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving form data')),
      );
    });
  }
}
