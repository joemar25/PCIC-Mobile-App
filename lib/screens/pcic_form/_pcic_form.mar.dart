// file: pcic_form.dart
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pcic_mobile_app/screens/pcic_form/_success.dart';
import 'package:pcic_mobile_app/screens/signature/_signature_section.dart';
import 'package:pcic_mobile_app/utils/seeds/_dropdown.dart';
import 'package:pcic_mobile_app/screens/tasks/_control_task.dart';
import 'package:pcic_mobile_app/screens/geotag/_map_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:archive/archive_io.dart';

import './_form_field.dart' as form_field;
import './_form_section.dart' as form_section;

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

  final _signatureSectionKey = GlobalKey<SignatureSectionState>();

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

  void _createZipFile(BuildContext context) async {
    try {
      final filePath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS,
      );

      final downloadsDirectory = Directory(filePath);

      final serviceType = widget.task.csvData?['serviceType'] ?? 'Service Type';
      final idMapping = {serviceType: widget.task.ppirInsuranceId};

      // Provide a default if no mapping exists
      final mappedId = idMapping[serviceType] ?? '000000';

      final baseFilename =
          '${serviceType.replaceAll(' ', ' - ')}_${serviceType.replaceAll(' ', '_')}_$mappedId';

      final directory = Directory('${downloadsDirectory.path}/$baseFilename');

      // Create the insurance directory if it doesn't exist
      if (!await directory.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No files found to zip')),
        );
        return;
      }

      final zipFilePath = '${downloadsDirectory.path}/$baseFilename.task';
      final zipFile = File(zipFilePath);

      // Delete the existing ZIP file if it already exists
      if (await zipFile.exists()) {
        await zipFile.delete();
      }

      final zipFileStream = zipFile.openWrite();
      final archive = Archive();

      // Recursively add files to the archive
      await addFilesToArchive(directory, directory.path, archive);

      final zipData = ZipEncoder().encode(archive);
      zipFileStream.add(zipData!);
      await zipFileStream.close();
      await directory.delete(recursive: true);

      // Verify the ZIP file
      if (await zipFile.exists()) {
        final zipSize = await zipFile.length();
        debugPrint('ZIP file created successfully. Size: $zipSize bytes');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form data saved as ZIP')),
        );
      } else {
        debugPrint('Failed to create ZIP file');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saving form data as ZIP')),
        );
      }
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving form data as ZIP')),
      );
      debugPrint('Error saving form data as ZIP: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> addFilesToArchive(
      Directory dir, String rootPath, Archive archive) async {
    final files = dir.listSync();
    for (var file in files) {
      if (file is File) {
        final fileContent = await file.readAsBytes();
        final archiveFile = ArchiveFile(
          file.path.replaceAll('$rootPath/', ''),
          fileContent.length,
          fileContent,
        );
        archive.addFile(archiveFile);
      } else if (file is Directory) {
        await addFilesToArchive(file, rootPath, archive);
      }
    }
  }

  void _submitForm(BuildContext context) {
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
              _createZipFile(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _saveFormData() {
    // Get the signature data from the SignatureSection
    final signatureData =
        _signatureSectionKey.currentState?.getSignatureData() ?? {};

    // Update the additional columns
    _formData['trackTotalarea'] = _areaInHectaresController.text;
    _formData['trackDatetime'] = _areaPlantedController.text;
    _formData['trackLastcoord'] = _formData['lastCoordinates'];
    _formData['trackTotaldistance'] = _totalDistanceController.text;

    // Update the remarks and signature fields with default values if null
    _formData['ppirRemarks'] = _formData['ppirRemarks'] ?? 'no value';
    _formData['ppirSigInsured'] = signatureData['ppirSigInsured'] ?? 'no value';
    _formData['ppirNameInsured'] =
        signatureData['ppirNameInsured'] ?? 'no value';
    _formData['ppirSigIuia'] = signatureData['ppirSigIuia'] ?? 'no value';
    _formData['ppirNameIuia'] = signatureData['ppirNameIuia'] ?? 'no value';

    widget.task.updateCsvData(_getChangedData());
    widget.task.isCompleted = true;

    // Save the signature files
    _saveSignatureFiles(signatureData);

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

  void _saveSignatureFiles(Map<String, String> signatureData) async {
    final directory = await getExternalStorageDirectory();
    final serviceType = widget.task.csvData?['serviceType'] ?? 'Service Group';
    final idMapping = {serviceType: widget.task.ppirInsuranceId};
    final mappedId = idMapping[serviceType] ?? '000000';
    final baseFilename =
        '${serviceType.replaceAll(' ', ' - ')}_${serviceType.replaceAll(' ', '_')}_$mappedId';

    // Save the confirmed by signature file
    if (signatureData['ppirSigInsured']!.isNotEmpty) {
      final confirmedBySignatureBytes = await _signatureSectionKey
          .currentState?.confirmedBySignatureController
          .toPngBytes();
      final confirmedByFile = File(
          '${directory!.path}/$baseFilename/${signatureData['ppirSigInsured']}');
      await confirmedByFile.writeAsBytes(confirmedBySignatureBytes!);
      debugPrint('Confirmed by signature saved: ${confirmedByFile.path}');
    }

    // Save the prepared by signature file
    if (signatureData['ppirSigIuia']!.isNotEmpty) {
      final preparedBySignatureBytes = await _signatureSectionKey
          .currentState?.preparedBySignatureController
          .toPngBytes();
      final preparedByFile = File(
          '${directory!.path}/$baseFilename/${signatureData['ppirSigIuia']}');
      await preparedByFile.writeAsBytes(preparedBySignatureBytes!);
      debugPrint('Prepared by signature saved: ${preparedByFile.path}');
    }
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
            // MAR: this is commented because it is not in our scope, this is just for testing
            // const SizedBox(height: 16),
            // gpx_button.GPXFileButton(
            //   openGpxFile: () => _openGpxFile(widget.gpxFile),
            // ),
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
              onPressed: () => _submitForm(context),
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
