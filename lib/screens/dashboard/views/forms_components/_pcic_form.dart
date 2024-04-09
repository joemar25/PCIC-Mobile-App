import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/forms_components/_success.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/tasks_components/_signature_section.dart';
import 'package:pcic_mobile_app/utils/controls/_control_actual_seeds.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';

import '../../../../utils/controls/_map_service.dart';

class PCICFormPage extends StatefulWidget {
  final String imageFile;
  final String gpxFile;
  final Task task;
  final List<LatLng> routePoints;
  final LatLng initialRoutePoint;

  const PCICFormPage({
    super.key,
    required this.imageFile,
    required this.gpxFile,
    required this.task,
    required this.routePoints,
    required this.initialRoutePoint,
  });

  @override
  _PCICFormPageState createState() => _PCICFormPageState();
}

class _PCICFormPageState extends State<PCICFormPage> {
  List<Seeds> seedsList = Seeds.getAllTasks();
  Set<String> uniqueTitles = {};
  List<DropdownMenuItem<String>> uniqueSeedsItems = [];
  final _formData = <String, dynamic>{};
  double _calculatedArea = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
    _initializeSeeds();
    _calculateArea();
  }

  void _calculateArea() {
    final mapService = MapService();
    setState(() {
      _calculatedArea = mapService.calculateAreaOfPolygon(widget.routePoints);
    });
  }

  void _initializeFormData() {
    _formData['ppirAreaAct'] = widget.task.csvData?['ppirAreaAct'] ?? '';
    _formData['ppirDopdsAct'] = widget.task.csvData?['ppirDopdsAct'] ?? '';
    _formData['ppirDoptpAct'] = widget.task.csvData?['ppirDoptpAct'] ?? '';

    // Check if the ppirVariety value is present in the uniqueTitles set
    String? ppirVarietyValue = widget.task.csvData?['ppirVariety'];
    if (ppirVarietyValue != null && uniqueTitles.contains(ppirVarietyValue)) {
      _formData['ppirVariety'] = ppirVarietyValue;
    } else {
      _formData['ppirVariety'] = null;
    }

    _formData['ppirRemarks'] = widget.task.csvData?['ppirRemarks'] ?? '';
  }

  void _initializeSeeds() {
    final uniqueSeedTitles = <String>{};

    uniqueSeedsItems.add(const DropdownMenuItem<String>(
      value: null,
      child: Text('Select a seed variety'),
    ));

    for (var seed in seedsList) {
      final seedTitle = seed.title;
      if (!uniqueSeedTitles.contains(seedTitle)) {
        uniqueSeedTitles.add(seedTitle);
        uniqueSeedsItems.add(DropdownMenuItem<String>(
          value: seedTitle,
          child: Text(seedTitle),
        ));
      }
    }
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  void _submitForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure the data above is correct?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _saveFormData();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _saveFormData() {
    // Update the task's CSV data with the changed form data
    widget.task.updateCsvData(_getChangedData());

    // Mark the task as completed
    widget.task.isCompleted = true;

    // Save the updated CSV data back to the file
    widget.task.saveCsvData().then((_) {
      // Update the task data in Firebase
      _updateTaskInFirebase();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FormSuccessPage(
            isSaveSuccessful: true,
          ),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving form data')),
      );
    });
  }

  Map<String, dynamic> _getChangedData() {
    Map<String, dynamic> changedData = {};

    _formData.forEach((key, value) {
      if (value != widget.task.csvData?[key]) {
        changedData[key] = value;
      }
    });

    return changedData;
  }

  void _updateTaskInFirebase() {
    final databaseReference = FirebaseDatabase.instance.ref();
    final taskId = 'task-${widget.task.ppirInsuranceId}';
    final taskPath = 'tasks/$taskId';

    debugPrint(taskId);

    databaseReference.child(taskPath).update({'isCompleted': true}).then((_) {
      debugPrint('Task updated successfully');
    }).catchError((error) {
      debugPrint('Error updating task: $error');
    });
  }

  void _cancelForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to cancel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _downloadGpxFile(String gpxFilePath) async {
    try {
      final directory = await getExternalStorageDirectory();
      final fileName = 'route_${DateTime.now().millisecondsSinceEpoch}.gpx';
      final file = File('${directory!.path}/$fileName');

      await file.writeAsString(gpxFilePath);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GPX file downloaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error downloading GPX file')),
      );
      print('Error downloading GPX file: $e');
    }
  }

  void _openGpxFile(String gpxFilePath) async {
    try {
      final externalStorageDirectory = await getExternalStorageDirectory();
      final gpxFile = File('${externalStorageDirectory!.path}/route.gpx');

      if (await gpxFile.exists()) {
        OpenFile.open(gpxFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GPX file not found')),
        );
        print('GPX file not found: ${gpxFile.path}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error opening GPX file')),
      );
      print('Error opening GPX file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PCIC Form'),
          leading: Container(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FormSection(
                    formData: _formData, uniqueSeedsItems: uniqueSeedsItems),
                const SizedBox(height: 20),
                const Text(
                  'Signatures:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SignatureSection(task: widget.task),
                const SizedBox(height: 20),
                const Text(
                  'Map Screenshot',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Image.file(
                  File(widget.imageFile),
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(
                  'Total Area Result: ${_calculateResult()}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Initial Route Point: ${widget.initialRoutePoint.latitude}, ${widget.initialRoutePoint.longitude}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'GPX File',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _GPXFileButtons(
                  openGpxFile: () => _openGpxFile(widget.gpxFile),
                ),
                const SizedBox(height: 20),
                _FormButtons(
                  cancelForm: _cancelForm,
                  submitForm: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateResult() {
    return _calculatedArea;
  }
}

// Buttons
class _FormButtons extends StatelessWidget {
  final VoidCallback cancelForm;
  final VoidCallback submitForm;

  const _FormButtons({
    required this.cancelForm,
    required this.submitForm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: cancelForm,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: submitForm,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

// GPX File Buttons
class _GPXFileButtons extends StatelessWidget {
  final VoidCallback openGpxFile;

  const _GPXFileButtons({
    required this.openGpxFile,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: openGpxFile,
        child: const Text('Open GPX File'),
      ),
    );
  }
}

// Form Section

class _FormField extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final Function(String) onChanged;
  final int maxLines;

  const _FormField({
    required this.labelText,
    required this.initialValue,
    required this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final Map<String, dynamic> formData;
  final List<DropdownMenuItem<String>> uniqueSeedsItems;

  const _FormSection({
    required this.formData,
    required this.uniqueSeedsItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FormField(
          labelText: 'Area Planted*',
          initialValue: formData['ppirAreaAct'],
          onChanged: (value) => formData['ppirAreaAct'] = value,
        ),
        const SizedBox(height: 16),
        _FormField(
          labelText: 'Date of Planting (DS)*',
          initialValue: formData['ppirDopdsAct'],
          onChanged: (value) => formData['ppirDopdsAct'] = value,
        ),
        const SizedBox(height: 16),
        _FormField(
          labelText: 'Date of Planting (TP)*',
          initialValue: formData['ppirDoptpAct'],
          onChanged: (value) => formData['ppirDoptpAct'] = value,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: formData['ppirVariety'],
          decoration: const InputDecoration(
            labelText: 'Seed Variety Planted*',
          ),
          items: uniqueSeedsItems,
          onChanged: (value) {
            if (value != null) {
              formData['ppirVariety'] = value;
            } else {
              formData['ppirVariety'] = null;
            }
          },
        ),
        const SizedBox(height: 16),
        _FormField(
          labelText: 'Remarks',
          initialValue: formData['ppirRemarks'],
          onChanged: (value) => formData['ppirRemarks'] = value,
          maxLines: 3,
        ),
      ],
    );
  }
}
