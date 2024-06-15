import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/dashboard.dart';
import 'form_components/_form_section.dart';
import 'form_components/_signature_section.dart';
import 'form_components/_gpx_file_buttons.dart';
import 'form_components/_form_field.dart' as form_field;
import 'form_components/_success.dart';
import '../../utils/app/_show_flash_message.dart';
import '../tasks/controllers/task_manager.dart';
import '../geotag/controls/_map_service.dart';
import '../geotag/_geotag.dart';
import '../tasks/controllers/storage_service.dart';
import '../../utils/seeds/_rice_dropdown.dart';
import '../../utils/seeds/_corn_dropdown.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

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
  List<Rice> riceSeedsList = Rice.getAllSeeds();
  List<Corn> cornSeedsList = Corn.getAllSeeds();

  Map<String, int> seedTitleToIdMap = {};
  List<DropdownMenuItem<int>> uniqueSeedsItems = [];
  final _taskData = <String, dynamic>{};
  final _areaPlantedController = TextEditingController();
  final _areaInHectaresController = TextEditingController();
  final _totalDistanceController = TextEditingController();
  final _farmLocationController = TextEditingController();
  final _signatureSectionKey = GlobalKey<SignatureSectionState>();
  final _formSectionKey = GlobalKey<FormSectionState>();

  bool isSaving = false;
  bool isLoading = true;
  bool openOnline = true;
  bool geotagSuccess = true;
  bool isSubmitting = false;
  String? gpxFile;
  List<LatLng>? routePoints;
  LatLng? lastCoordinates;
  String selectedSeedType = 'Rice';
  int? selectedSeedId;
  int? selectedRiceSeedId;
  int? selectedCornSeedId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final formData = await widget.task.getTaskData();
      if (formData.isNotEmpty) {
        _initializeFormData(formData);
      } else {
        _initializeSeeds();
      }

      final mapService = MapService();
      gpxFile = await widget.task.getGpxFilePath();
      if (gpxFile != null) {
        final gpxData = await mapService.readGpxFile(gpxFile!);
        routePoints = await mapService.parseGpxData(gpxData);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
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
    _areaInHectaresController.text = formData['trackTotalarea'] ?? 'Empty';
    _totalDistanceController.text = formData['trackTotaldistance'] ?? 'Empty';
    _farmLocationController.text = formData['ppirFarmLoc'] ?? '';
    _taskData['trackLastcoord'] =
        formData['trackLastcoord'] ?? 'No coordinates available';
    _taskData['ppirDopdsAct'] = formData['ppirDopdsAct'] ?? '';
    _taskData['ppirDoptpAct'] = formData['ppirDoptpAct'] ?? '';
    _taskData['ppirSvpAct'] = formData['ppirSvpAct'] ?? 'Rice';
    _taskData['ppirVariety'] = formData['ppirVariety'] ?? '';
    _taskData['ppirAreaAct'] = formData['ppirAreaAct'] ?? '';
    _taskData['ppirRemarks'] = formData['ppirRemarks'] ?? '';
    _taskData['ppirNameInsured'] = formData['ppirNameInsured'] ?? '';
    _taskData['ppirNameIuia'] = formData['ppirNameIuia'] ?? '';

    _taskData['ppirDopdsAci'] = formData['ppirDopdsAci'] ?? '';
    _taskData['ppirDoptpAci'] = formData['ppirDoptpAci'] ?? '';

    selectedSeedType = _taskData['ppirSvpAct'] ?? 'Rice';
    _initializeSeeds();
  }

  void _initializeSeeds() {
    uniqueSeedsItems.clear();
    seedTitleToIdMap.clear();
    List<dynamic> seedsList =
        selectedSeedType == 'Rice' ? riceSeedsList : cornSeedsList;

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

    setState(() {
      if (_taskData['ppirVariety'] != null &&
          _taskData['ppirVariety'].isNotEmpty) {
        selectedSeedId = seedTitleToIdMap[_taskData['ppirVariety']];
      } else {
        selectedSeedId = null;
      }
    });
  }

  void _onSelectedSeedIdChanged(int? value) {
    setState(() {
      if (selectedSeedType == 'Rice') {
        selectedRiceSeedId = value;
      } else {
        selectedCornSeedId = value;
      }
      selectedSeedId = value;
    });
  }

  Future<void> _submitForm(BuildContext context) async {
    setState(() {
      isSubmitting = true;
    });

    final isFormSectionValid =
        _formSectionKey.currentState?.validate() ?? false;
    final isSignatureSectionValid =
        _signatureSectionKey.currentState?.validate() ?? false;

    debugPrint('Form Section Valid: $isFormSectionValid');
    debugPrint('Signature Section Valid: $isSignatureSectionValid');

    if (!isFormSectionValid || !isSignatureSectionValid) {
      showFlashMessage(context, 'Info', 'Validation Failed',
          'Please fill in all required fields.');
      setState(() {
        isSubmitting = false;
      });
      return;
    }

    // Check if geotag failed
    if (_areaInHectaresController.text == 'Empty' ||
        _areaInHectaresController.text == '0.0') {
      showFlashMessage(context, 'Error', 'Geotag Failed',
          'Please repeat the geotag process to calculate the land area.');
      setState(() {
        isSubmitting = false;
      });
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final signatureData =
          await _signatureSectionKey.currentState?.getSignatureData() ?? {};

      debugPrint('Signature Data: $signatureData');

      // Ensure required signature data
      if (signatureData['ppirSigInsured'] == null ||
          signatureData['ppirNameInsured']?.trim().isEmpty == true ||
          signatureData['ppirSigIuia'] == null ||
          signatureData['ppirNameIuia']?.trim().isEmpty == true) {
        if (context.mounted) {
          showFlashMessage(context, 'Info', 'Validation Failed',
              'Please fill in all required fields.');
        }
        setState(() {
          isSaving = false;
        });
        return;
      }

      _taskData['ppirNameInsured'] = signatureData['ppirNameInsured'];
      _taskData['ppirNameIuia'] = signatureData['ppirNameIuia'];
      _taskData['ppirSigInsured'] = signatureData['ppirSigInsured'];
      _taskData['ppirSigIuia'] = signatureData['ppirSigIuia'];

      // Populate form data
      _taskData['trackTotalarea'] = _areaInHectaresController.text;
      _taskData['trackDatetime'] = _areaPlantedController.text;
      _taskData['trackTotaldistance'] = _totalDistanceController.text;
      _taskData['ppirFarmLoc'] = _farmLocationController.text;
      _taskData['ppirRemarks'] = _taskData['ppirRemarks'] ?? 'no value';
      _taskData['ppirSvpAct'] = selectedSeedType;
      _taskData['ppirVariety'] = selectedSeedId != null
          ? seedTitleToIdMap.entries
              .firstWhere((entry) => entry.value == selectedSeedId)
              .key
          : null;
      _taskData['taskStatus'] = 'Completed';

      // Convert date format for ppirDopdsAci and ppirDoptpAci
      if (_taskData['ppirDopdsAci'] != null &&
          _taskData['ppirDopdsAci'].isNotEmpty) {
        _taskData['ppirDopdsAci'] =
            convertDateFormat(_taskData['ppirDopdsAci']);
      }
      if (_taskData['ppirDoptpAci'] != null &&
          _taskData['ppirDoptpAci'].isNotEmpty) {
        _taskData['ppirDoptpAci'] =
            convertDateFormat(_taskData['ppirDoptpAci']);
      }

      debugPrint('Task Data Before Update: $_taskData');

      await widget.task.updateTaskData(_taskData);

      final filename = await widget.task.filename;
      if (filename != null) {
        await StorageService.saveTaskFileToFirebaseStorage(widget.task.taskId);
        await StorageService.compressAndUploadTaskFiles(
            filename, widget.task.taskId);
      }

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const FormSuccessPage(isSaveSuccessful: true),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showFlashMessage(
            context, 'Error', 'Save Failed', 'Failed to save form data.');
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
          isSubmitting = false;
        });
      }
    }
  }

  String convertDateFormat(String dateStr) {
    List<String> dateFormats = ['MMM dd, yyyy', 'MM-dd-yyyy', 'yyyy-MM-dd'];

    for (String format in dateFormats) {
      try {
        DateTime parsedDate = DateFormat(format).parse(dateStr);
        debugPrint('Parsed date with format $format: $parsedDate');
        return DateFormat('MM-dd-yyyy').format(
            DateTime(parsedDate.year, parsedDate.month, parsedDate.day));
      } catch (e) {
        // Continue to the next format if parsing fails
        debugPrint('Error parsing date with format $format: $e');
      }
    }

    // Log the error if no formats matched
    debugPrint('Error: No matching format found for date: $dateStr');
    return dateStr; // Return the original string if parsing fails
  }

  Future<void> _saveForm() async {
    setState(() {
      isSaving = true;
    });

    try {
      final signatureData =
          await _signatureSectionKey.currentState?.getSignatureData() ?? {};

      _taskData['trackTotalarea'] = _areaInHectaresController.text;
      _taskData['trackDatetime'] = _areaPlantedController.text;
      _taskData['trackLastcoord'] = _taskData['trackLastcoord'];
      _taskData['trackTotaldistance'] = _totalDistanceController.text;
      _taskData['ppirFarmLoc'] = _farmLocationController.text;
      _taskData['ppirRemarks'] = _taskData['ppirRemarks'] ?? 'no value';
      _taskData['ppirSigInsured'] =
          signatureData['ppirSigInsured'] ?? 'no value';
      _taskData['ppirNameInsured'] =
          signatureData['ppirNameInsured'] ?? 'no value';
      _taskData['ppirSigIuia'] = signatureData['ppirSigIuia'] ?? 'no value';
      _taskData['ppirNameIuia'] = signatureData['ppirNameIuia'] ?? 'no value';
      _taskData['ppirSvpAct'] = selectedSeedType;
      _taskData['ppirVariety'] = selectedSeedId != null
          ? seedTitleToIdMap.entries
              .firstWhere((entry) => entry.value == selectedSeedId)
              .key
          : null;
      _taskData['taskStatus'] = 'Ongoing';

      // Convert date format for ppirDopdsAci and ppirDoptpAci
      if (_taskData['ppirDopdsAci'] != null &&
          _taskData['ppirDopdsAci'].isNotEmpty) {
        _taskData['ppirDopdsAci'] =
            convertDateFormat(_taskData['ppirDopdsAci']);
      }

      if (_taskData['ppirDoptpAci'] != null &&
          _taskData['ppirDoptpAci'].isNotEmpty) {
        _taskData['ppirDoptpAci'] =
            convertDateFormat(_taskData['ppirDoptpAci']);
      }

      await widget.task.updateTaskData(_taskData);

      if (mounted) {
        showFlashMessage(
            context, 'Info', 'Form Saved', 'Form data saved successfully.');
        _navigateToDashboard(context);
      }
    } catch (e) {
      if (mounted) {
        showFlashMessage(
            context, 'Error', 'Save Failed', 'Failed to save form data.');
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void _cancelForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
        title: const Text(
          'UNSAVED CHANGES!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: mainColor,
          ),
        ),
        content: const Text(
          'You have unsaved changes. If you go back, your data will not be saved.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Leave',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextButton(
                  onPressed: () {
                    _saveForm();
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!isSaving) {
      bool? shouldLeave = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text(
              'You have unsaved changes. If you go back, your data will not be saved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Leave', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                _saveForm();
                Navigator.pop(context, false);
              },
              child: const Text('Save', style: TextStyle(color: mainColor)),
            ),
          ],
        ),
      );
      return shouldLeave ?? false;
    }
    return true;
  }

  void _navigateToGeotagPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeotagPage(task: widget.task),
      ),
    );
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );
  }

  void _openGpxFile(String gpxFilePath) async {
    if (_areaInHectaresController.text == 'Empty' ||
        _areaInHectaresController.text == '0.0') {
      showFlashMessage(context, 'Error', 'GPX File Error',
          'Total area in hectares is empty. Cannot open GPX file.');
      return;
    }

    if (openOnline) {
      try {
        final response = await http.get(Uri.parse(gpxFilePath));
        if (response.statusCode == 200) {
          final directory = await getTemporaryDirectory();
          final file = File('${directory.path}/temp.gpx');
          await file.writeAsBytes(response.bodyBytes);
          _openLocalFile(file.path);
        } else {
          _showSnackBar('Error downloading GPX file');
        }
      } catch (e) {
        _showSnackBar('Error downloading GPX file');
      }
    } else {
      _openLocalFile(gpxFilePath);
    }
  }

  void _openLocalFile(String filePath) async {
    try {
      final gpxFile = File(filePath);
      if (await gpxFile.exists()) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }

        if (status.isGranted) {
          final result = await OpenFile.open(gpxFile.path);
          if (result.type != ResultType.done) {
            _showSnackBar('Error opening GPX file');
          }
        } else {
          _showSnackBar('Storage permission is required to open GPX files');
        }
      } else {
        _showSnackBar('GPX file not found');
      }
    } catch (e) {
      _showSnackBar('Error opening GPX file');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(
          children: [
            if (isLoading)
              const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              )
            else
              Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: mainColor,
                  title: const Text(
                    'PCIC FORM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight:
                          FontWeight.bold, // Change this to your desired color
                    ),
                  ),
                  centerTitle: true,
                  actions: [
                    TextButton(
                        onPressed: _saveForm,
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        )),
                  ],
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      form_field.FormField(
                        labelText: 'Last Coordinates',
                        initialValue: _taskData['trackLastcoord'] ?? 'Empty',
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _farmLocationController,
                        decoration: const InputDecoration(
                          labelText: 'Farm Location',
                          border: OutlineInputBorder(),
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Select Seed Type',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio<String>(
                            value: 'Rice',
                            groupValue: selectedSeedType,
                            onChanged: (value) {
                              setState(() {
                                selectedSeedType = value!;
                                _initializeSeeds();
                              });
                            },
                          ),
                          const Text('Rice'),
                          Radio<String>(
                            value: 'Corn',
                            groupValue: selectedSeedType,
                            onChanged: (value) {
                              setState(() {
                                selectedSeedType = value!;
                                _initializeSeeds();
                              });
                            },
                          ),
                          const Text('Corn'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      FormSection(
                        key: _formSectionKey,
                        formData: _taskData,
                        uniqueSeedsItems: uniqueSeedsItems,
                        seedTitleToIdMap: seedTitleToIdMap,
                        isSubmitting: isSubmitting,
                        selectedSeedId: selectedSeedId,
                        onSelectedSeedIdChanged: _onSelectedSeedIdChanged,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Signatures',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SignatureSection(
                        key: _signatureSectionKey,
                        task: widget.task,
                        isSubmitting: isSubmitting,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Map Geotag',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      if (gpxFile != null &&
                          _areaInHectaresController.text != 'Empty' &&
                          _areaInHectaresController.text != '0.0')
                        Column(
                          children: [
                            GPXFileButtons(
                              openGpxFile: () {
                                _openGpxFile(gpxFile!);
                              },
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _navigateToGeotagPage(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Restart Geotag'),
                            ),
                          ],
                        )
                      else if (_areaInHectaresController.text == 'Empty' ||
                          _areaInHectaresController.text == '0.0')
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          backgroundColor: mainColor,
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
        ));
  }
}
