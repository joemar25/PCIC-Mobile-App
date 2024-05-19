// filename: _task_details
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

import '../geotag/_geotag.dart';
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

  Widget _buildFormSection(
      BuildContext context, String title, List<Widget> fields) {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 12.0),
              alignment: Alignment.center,
              child: Text(title,
                  style: TextStyle(
                    fontSize: t?.headline,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Container(
              width: double.maxFinite,
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 0.2, color: Colors.grey),
                boxShadow: [
                  // BoxShadow(color: Color(0xFF0F7D40), offset: Offset(-5, 5))
                  BoxShadow(
                    color: const Color(0xFF0F7D40).withOpacity(0.8),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.2),
                //     spreadRadius: 2,
                //     blurRadius: 2,
                //     offset: const Offset(0, 5),
                //   )
                // ],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 18.0),
                    ...fields,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(BuildContext context, String label, String? value) {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    final displayValue = value?.isNotEmpty ?? false ? value : 'N/A';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:',
              style: TextStyle(
                color: const Color(0xFF0F7D40),
                fontWeight: FontWeight.w600,
                fontSize: t?.caption ?? 14.0,
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(displayValue!,
                style:
                    TextStyle(fontSize: t?.body, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _navigateToGeotagPage(BuildContext context) async {
    String? status = await task.status;
    if (context.mounted) {
      if (status != 'Completed') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GeotagPage(task: task)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task is already completed.')),
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
                  children: [
                    if (status != 'Completed')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => _navigateToGeotagPage(context),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 60),
                                shape: const CircleBorder(),
                                backgroundColor: const Color(0xFF0F7D40),
                              ),
                              child: SizedBox(
                                height: 35,
                                width: 35,
                                child: SvgPicture.asset(
                                  'assets/storage/images/geotag.svg',
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Go to Geotag',
                                style: TextStyle(
                                  fontSize: t?.body,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    _buildFormSection(
                        context, 'Post Planting Inspection Report', [
                      _buildFormField(
                          context, 'Farmer Name', formData['ppirFarmerName']),
                      _buildFormField(
                          context, 'Address', formData['ppirAddress']),
                      _buildFormField(
                          context, 'Mobile No.', formData['ppirMobileNo']),
                      _buildFormField(context, 'Type of Farmers',
                          formData['ppirFarmerType']),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Divider(),
                      ),
                      _buildFormField(
                          context, 'Group Name', formData['ppirGroupName']),
                      _buildFormField(context, 'Group Address',
                          formData['ppirGroupAddress']),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Divider(),
                      ),
                      _buildFormField(
                          context, 'Lender Name', formData['ppirLenderName']),
                      _buildFormField(context, 'Lender Address',
                          formData['ppirLenderAddress']),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Divider(),
                      ),
                      _buildFormField(
                          context,
                          'Region',
                          _convertServiceGroupToRoman(
                              formData['serviceGroup'])),
                      _buildFormField(
                          context, 'Location of Farm', formData['ppirFarmLoc']),
                      _buildFormField(
                          context, 'CIC No.', formData['ppirCicNo']),
                    ]),
                    _buildFormSection(context, 'Location Sketch Plan', [
                      _buildFormField(context, 'North', formData['ppirNorth']),
                      _buildFormField(context, 'East', formData['ppirEast']),
                      _buildFormField(context, 'South', formData['ppirSouth']),
                      _buildFormField(context, 'West', formData['ppirWest']),
                    ]),
                    _buildFormSection(context, 'Findings (Per ACI)', [
                      _buildFormField(
                          context, 'Area Planted', formData['ppirAreaAci']),
                      _buildFormField(context, 'Date of Planting (DS)',
                          formData['ppirDopdsAci']),
                      _buildFormField(context, 'Date of Planting (TP)',
                          formData['ppirDoptpAci']),
                      _buildFormField(context, 'Seed Variety Planted',
                          formData['ppirVariety']),
                    ]),
                    if (status == 'Completed') ...[
                      _buildFormSection(context, 'Tracking Results', [
                        _buildFormField(context, 'Last Coordinates',
                            formData['trackLastcoord']),
                        _buildFormField(context, 'Date and Time',
                            formData['trackDatetime']?.toDate().toString()),
                        _buildFormField(context, 'Total Area (Hectares)',
                            formData['trackTotalarea']),
                        _buildFormField(context, 'Total Distance',
                            formData['trackTotaldistance']),
                      ]),
                      _buildFormSection(context, 'Actual Details', [
                        _buildFormField(context, 'Last Coordinates',
                            formData['ppirAreaAct']),
                        _buildFormField(
                            context, 'Seed Variety', formData['ppirVariety']),
                        _buildFormField(context, 'Actual Date of Planting (DS)',
                            formData['ppirDopdsAct']),
                        _buildFormField(context, 'Actual Date of Planting (TP)',
                            formData['ppirDoptpAct']),
                        _buildFormField(
                            context, 'Remarks', formData['ppirRemarks']),
                      ]),
                      _buildFormSection(context, 'Assignees', [
                        _buildFormField(context, 'Confirmed By',
                            formData['ppirNameInsured']),
                        _buildFormField(
                            context, 'Prepared By', formData['ppirNameIuia']),
                      ]),
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
