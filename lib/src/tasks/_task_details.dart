// filename: tasks/_task_details.dart (latest)
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

import '../geotag/_geotag.dart';
import '../ppir_form/_pcic_form.dart';
import '_control_task.dart';

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
              color: const Color(0xFF0F7D40),
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
        future: task.getFormData(task.type),
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
                              backgroundColor: const Color(0xFF0F7D40),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/storage/images/geotag.svg',
                                  width: 24,
                                  height: 24,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  status == 'Ongoing'
                                      ? 'Continue the Form'
                                      : 'Go to Geotag',
                                  style: TextStyle(
                                    fontSize: t?.body,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Text(
                      'Post Planting Inspection Report',
                      style: TextStyle(
                        fontSize: t?.headline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildFormField(
                        context, 'Farmer Name', formData['ppirFarmerName']),
                    _buildFormField(
                        context, 'Address', formData['ppirAddress']),
                    _buildFormField(
                        context, 'Mobile No.', formData['ppirMobileNo']),
                    _buildFormField(
                        context, 'Type of Farmers', formData['ppirFarmerType']),
                    const Divider(height: 32.0),
                    _buildFormField(
                        context, 'Group Name', formData['ppirGroupName']),
                    _buildFormField(
                        context, 'Group Address', formData['ppirGroupAddress']),
                    const Divider(height: 32.0),
                    _buildFormField(
                        context, 'Lender Name', formData['ppirLenderName']),
                    _buildFormField(context, 'Lender Address',
                        formData['ppirLenderAddress']),
                    const Divider(height: 32.0),
                    _buildFormField(
                      context,
                      'Region',
                      _convertServiceGroupToRoman(formData['serviceGroup']),
                    ),
                    _buildFormField(
                        context, 'Location of Farm', formData['ppirFarmLoc']),
                    _buildFormField(context, 'CIC No.', formData['ppirCicNo']),
                    const SizedBox(height: 24.0),
                    Text(
                      'Location Sketch Plan',
                      style: TextStyle(
                        fontSize: t?.headline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildFormField(context, 'North', formData['ppirNorth']),
                    _buildFormField(context, 'East', formData['ppirEast']),
                    _buildFormField(context, 'South', formData['ppirSouth']),
                    _buildFormField(context, 'West', formData['ppirWest']),
                    const SizedBox(height: 24.0),
                    Text(
                      'Findings (Per ACI)',
                      style: TextStyle(
                        fontSize: t?.headline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildFormField(
                        context, 'Area Planted', formData['ppirAreaAci']),
                    _buildFormField(context, 'Date of Planting (DS)',
                        formData['ppirDopdsAci']),
                    _buildFormField(context, 'Date of Planting (TP)',
                        formData['ppirDoptpAci']),
                    _buildFormField(context, 'Seed Variety Planted',
                        formData['ppirVariety']),
                    if (status == 'Completed') ...[
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
                          formData['trackLastcoord']),
                      _buildFormField(
                        context,
                        'Date and Time',
                        formData['trackDatetime'] != null
                            ? DateTime.parse(formData['trackDatetime'])
                                .toString()
                            : '',
                      ),
                      _buildFormField(context, 'Total Area (Hectares)',
                          formData['trackTotalarea']),
                      _buildFormField(context, 'Total Distance',
                          formData['trackTotaldistance']),
                      const SizedBox(height: 24.0),
                      Text(
                        'Actual Details',
                        style: TextStyle(
                          fontSize: t?.headline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _buildFormField(
                          context, 'Last Coordinates', formData['ppirAreaAct']),
                      _buildFormField(
                          context, 'Seed Variety', formData['ppirVariety']),
                      _buildFormField(
                        context,
                        'Actual Date of Planting (DS)',
                        formData['ppirDopdsAct'],
                      ),
                      _buildFormField(
                        context,
                        'Actual Date of Planting (TP)',
                        formData['ppirDoptpAct'],
                      ),
                      _buildFormField(
                          context, 'Remarks', formData['ppirRemarks']),
                      const SizedBox(height: 24.0),
                      Text(
                        'Assignees',
                        style: TextStyle(
                          fontSize: t?.headline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _buildFormField(
                          context, 'Confirmed By', formData['ppirNameInsured']),
                      _buildFormField(
                          context, 'Prepared By', formData['ppirNameIuia']),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
