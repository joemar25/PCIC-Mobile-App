import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/geotag/_geotag.dart';
import 'package:pcic_mobile_app/screens/tasks/_control_task.dart';

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
    return AnimatedSize(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 23.04, fontWeight: FontWeight.w300)),
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black.withOpacity(0.2), width: 1.0),
                    borderRadius: BorderRadius.circular(10)),
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
    final displayValue = value?.isNotEmpty ?? false ? value : 'test'; // N/A
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:',
              style:
                  const TextStyle(fontWeight: FontWeight.w300, fontSize: 14.0)),
          Text(displayValue ?? '',
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _debugPrintCsvData() {
    debugPrint('CSV Data:');
    formData.forEach((key, value) {
      debugPrint('$key: $value');
    });
  }

  void _navigateToGeotagPage() {
    _debugPrintCsvData(); // Debug CSV before navigating
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => GeotagPage(task: widget.task)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Task Details',
            textAlign: TextAlign.center,
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: _navigateToGeotagPage,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.location_solid,
                        color: Colors.black,
                      ),
                      Text(
                        'Go to Geotag',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


/**
 * 
 * 
 * 
 * 
 */