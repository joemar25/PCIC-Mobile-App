import 'dart:io';
import '../../geotag/_geotag.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../ppir_form/_pcic_form.dart';
import 'package:open_file/open_file.dart';
import '../controllers/task_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class TaskDetailsPage extends StatelessWidget {
  final TaskManager task;

  const TaskDetailsPage({super.key, required this.task});

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
      final gpxFilePath = await task.getGpxFilePath();

      final response = await http.get(Uri.parse(gpxFilePath));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/temp.gpx');
        await file.writeAsBytes(response.bodyBytes);
        _openLocalFile(context, file.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error downloading GPX file')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error downloading GPX file')),
      );
      debugPrint('Error downloading GPX file: $e');
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error opening GPX file')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'External storage permission is required to open GPX files'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GPX file not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error opening GPX file')),
      );
      debugPrint('Error opening GPX file: $e');
    }
  }

  void _navigateToFormPage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PPIRFormPage(
          task: task,
        ),
      ),
    );
  }

  void _navigateToGeotagPage(BuildContext context) async {
    String? status = await task.status;
    if (context.mounted) {
      if (status == 'Ongoing') {
        _navigateToFormPage(context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GeotagPage(task: task)),
        );
      }
    }
  }

  Future<Map<String, String>> _fetchSignatures() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('PPIR_SAVES/${task.taskId}/Attachments');

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

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Task Details',
          style: TextStyle(
            fontSize: t?.title ?? 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: task.getTaskData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final formData = snapshot.data ?? {};

          return FutureBuilder<String?>(
            future: task.status,
            builder: (context, statusSnapshot) {
              if (statusSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (statusSnapshot.hasError) {
                return Center(child: Text('Error: ${statusSnapshot.error}'));
              }
              final status = statusSnapshot.data;

              return FutureBuilder<Map<String, String>>(
                future: _fetchSignatures(),
                builder: (context, signaturesSnapshot) {
                  if (signaturesSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (signaturesSnapshot.hasError) {
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () => _navigateToGeotagPage(context),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(200, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  backgroundColor: mainColor,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Lottie.asset(
                                      'assets/animations/geotag.json',
                                      width: 30,
                                      height: 30,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      status == 'Ongoing'
                                          ? 'Continue to Complete'
                                          : 'Go to Geotag',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Text(
                          'POST PLANTING INSPECTION REPORT',
                          style: TextStyle(
                            fontSize: t?.headline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _buildFormField(context, 'Farmer Name',
                            formData['ppirFarmerName']?.toString()),
                        _buildFormField(context, 'PPIR Assignment ID',
                            formData['ppirAssignmentId']?.toString()),
                        _buildFormField(context, 'Insurance ID',
                            formData['ppirInsuranceId']?.toString()),
                        _buildFormField(context, 'Mobile No.',
                            formData['ppirMobileNo']?.toString()),
                        _buildFormField(context, 'Type of Farmers',
                            formData['ppirFarmerType']?.toString()),
                        const Divider(height: 32.0),
                        _buildFormField(context, 'Group Name',
                            formData['ppirGroupName']?.toString()),
                        _buildFormField(context, 'Group Address',
                            formData['ppirGroupAddress']?.toString()),
                        const Divider(height: 32.0),
                        _buildFormField(context, 'Lender Name',
                            formData['ppirLenderName']?.toString()),
                        _buildFormField(context, 'Lender Address',
                            formData['ppirLenderAddress']?.toString()),
                        const Divider(height: 32.0),
                        _buildFormField(
                          context,
                          'Region',
                          _convertServiceGroupToRoman(
                              formData['serviceGroup']?.toString()),
                        ),
                        _buildFormField(context, 'Location of Farm',
                            formData['ppirFarmLoc']?.toString()),
                        _buildFormField(context, 'CIC No.',
                            formData['ppirCicNo']?.toString()),
                        const SizedBox(height: 24.0),
                        Text(
                          'Location Sketch Plan',
                          style: TextStyle(
                            fontSize: t?.headline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _buildFormField(context, 'North',
                            formData['ppirNorth']?.toString()),
                        _buildFormField(
                            context, 'East', formData['ppirEast']?.toString()),
                        _buildFormField(context, 'South',
                            formData['ppirSouth']?.toString()),
                        _buildFormField(
                            context, 'West', formData['ppirWest']?.toString()),
                        const SizedBox(height: 24.0),
                        Text(
                          'Findings (Per ACI)',
                          style: TextStyle(
                            fontSize: t?.headline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _buildFormField(context, 'Area Planted',
                            formData['ppirAreaAci']?.toString()),
                        _buildFormField(context, 'Date of Planting (DS)',
                            formData['ppirDopdsAci']?.toString()),
                        _buildFormField(context, 'Date of Planting (TP)',
                            formData['ppirDoptpAci']?.toString()),
                        _buildFormField(context, 'Seed Variety Planted',
                            formData['ppirSvpAci']?.toString()),
                        const SizedBox(height: 24.0),
                        if (status == 'Completed') ...[
                          ElevatedButton(
                            onPressed: () => _openGpxFile(context),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              backgroundColor: mainColor,
                            ),
                            child: const Text(
                              'Open GPX File',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Tracking Results',
                            style: TextStyle(
                              fontSize: t?.headline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          _buildFormField(context, 'Last Coordinates',
                              formData['trackLastcoord']?.toString()),
                          _buildFormField(
                            context,
                            'Date and Time',
                            formData['trackDatetime'] != null
                                ? DateTime.parse(
                                        formData['trackDatetime'].toString())
                                    .toString()
                                : '',
                          ),
                          _buildFormField(context, 'Total Area (Hectares)',
                              formData['trackTotalarea']?.toString()),
                          _buildFormField(context, 'Total Distance',
                              formData['trackTotaldistance']?.toString()),
                          const SizedBox(height: 24.0),
                          Text(
                            'Actual Details',
                            style: TextStyle(
                              fontSize: t?.headline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          _buildFormField(context, 'Area Planted',
                              formData['ppirAreaAct']?.toString()),
                          _buildFormField(context, 'Seed Variety',
                              formData['ppirSvpAct']?.toString()),
                          _buildFormField(
                            context,
                            'Actual Date of Planting (DS)',
                            formData['ppirDopdsAct']?.toString(),
                          ),
                          _buildFormField(
                            context,
                            'Actual Date of Planting (TP)',
                            formData['ppirDoptpAct']?.toString(),
                          ),
                          _buildFormField(context, 'Remarks',
                              formData['ppirRemarks']?.toString()),
                          const SizedBox(height: 24.0),
                          Text(
                            'Assignees',
                            style: TextStyle(
                              fontSize: t?.headline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          _buildFormField(context, 'Confirmed By',
                              formData['ppirNameInsured']?.toString()),
                          if (signatures['ppirSigInsured'] != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Confirmed By Signature:',
                                  style: TextStyle(
                                    color: mainColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: t?.caption ?? 14.0,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Image.network(
                                  signatures['ppirSigInsured']!,
                                  height: 100,
                                ),
                              ],
                            ),
                          _buildFormField(context, 'Prepared By',
                              formData['ppirNameIuia']?.toString()),
                          if (signatures['ppirSigIuia'] != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prepared By Signature:',
                                  style: TextStyle(
                                    color: mainColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: t?.caption ?? 14.0,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Image.network(
                                  signatures['ppirSigIuia']!,
                                  height: 100,
                                ),
                              ],
                            ),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            color: Colors.green.withOpacity(0.1),
                            child: const Text(
                              'Task has been completed and the task file is ready for review.',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
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
}
