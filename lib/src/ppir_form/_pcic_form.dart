import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '_success.dart';
import '_gpx_file_buttons.dart';
import '../tasks/_control_task.dart';
import '../geotag/_map_service.dart';
import '_form_field.dart' as form_field;
import '../../utils/seeds/_dropdown.dart';
import '_form_section.dart' as form_section;
import '../signature/_signature_section.dart';
import '../../utils/app/_show_flash_message.dart';

class PPIRFormPage extends StatefulWidget {
  final String gpxFile;
  final TaskManager task;
  final List<LatLng> routePoints;
  final LatLng lastCoordinates;

  const PPIRFormPage({
    super.key,
    required this.gpxFile,
    required this.task,
    required this.routePoints,
    required this.lastCoordinates,
  });

  @override
  PPIRFormPageState createState() => PPIRFormPageState();
}

class PPIRFormPageState extends State<PPIRFormPage> {
  List<Seeds> seedsList = Seeds.getAllTasks();
  Set<String> uniqueTitles = {};
  List<DropdownMenuItem<String>> uniqueSeedsItems = [];

  final _formData = <String, dynamic>{};
  final _areaPlantedController = TextEditingController();
  final _areaInHectaresController = TextEditingController();
  final _totalDistanceController = TextEditingController();
  final _signatureSectionKey = GlobalKey<SignatureSectionState>();

  bool isSaving = false;
  bool openOnline = true;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
    _initializeSeeds();
    _calculateAreaAndDistance();
  }

  void _initializeFormData() {
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
    final formatter = NumberFormat('#,##0.############', 'en_US');

    switch (unit) {
      case 'ha':
        return '${formatter.format(value)} ha';
      case 'm':
        return '${formatter.format(value)} m';
      default:
        return formatter.format(value);
    }
  }

  void _submitForm(BuildContext context) async {
    final enabledFieldKeys = _formData.keys.where((key) {
      return key != 'lastCoordinates' &&
          key != 'trackTotalarea' &&
          key != 'trackDatetime' &&
          key != 'trackLastcoord' &&
          key != 'trackTotaldistance' &&
          key != 'ppirRemarks';
    }).toList();

    bool hasEmptyEnabledFields = enabledFieldKeys.any((key) =>
        _formData[key] == null || _formData[key].toString().trim().isEmpty);

    final signatureData =
        await _signatureSectionKey.currentState?.getSignatureData() ?? {};

    bool hasEmptySignatureFields = signatureData['ppirSigInsured'] == null ||
        signatureData['ppirNameInsured']?.trim().isEmpty == true ||
        signatureData['ppirSigIuia'] == null ||
        signatureData['ppirNameIuia']?.trim().isEmpty == true;

    if (hasEmptyEnabledFields || hasEmptySignatureFields) {
      if (context.mounted) {
        showFlashMessage(context, 'Info', 'Form Fields',
            'Please fill in all required fields');

        return;
      }
    }

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure the data above is correct?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  isSaving = true;
                });
                _saveFormData();
                setState(() {
                  isSaving = false;
                });
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
  }

  void _saveFormData() async {
    final signatureData =
        await _signatureSectionKey.currentState?.getSignatureData() ?? {};

    _formData['trackTotalarea'] = _areaInHectaresController.text;
    _formData['trackDatetime'] = _areaPlantedController.text;
    _formData['trackLastcoord'] = _formData['lastCoordinates'];
    _formData['trackTotaldistance'] = _totalDistanceController.text;

    _formData['ppirRemarks'] = _formData['ppirRemarks'] ?? 'no value';
    _formData['ppirSigInsured'] = signatureData['ppirSigInsured'] ?? 'no value';
    _formData['ppirNameInsured'] =
        signatureData['ppirNameInsured'] ?? 'no value';
    _formData['ppirSigIuia'] = signatureData['ppirSigIuia'] ?? 'no value';
    _formData['ppirNameIuia'] = signatureData['ppirNameIuia'] ?? 'no value';
    _formData['ppirNameIuia'] = signatureData['ppirNameIuia'] ?? 'no value';
    _formData['status'] = 'Completed';

    // Prepare task data to update the status to 'Completed'
    Map<String, dynamic> taskData = {'status': 'Completed'};

    await widget.task.updatePpirFormData(_formData, taskData);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FormSuccessPage(
            isSaveSuccessful: true,
          ),
        ),
      );
    }
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
    if (openOnline) {
      try {
        // If the file path is a URL, download the file first
        final response = await http.get(Uri.parse(gpxFilePath));
        if (response.statusCode == 200) {
          final directory = await getTemporaryDirectory();
          final file = File('${directory.path}/downloaded.gpx');
          await file.writeAsBytes(response.bodyBytes);
          _openLocalFile(file.path);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error downloading GPX file')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error downloading GPX file')),
          );
        }
        debugPrint('Error downloading GPX file: $e');
      }
    } else {
      _openLocalFile(gpxFilePath);
    }
  }

  void _openLocalFile(String filePath) async {
    try {
      final gpxFile = File(filePath);

      if (await gpxFile.exists()) {
        final status = await Permission.manageExternalStorage.status;
        if (status.isGranted) {
          final result = await OpenFile.open(gpxFile.path);
          if (result.type == ResultType.done) {
            // File opened successfully
            debugPrint('GPX file opened successfully');
          } else {
            // Error opening the file
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error opening GPX file')),
              );
            }
            debugPrint('Error opening GPX file: ${result.message}');
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'External storage permission is required to open GPX files'),
              ),
            );
          }
          debugPrint('MANAGE_EXTERNAL_STORAGE permission denied');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('GPX file not found')),
          );
        }
        debugPrint('GPX file not found: ${gpxFile.path}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error opening GPX file')),
        );
      }
      debugPrint('Error opening GPX file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                    labelText: 'Total Area (Hectares)',
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
                SignatureSection(
                  key: _signatureSectionKey,
                  task: widget.task,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Map Geotag',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GPXFileButtons(
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
                  onPressed: () => _submitForm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
        if (isSaving)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
