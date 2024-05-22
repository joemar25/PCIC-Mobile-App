import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../geotag/_geotag.dart';
import '_form_section.dart';
import '_success.dart';
import '_gpx_file_buttons.dart';
import '../tasks/_control_task.dart';
import '../geotag/_map_service.dart';
import '_form_field.dart' as form_field;
import '../../utils/seeds/_dropdown.dart';
import '../signature/_signature_section.dart';
import '../../utils/app/_show_flash_message.dart';

class PPIRFormPage extends StatefulWidget {
  final TaskManager task;

  const PPIRFormPage({
    super.key,
    required this.task,
  });

  @override
  PPIRFormPageState createState() => PPIRFormPageState();
}

class PPIRFormPageState extends State<PPIRFormPage> {
  List<Seeds> seedsList = Seeds.getAllSeeds();
  Map<String, int> seedTitleToIdMap = {};
  List<DropdownMenuItem<int>> uniqueSeedsItems = [];
  final _formData = <String, dynamic>{};
  final _areaPlantedController = TextEditingController();
  final _areaInHectaresController = TextEditingController();
  final _totalDistanceController = TextEditingController();
  final _signatureSectionKey = GlobalKey<SignatureSectionState>();

  bool isSaving = false;
  bool isLoading = true;
  bool openOnline = true;
  bool geotagSuccess = true;
  String? gpxFile;
  List<LatLng>? routePoints;
  LatLng? lastCoordinates;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final formData = await widget.task.getFormData(widget.task.type);
      if (formData.isNotEmpty) {
        _initializeFormData(formData);
      }

      // debugPrint("Form Data: ${_formData['trackLastcoord']}");

      final mapService = MapService();
      gpxFile = await widget.task.getGpxFilePath();
      if (gpxFile != null) {
        final gpxData = await mapService.readGpxFile(gpxFile!);
        routePoints = await mapService.parseGpxData(gpxData);
        await _calculateAreaAndDistance();
      }

      _initializeSeeds();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error initializing data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _initializeFormData(Map<String, dynamic> formData) {
    _areaPlantedController.text = formData['trackDatetime'] is Timestamp
        ? (formData['trackDatetime'] as Timestamp).toDate().toString()
        : formData['trackDatetime'] ??
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    _areaInHectaresController.text = formData['trackTotalarea'] ?? '';
    _totalDistanceController.text = formData['trackTotaldistance'] ?? '';

    _formData['trackLastcoord'] =
        formData['trackLastcoord'] ?? 'No coordinates available';
    _formData['ppirDopdsAct'] = formData['ppirDopdsAct'] ?? '';
    _formData['ppirDoptpAct'] = formData['ppirDoptpAct'] ?? '';
    _formData['ppirSvpAct'] = formData['ppirSvpAct'] ?? '';
    _formData['ppirAreaAct'] = formData['ppirAreaAct'] ?? '';
    _formData['ppirRemarks'] = formData['ppirRemarks'] ?? '';
    _formData['ppirNameInsured'] = formData['ppirNameInsured'] ?? '';
    _formData['ppirNameIuia'] = formData['ppirNameIuia'] ?? '';
  }

  void _initializeSeeds() {
    uniqueSeedsItems.add(const DropdownMenuItem<int>(
      value: null,
      child: Text(
        'Select a Seed Variety',
        style: TextStyle(color: Colors.grey),
      ),
    ));
    for (var seed in seedsList) {
      uniqueSeedsItems.add(DropdownMenuItem<int>(
        value: seed.id,
        child: Text(seed.title),
      ));
      seedTitleToIdMap[seed.title] = seed.id;
    }
    // debugPrint("Available dropdown items:");
    for (var item in uniqueSeedsItems) {
      debugPrint('${item.value}: ${item.child}');
    }
  }

  Future<void> _calculateAreaAndDistance() async {
    if (routePoints != null && routePoints!.isNotEmpty) {
      final mapService = MapService();
      final distance = mapService.calculateTotalDistance(routePoints!);

      double area = 0.0;
      double areaInHectares = 0.0;
      final initialPoint = routePoints!.first;
      final closingPoint = routePoints!.last;

      if (_isCloseEnough(initialPoint, closingPoint)) {
        area = mapService.calculateAreaOfPolygon(routePoints!);
        areaInHectares = area / 10000;
      } else {
        geotagSuccess = false;
      }

      setState(() {
        _areaInHectaresController.text =
            areaInHectares > 0 ? _formatNumber(areaInHectares, 'ha') : '';
        _totalDistanceController.text = _formatNumber(distance, 'm');
      });
    }
  }

  bool _isCloseEnough(LatLng point1, LatLng point2) {
    const double threshold = 10.0;
    final distance = const Distance().as(LengthUnit.Meter, point1, point2);
    return distance <= threshold;
  }

  String _formatNumber(double value, String unit) {
    final formatter = NumberFormat('#,##0.############', 'en_US');
    return '${formatter.format(value)} $unit';
  }

  void _submitForm(BuildContext context) async {
    debugPrint('Submitting form...');
    debugPrint('Form Data: $_formData');

    final signatureData =
        await _signatureSectionKey.currentState?.getSignatureData() ?? {};
    debugPrint('Signature Data: $signatureData');

    // Ensure _formData is updated with the latest values from the form
    _formData['ppirNameInsured'] = signatureData['ppirNameInsured'];
    _formData['ppirNameIuia'] = signatureData['ppirNameIuia'];

    final enabledFieldKeys = _formData.keys.where((key) {
      return key != 'trackLastcoord' &&
          key != 'trackTotalarea' &&
          key != 'trackDatetime' &&
          key != 'trackTotaldistance' &&
          key != 'ppirRemarks';
    }).toList();

    bool hasEmptyEnabledFields = enabledFieldKeys.any((key) =>
        _formData[key] == null || _formData[key].toString().trim().isEmpty);

    bool hasEmptySignatureFields = signatureData['ppirSigInsured'] == null ||
        signatureData['ppirNameInsured']?.trim().isEmpty == true ||
        signatureData['ppirSigIuia'] == null ||
        signatureData['ppirNameIuia']?.trim().isEmpty == true;

    if (hasEmptyEnabledFields || hasEmptySignatureFields) {
      showFlashMessage(
          context, 'Info', 'Form Fields', 'Please fill in all required fields');
      return;
    }

    setState(() {
      isSaving = true;
    });

    await _saveFormData();
  }

  Future<void> _saveFormData() async {
    final signatureData =
        await _signatureSectionKey.currentState?.getSignatureData() ?? {};

    _formData['trackTotalarea'] = _areaInHectaresController.text;
    _formData['trackDatetime'] = _areaPlantedController.text;
    _formData['trackLastcoord'] = _formData['trackLastcoord'];
    _formData['trackTotaldistance'] = _totalDistanceController.text;

    _formData['ppirRemarks'] = _formData['ppirRemarks'] ?? 'no value';
    _formData['ppirSigInsured'] = signatureData['ppirSigInsured'] ?? 'no value';
    _formData['ppirNameInsured'] =
        signatureData['ppirNameInsured'] ?? 'no value';
    _formData['ppirSigIuia'] = signatureData['ppirSigIuia'] ?? 'no value';
    _formData['ppirNameIuia'] = signatureData['ppirNameIuia'] ?? 'no value';
    _formData['status'] = 'Completed';

    Map<String, dynamic> taskData = {'status': 'Completed'};

    try {
      await widget.task.updatePpirFormData(_formData, taskData);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const FormSuccessPage(isSaveSuccessful: true),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving form data: $e');
      showFlashMessage(
          context, 'Error', 'Save Failed', 'Failed to save form data.');
    } finally {
      setState(() {
        isSaving = false;
      });
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

  void _navigateToGeotagPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeotagPage(task: widget.task),
      ),
    );
  }

  void _openGpxFile(String gpxFilePath) async {
    if (openOnline) {
      try {
        final response = await http.get(Uri.parse(gpxFilePath));
        if (response.statusCode == 200) {
          final directory = await getTemporaryDirectory();
          final file = File('${directory.path}/temp.gpx');
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
            debugPrint('GPX file opened successfully');
          } else {
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
        if (isLoading)
          const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        else
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('PCIC Form'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  form_field.FormField(
                    labelText: 'Last Coordinates',
                    initialValue: _formData['trackLastcoord'] ?? '',
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
                  FormSection(
                    formData: _formData,
                    uniqueSeedsItems: uniqueSeedsItems,
                    seedTitleToIdMap: seedTitleToIdMap,
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
                  if (gpxFile != null)
                    GPXFileButtons(
                      openGpxFile: () {
                        _openGpxFile(gpxFile!);
                      },
                    )
                  else
                    Column(
                      children: [
                        const Text(
                          'Geotag failed: Initial and end points did not match to close the land for calculation.',
                          style: TextStyle(color: Colors.red),
                        ),
                        ElevatedButton(
                          onPressed: () => _navigateToGeotagPage(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Repeat Geotag'),
                        ),
                      ],
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
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => _submitForm(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
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
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
