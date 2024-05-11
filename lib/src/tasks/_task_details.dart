// filename: _task_details
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

import '../geotag/_geotag.dart';
import '_control_task.dart';

class TaskDetailsPage extends StatefulWidget {
  final TaskManager task;
  const TaskDetailsPage({super.key, required this.task});

  @override
  TaskDetailsPageState createState() => TaskDetailsPageState();
}

class TaskDetailsPageState extends State<TaskDetailsPage> {
  late Map<String, String> formData;
  late Map<String, bool> columnStatus;

  @override
  void initState() {
    super.initState();
    columnStatus = widget.task.getColumnStatus();
    formData = widget.task.csvData?.map((key, value) => MapEntry(
            key,
            key == 'serviceGroup'
                ? _convertServiceGroupToRoman(value)
                : value?.toString() ?? '')) ??
        {};
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
      /**
       * https://www.philatlas.com/regions.html
       * Region I – Ilocos Region
       * Region II – Cagayan Valley
       * Region III – Central Luzon
       * Region IV‑A – CALABARZON
       * MIMAROPA Region
       * Region V – Bicol Region
       * Region VI – Western Visayas
       * Region VII – Central Visayas
       * Region VIII – Eastern Visayas
       * Region IX – Zamboanga Peninsula
       * Region X – Northern Mindanao
       * Region XI – Davao Region
       * Region XII – SOCCSKSARGEN
       * Region XIII – Caraga
       * NCR – National Capital Region
       * CAR – Cordillera Administrative Region
       * BARMM – Bangsamoro Autonomous Region in Muslim Mindanao
      */
    };
    return serviceCode == null ? '' : romanMap[serviceCode] ?? serviceCode;
  }

  Widget _buildFormSection(String title, List<Widget> fields) {
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
                    border: Border.all(width: 0.5, color: Colors.black38),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFF0F7D40),
                        offset: Offset(-5, 5),
                      )
                    ],
                    borderRadius: BorderRadius.circular(15.0)),
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
        ));
  }

  Widget _buildFormField(String label, String? value) {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    final displayValue = value?.isNotEmpty ?? false ? value : 'test'; // N/A
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:',
              style: TextStyle(
                  color: const Color(0xFF0F7D40),
                  fontWeight: FontWeight.w600,
                  fontSize: t?.caption ?? 14.0)),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(displayValue ?? '',
                style:
                    TextStyle(fontSize: t?.body, fontWeight: FontWeight.w600)),
          )
        ],
      ),
    );
  }

  // void _debugPrintCsvData() {
  //   debugPrint('CSV Data:');
  //   formData.forEach((key, value) {
  //     debugPrint('$key: $value');
  //   });
  // }

  void _navigateToGeotagPage() {
    if (!widget.task.isCompleted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GeotagPage(task: widget.task)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task is already completed.')),
      );
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
                fontSize: t?.title ?? 14.0, fontWeight: FontWeight.bold),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!widget.task.isCompleted) // Render button only if task is not completed
              Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: _navigateToGeotagPage,
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Go to Geotag',
                          style: TextStyle(
                              fontSize: t?.body,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
              ),
            _buildFormSection('Post Planting Inspection Report', [
              _buildFormField('Farmer Name', formData['ppirFarmerName']),
              _buildFormField('Address', formData['ppirAddress']),
              _buildFormField('Mobile No.', formData['ppirMobileNo']),
              _buildFormField('Type of Farmers', formData['ppirFarmerType']),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Divider()),
              _buildFormField('Group Name', formData['ppirGroupName']),
              _buildFormField('Group Address', formData['ppirGroupAddress']),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Divider()),
              _buildFormField('Lender Name', formData['ppirLenderName']),
              _buildFormField('Lender Address', formData['ppirLenderAddress']),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Divider()),
              _buildFormField('Region', formData['serviceGroup']),
              _buildFormField('Location of Farm', formData['ppirFarmLoc']),
              _buildFormField('CIC No.', formData['ppirCicNo']),
            ]),
            _buildFormSection('Location Sketch Plan', [
              _buildFormField('North', formData['ppirNorth']),
              _buildFormField('East', formData['ppirEast']),
              _buildFormField('South', formData['ppirSouth']),
              _buildFormField('West', formData['ppirWest']),
            ]),
            _buildFormSection('Findings (Per ACI)', [
              _buildFormField('Area Planted', formData['ppirAreaAci']),
              _buildFormField(
                  'Date of Planting (DS)', formData['ppirDopdsAci']),
              _buildFormField(
                  'Date of Planting (TP)', formData['ppirDoptpAci']),
              _buildFormField('Seed Variety Planted', formData['ppirVariety']),
            ]),
            _buildFormSection('Tracking Results', [
              _buildFormField('Last Coordinates', widget.task.csvData?['trackLastcoord']),
              _buildFormField('Date and Time', widget.task.csvData?['trackDatetime']),
              _buildFormField('Total Area (Hectares)', widget.task.csvData?['trackTotalarea']),
              _buildFormField('Total Distance', widget.task.csvData?['trackTotalDistance']),
            ]),
            _buildFormSection('Actual Details', [
              _buildFormField('Last Coordinates', widget.task.csvData?['ppirAreaAct']),
              _buildFormField('Seed Variety', widget.task.csvData?['ppirVariety']),
              _buildFormField('Actual Date of Planting (DS)', widget.task.csvData?['ppirDopdsAct']),
              _buildFormField('Actual Date of Planting (TP)', widget.task.csvData?['ppirDoptpAct']),
              _buildFormField('Remarks', widget.task.csvData?['ppirRemarks']),
            ]),
            _buildFormSection('Assignees', [
              _buildFormField('Confirmed By', widget.task.csvData?['ppirNameInsured']),
              _buildFormField('Prepare By', widget.task.csvData?['ppirNameIuia']),
            ]),
          ],
        ),
      ),
    );
  }
}


// Tracking Results
// Last Coordinates: trackLastcoord
// Date and Time: trackDatetime
// Total Area (Hectares): trackTotalarea
// Total Distance: trackTotalDistance
//
// Land Details
// Actual Area Planted: ppirAreaAct
// Seed Variety: ppirVariety
// Actual Date of Planting (DS): ppirDopdsAct
// Actual Date of Planting (TP): ppirDoptpAct
// Remarks: ppirRemarks
//
// Assignees
// Confirmed By: ppirNameInsured
// // ppirSigIuia - blob
// Prepare By: ppirNameIuia
// // ppirSigInsured - blob