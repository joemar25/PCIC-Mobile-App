// src/tasks/components/_task_details.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/task_manager.dart';
import '../controllers/storage_service.dart';

import '../../theme/_theme.dart';
import '../../geotag/_geotag.dart';
import '../../ppir_form/_pcic_form.dart';

class TaskDetailsPage extends StatefulWidget {
  final TaskManager task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  TaskDetailsPageState createState() => TaskDetailsPageState();
}

class TaskDetailsPageState extends State<TaskDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: mainColor),
        title: Text(
          'Task Details',
          style: TextStyle(
            color: mainColor,
            fontSize:
                Theme.of(context).extension<CustomThemeExtension>()?.title ??
                    20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: widget.task.getTaskData(),
        builder: (context, taskDataSnapshot) {
          if (taskDataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (taskDataSnapshot.hasError) {
            return Center(child: Text('Error: ${taskDataSnapshot.error}'));
          }

          final formData = taskDataSnapshot.data ?? {};

          return FutureBuilder<String?>(
            future: widget.task.status,
            builder: (context, statusSnapshot) {
              if (statusSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (statusSnapshot.hasError) {
                return Center(child: Text('Error: ${statusSnapshot.error}'));
              }

              final status = statusSnapshot.data;

              return FutureBuilder<Map<String, String>>(
                future: _fetchSignatures(),
                builder: (context, signaturesSnapshot) {
                  if (signaturesSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (signaturesSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${signaturesSnapshot.error}'));
                  }

                  final signatures = signaturesSnapshot.data ?? {};

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (status != 'Completed')
                          _buildGeotagButton(context, status),
                        _buildSectionTitle(
                            context, 'POST PLANTING INSPECTION REPORT'),
                        _buildFormDataFields(context, formData),
                        _buildSectionTitle(context, 'Location Sketch Plan'),
                        _buildLocationFields(context, formData),
                        _buildSectionTitle(context, 'Findings (Per ACI)'),
                        _buildFindingsFields(context, formData),
                        if (status == 'Completed')
                          ..._buildCompletedSection(
                              context, formData, signatures),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize:
              Theme.of(context).extension<CustomThemeExtension>()?.headline,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFormDataFields(
      BuildContext context, Map<String, dynamic> formData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(
            context, 'Farmer Name', formData['ppirFarmerName']?.toString()),
        _buildFormField(
            context, 'Address', formData['ppirAddress']?.toString()),
        _buildFormField(context, 'PPIR Assignment ID',
            formData['ppirAssignmentId']?.toString()),
        _buildFormField(
            context, 'Insurance ID', formData['ppirInsuranceId']?.toString()),
        _buildFormField(
            context, 'Mobile No.', formData['ppirMobileNo']?.toString()),
        _buildFormField(
            context, 'Type of Farmers', formData['ppirFarmerType']?.toString()),
        const Divider(height: 32.0),
        _buildFormField(
            context, 'Group Name', formData['ppirGroupName']?.toString()),
        _buildFormField(
            context, 'Group Address', formData['ppirGroupAddress']?.toString()),
        const Divider(height: 32.0),
        _buildFormField(
            context, 'Lender Name', formData['ppirLenderName']?.toString()),
        _buildFormField(context, 'Lender Address',
            formData['ppirLenderAddress']?.toString()),
        const Divider(height: 32.0),
        _buildFormField(context, 'Region',
            _convertServiceGroupToRoman(formData['serviceGroup']?.toString())),
        _buildFormField(
            context, 'Location of Farm', formData['ppirFarmLoc']?.toString()),
        _buildFormField(context, 'CIC No.', formData['ppirCicNo']?.toString()),
      ],
    );
  }

  Widget _buildLocationFields(
      BuildContext context, Map<String, dynamic> formData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(context, 'North', formData['ppirNorth']?.toString()),
        _buildFormField(context, 'East', formData['ppirEast']?.toString()),
        _buildFormField(context, 'South', formData['ppirSouth']?.toString()),
        _buildFormField(context, 'West', formData['ppirWest']?.toString()),
      ],
    );
  }

  Widget _buildFindingsFields(
      BuildContext context, Map<String, dynamic> formData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(
            context, 'Area Planted', formData['ppirAreaAci']?.toString()),
        _buildFormField(context, 'Date of Planting (DS)',
            formData['ppirDopdsAci']?.toString()),
        _buildFormField(context, 'Date of Planting (TP)',
            formData['ppirDoptpAci']?.toString()),
        _buildFormField(context, 'Seed Variety Planted',
            formData['ppirSvpAci']?.toString()),
      ],
    );
  }

  List<Widget> _buildCompletedSection(BuildContext context,
      Map<String, dynamic> formData, Map<String, String> signatures) {
    return [
      ElevatedButton(
        onPressed: () => _openGpxFile(context),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          backgroundColor: mainColor,
        ),
        child:
            const Text('Open GPX File', style: TextStyle(color: Colors.white)),
      ),
      const SizedBox(height: 24.0),
      ResubmitButton(task: widget.task),
      const SizedBox(height: 24.0),
      _buildSectionTitle(context, 'Tracking Results'),
      _buildFormField(
          context, 'Last Coordinates', formData['trackLastcoord']?.toString()),
      _buildFormField(
          context,
          'Date and Time',
          formData['trackDatetime'] != null
              ? DateTime.parse(formData['trackDatetime'].toString()).toString()
              : ''),
      _buildFormField(context, 'Total Area (Hectares)',
          formData['trackTotalarea']?.toString()),
      _buildFormField(context, 'Total Distance',
          formData['trackTotaldistance']?.toString()),
      const SizedBox(height: 24.0),
      _buildSectionTitle(context, 'Actual Details'),
      _buildFormField(
          context, 'Area Planted', formData['ppirAreaAct']?.toString()),
      _buildFormField(
          context, 'Seed Variety', formData['ppirVariety']?.toString()),
      _buildFormField(context, 'Actual Date of Planting (DS)',
          formData['ppirDopdsAct']?.toString()),
      _buildFormField(context, 'Actual Date of Planting (TP)',
          formData['ppirDoptpAct']?.toString()),
      _buildFormField(context, 'Remarks', formData['ppirRemarks']?.toString()),
      const SizedBox(height: 24.0),
      _buildSectionTitle(context, 'Assignees'),
      _buildFormField(
          context, 'Confirmed By', formData['ppirNameInsured']?.toString()),
      if (signatures['ppirSigInsured'] != null)
        _buildSignature(
            context, 'Confirmed By Signature:', signatures['ppirSigInsured']!),
      _buildFormField(
          context, 'Prepared By', formData['ppirNameIuia']?.toString()),
      if (signatures['ppirSigIuia'] != null)
        _buildSignature(
            context, 'Prepared By Signature:', signatures['ppirSigIuia']!),
      Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.green.withOpacity(0.1),
        child: const Text(
            'Task has been completed and the task file is ready for review.',
            style: TextStyle(color: Colors.green)),
      ),
    ];
  }

  Widget _buildSignature(BuildContext context, String label, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: mainColor,
            fontWeight: FontWeight.w600,
            fontSize:
                Theme.of(context).extension<CustomThemeExtension>()?.caption ??
                    14.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Image.network(url, height: 100),
      ],
    );
  }

  Widget _buildFormField(BuildContext context, String label, String? value) {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    final displayValue = value?.isNotEmpty ?? false ? value : 'N/A';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: mainColor,
              fontWeight: FontWeight.w600,
              fontSize: t?.caption ?? 14.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              displayValue!,
              style: TextStyle(fontSize: t?.body, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openGpxFile(BuildContext context) async {
    try {
      final gpxFilePath = await widget.task.getGpxFilePath();
      final response = await http.get(Uri.parse(gpxFilePath));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/temp.gpx');
        await file.writeAsBytes(response.bodyBytes);
        if (context.mounted) {
          _openLocalFile(context, file.path);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error downloading GPX file')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error downloading GPX file')));
        debugPrint('Error downloading GPX file: $e');
      }
    }
  }

  void _openLocalFile(BuildContext context, String filePath) async {
    try {
      final gpxFile = File(filePath);
      if (await gpxFile.exists()) {
        final status = await Permission.manageExternalStorage.status;
        if (status.isGranted) {
          final result = await OpenFile.open(gpxFile.path);
          if (result.type != ResultType.done) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error opening GPX file')));
            }
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'External storage permission is required to open GPX files')),
            );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('GPX file not found')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error opening GPX file')));
        debugPrint('Error opening GPX file: $e');
      }
    }
  }

  void _navigateToFormPage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PPIRFormPage(task: widget.task)),
    );
  }

  void _navigateToGeotagPage(BuildContext context) async {
    String? status = await widget.task.status;
    if (context.mounted) {
      if (status == 'Ongoing') {
        _navigateToFormPage(context);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GeotagPage(task: widget.task)));
      }
    }
  }

  Future<Map<String, String>> _fetchSignatures() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('PPIR_SAVES/${widget.task.taskId}/Attachments');
    final ListResult result = await storageRef.listAll();
    Map<String, String> signatures = {};
    for (Reference fileRef in result.items) {
      if (fileRef.name.contains('ppirSigInsured')) {
        signatures['ppirSigInsured'] = await fileRef.getDownloadURL();
      }
      if (fileRef.name.contains('ppirSigIuia')) {
        signatures['ppirSigIuia'] = await fileRef.getDownloadURL();
      }
    }
    return signatures;
  }

  Widget _buildGeotagButton(BuildContext context, String? status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () => _navigateToGeotagPage(context),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            backgroundColor: mainColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, color: Colors.white),
              const SizedBox(width: 8.0),
              Text(
                status == 'Ongoing' ? 'Continue to Complete' : 'Go to Geotag',
                style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _convertServiceGroupToRoman(String? serviceCode) {
    const romanMap = {
      'P01': 'I',
      'P02': 'II',
      'P03': 'III',
      'P04': 'IV',
      'PMIMAROPA': 'MIMAROPA',
      'P05': 'V',
      'P06': 'VI',
      'P07': 'VII',
      'P08': 'VIII',
      'P09': 'IX',
      'P10': 'X',
      'P11': 'XI',
      'P12': 'XII',
      'P13': 'XIII',
      'PNCR': 'NCR',
      'PCAR': 'CAR',
      'PBARMM': 'BARMM',
    };
    return serviceCode == null ? '' : romanMap[serviceCode] ?? serviceCode;
  }
}

class ResubmitButton extends StatefulWidget {
  final TaskManager task;

  const ResubmitButton({super.key, required this.task});

  @override
  ResubmitButtonState createState() => ResubmitButtonState();
}

class ResubmitButtonState extends State<ResubmitButton> {
  bool _isResubmitting = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isResubmitting ? null : () => _resubmitTaskFile(context),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        backgroundColor: mainColor,
      ),
      child: _isResubmitting
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text('Resubmit Task File',
              style: TextStyle(color: Colors.white)),
    );
  }

  Future<void> _resubmitTaskFile(BuildContext context) async {
    setState(() {
      _isResubmitting = true;
    });
    try {
      final filename = await widget.task.filename;
      final serviceGroup = await widget.task.serviceGroup;

      if (filename != null) {
        await StorageService.downloadAndResubmitTaskFile(
            filename, widget.task.taskId, serviceGroup ?? '');
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Task file resubmitted successfully')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error resubmitting task file')));
        debugPrint('Error resubmitting task file: $e');
      }
    }
    setState(() {
      _isResubmitting = false;
    });
  }
}
