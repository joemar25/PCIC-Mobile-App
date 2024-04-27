// file: pcic_form.dart
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_file/open_file.dart';
import 'package:pcic_mobile_app/screens/pcic_form/_success.dart';
import 'package:pcic_mobile_app/screens/signature/_signature_section.dart';
import 'package:pcic_mobile_app/utils/seeds/_dropdown.dart';
import 'package:pcic_mobile_app/screens/tasks/_control_task.dart';
import 'package:pcic_mobile_app/screens/geotag/_map_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:archive/archive_io.dart';

import './_form_field.dart' as form_field;
import './_form_section.dart' as form_section;
import '_gpx_file_button.dart' as gpx_button;

class PCICFormPage extends StatefulWidget {
  final String imageFile;
  final String gpxFile;
  final TaskManager task;
  final List<LatLng> routePoints;
  final LatLng lastCoordinates;

  const PCICFormPage({
    super.key,
    required this.imageFile,
    required this.gpxFile,
    required this.task,
    required this.routePoints,
    required this.lastCoordinates,
  });

  @override
  PCICFormPageState createState() => PCICFormPageState();
}

class PCICFormPageState extends State<PCICFormPage> {
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
    _requestExternalStoragePermission();
  }

  Future<void> _requestExternalStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      // Permission granted, you can now access external storage
      debugPrint('MANAGE_EXTERNAL_STORAGE permission granted');
    } else {
      // Permission denied, handle accordingly (e.g., show an error message)
      debugPrint('MANAGE_EXTERNAL_STORAGE permission denied');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('External storage permission is required to open GPX files'),
        ),
      );
    }
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

    String lastCoordinateDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    _areaPlantedController.text = lastCoordinateDateTime;

    _formData['lastCoordinates'] =
        '${widget.lastCoordinates.latitude}, ${widget.lastCoordinates.longitude}';
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
      // _areaPlantedController.text = area > 0 ? _formatNumber(area, 'm²') : '';
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

  void _saveAsXml() {
    try {
      final gpxFilePath = widget.gpxFile;
      final gpxFile = File(gpxFilePath);
      final directory = gpxFile.parent;
      final xmlData = _convertToXml();

      final xmlFile = File('${directory.path}/form_data.xml');

      xmlFile.writeAsStringSync(xmlData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form data saved as XML')),
      );
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving form data as XML')),
      );
      debugPrint('Error saving form data as XML: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  String _convertToXml() {
    final StringBuffer xmlBuffer = StringBuffer();
    xmlBuffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    xmlBuffer.writeln(
        '<TaskArchiveZipModel xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">');
    xmlBuffer.writeln('<AgentId xsi:nil="true"/>');
    xmlBuffer.writeln(
        '<AssignedDate>${DateTime.now().toIso8601String()}</AssignedDate>');
    xmlBuffer.writeln('<Attachments/>');
    xmlBuffer.writeln('<AuditLogs>');

    // Add your TaskAuditLogZipModel here
    xmlBuffer.writeln('<TaskAuditLogZipModel>');

    // Add form data inside TaskAuditLogZipModel
    _formData.forEach((key, value) {
      xmlBuffer.writeln('<$key>$value</$key>');
    });

    xmlBuffer.writeln('</TaskAuditLogZipModel>');

    xmlBuffer.writeln('</AuditLogs>');
    xmlBuffer.writeln('</TaskArchiveZipModel>');
    return xmlBuffer.toString();
  }

void _createZipFile() async {
  try {
    final gpxFilePath = widget.gpxFile;
    final gpxFile = File(gpxFilePath);
    final directory = gpxFile.parent;

    final encoder = ZipFileEncoder();
    final zipFilePath = '${directory.path}.zip';
    encoder.create(zipFilePath);

    // Add all files in the directory to the ZIP
    final files = await directory.list().toList();
    for (var file in files) {
      if (file is File) {
        encoder.addFile(file);
      }
    }

    encoder.close();

    // Delete the original directory
    await directory.delete(recursive: true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form data saved as ZIP')),
    );
  } catch (e, stackTrace) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error saving form data as ZIP')),
    );
    debugPrint('Error saving form data as ZIP: $e');
    debugPrint('Stack trace: $stackTrace');
  }
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
              _saveAsXml(); // Call the method to save as XML
              _createZipFile();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _saveFormData() {
    // Update the additional columns
    _formData['trackTotalarea'] = _areaInHectaresController.text;
    _formData['trackDatetime'] = _areaPlantedController.text;
    _formData['trackLastcoord'] = _formData['lastCoordinates'];
    _formData['trackTotaldistance'] = _totalDistanceController.text;

    // Update the remarks and signature fields with default values if null
    _formData['ppirRemarks'] = _formData['ppirRemarks'] ?? 'no value';
    _formData['ppirSigInsured'] = _formData['ppirSigInsured'] ?? 'no value';
    _formData['ppirNameInsured'] = _formData['ppirNameInsured'] ?? 'no value';
    _formData['ppirSigIuia'] = _formData['ppirSigIuia'] ?? 'no value';
    _formData['ppirNameIuia'] = _formData['ppirNameIuia'] ?? 'no value';

    widget.task.updateCsvData(_getChangedData());
    widget.task.isCompleted = true;

    widget.task
        .saveXmlData(
            widget.task.csvData?['serviceType'], widget.task.ppirInsuranceId)
        .then((_) {
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
      debugPrint('TaskManager updated successfully');
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

  void _openGpxFile(String gpxFilePath) async {
    try {
      final filePath = gpxFilePath;
      final downloadsDirectory = Directory(filePath);
      final gpxFile = File(downloadsDirectory.path);
      debugPrint("path = $gpxFile");

      if (await gpxFile.exists()) {
        final status = await Permission.manageExternalStorage.status;
        if (status.isGranted) {
          final result = await OpenFile.open(gpxFile.path);
          if (result.type == ResultType.done) {
            // File opened successfully
            debugPrint('GPX file opened successfully');
          } else {
            // Error opening the file
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error opening GPX file')),
            );
            debugPrint('Error opening GPX file: ${result.message}');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'External storage permission is required to open GPX files'),
            ),
          );
          debugPrint('MANAGE_EXTERNAL_STORAGE permission denied');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GPX file not found')),
        );
        debugPrint('GPX file not found: ${gpxFile.path}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error opening GPX file')),
      );
      debugPrint('Error opening GPX file: $e');
    }
  }

  void _viewScreenshot(String screenshotPath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Screenshot'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Image.file(
                  File(screenshotPath),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              const Text('This is the screenshot captured during the task.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PCIC Form'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _cancelForm(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            form_field.FormField(
              labelText: 'Last Coordinates',
              initialValue: _formData['lastCoordinates'],
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _areaPlantedController,
              decoration: const InputDecoration(
                labelText: 'Date and Time',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _areaInHectaresController,
              decoration: const InputDecoration(
                labelText: 'Actual Total Area Planted (Hectares)',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _totalDistanceController,
              decoration: const InputDecoration(
                labelText: 'Total Distance',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 24),
            form_section.FormSection(
              formData: _formData,
              uniqueSeedsItems: uniqueSeedsItems,
            ),
            const SizedBox(height: 24),
            const Text(
              'Signatures',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SignatureSection(task: widget.task),
            const SizedBox(height: 24),
            const Text(
              'Map Screenshot',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _viewScreenshot(widget.imageFile),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('View Screenshot'),
            ),
            const SizedBox(height: 24),
            const Text(
              'GPX File',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            gpx_button.GPXFileButton(
              openGpxFile: () => _openGpxFile(widget.gpxFile),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _cancelForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
