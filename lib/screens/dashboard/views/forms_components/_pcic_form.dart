// pcic_form.dart
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/forms_components/_success.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/tasks_components/_signature_section.dart';
import 'package:pcic_mobile_app/utils/controls/_control_actual_seeds.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';
import 'package:pcic_mobile_app/utils/controls/_map_service.dart';

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
  final _areaPlantedController = TextEditingController();
  final _areaInHectaresController = TextEditingController();
  final _totalDistanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFormData();
    _initializeSeeds();
    _calculateAreaAndDistance();
  }

  void _initializeFormData() {
    _formData['ppirDopdsAct'] = widget.task.csvData?['ppirDopdsAct'] ?? '';
    _formData['ppirDoptpAct'] = widget.task.csvData?['ppirDoptpAct'] ?? '';

    String? ppirVarietyValue = widget.task.csvData?['ppirVariety'] ?? '';
    if (ppirVarietyValue!.isNotEmpty &&
        uniqueTitles.contains(ppirVarietyValue)) {
      _formData['ppirVariety'] = ppirVarietyValue;
    } else {
      _formData['ppirVariety'] = null;
    }

    _formData['ppirRemarks'] = widget.task.csvData?['ppirRemarks'] ?? '';
    _formData['initialRoutePoint'] =
        '${widget.initialRoutePoint.latitude}, ${widget.initialRoutePoint.longitude}';
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

  void _calculateAreaAndDistance() {
    final mapService = MapService();
    final distance = mapService.calculateTotalDistance(widget.routePoints);

    double area = 0.0;
    double areaInHectares = 0.0;

    if (widget.routePoints.isNotEmpty) {
      final initialPoint = widget.routePoints.first;
      final closingPoint = widget.routePoints.last;

      if (_isCloseEnough(initialPoint, closingPoint)) {
        area = mapService.calculateAreaOfPolygon(widget.routePoints);
        areaInHectares = area / 10000;
      }
    }

    setState(() {
      _areaPlantedController.text = area > 0 ? _formatNumber(area, 'm²') : '';
      _areaInHectaresController.text =
          areaInHectares > 0 ? _formatNumber(areaInHectares, 'ha') : '';
      _totalDistanceController.text = _formatNumber(distance, 'm');
    });
  }

  bool _isCloseEnough(LatLng point1, LatLng point2) {
    const double threshold = 10.0; // Adjust the threshold as needed
    final distance = const Distance().as(LengthUnit.Meter, point1, point2);
    return distance <= threshold;
  }

  String _formatNumber(double value, String unit) {
    final formatter = NumberFormat('#,##0.00', 'en_US');

    switch (unit) {
      case 'm²':
        return '${formatter.format(value)} m²';
      case 'ha':
        return '${formatter.format(value)} ha';
      case 'm':
        return '${formatter.format(value)} m';
      default:
        return formatter.format(value);
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
    widget.task.updateCsvData(_getChangedData());
    widget.task.isCompleted = true;

    widget.task.saveCsvData().then((_) {
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
                _FormField(
                  labelText: 'Initial Route Point',
                  initialValue: _formData['initialRoutePoint'],
                  enabled: false,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _areaPlantedController,
                  decoration: const InputDecoration(
                    labelText: 'Area Planted',
                    border: OutlineInputBorder(),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _areaInHectaresController,
                  decoration: const InputDecoration(
                    labelText: 'Area (Hectares)',
                    border: OutlineInputBorder(),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _totalDistanceController,
                  decoration: const InputDecoration(
                    labelText: 'Total Distance',
                    border: OutlineInputBorder(),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 20),
                _FormSection(
                  formData: _formData,
                  uniqueSeedsItems: uniqueSeedsItems,
                ),
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
                const SizedBox(height: 20),
                Image.file(
                  File(widget.imageFile),
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                const Text(
                  'GPX File',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
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
}

// Form Buttons
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
  final bool enabled;
  final int maxLines;

  const _FormField({
    required this.labelText,
    required this.initialValue,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      enabled: enabled,
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
        const SizedBox(height: 16),
        _FormField(
          labelText: 'Date of Planting (DS)*',
          initialValue: formData['ppirDopdsAct'],
        ),
        const SizedBox(height: 16),
        _FormField(
          labelText: 'Date of Planting (TP)*',
          initialValue: formData['ppirDoptpAct'],
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
          maxLines: 3,
        ),
      ],
    );
  }
}
