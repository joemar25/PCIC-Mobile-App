import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/geotag/_geotag.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';

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
      'P05': 'V',
      'P06': 'VI',
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
                  const TextStyle(fontWeight: FontWeight.w300, fontSize: 16.0)),
          Text(displayValue ?? '',
              style:
                  const TextStyle(fontSize: 19.2, fontWeight: FontWeight.w400)),
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
      appBar: AppBar(title: const Text('Task Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFormSection('Post Planting Inspection Report', [
              _buildFormField('Region', formData['serviceGroup']),
              _buildFormField('Farmer Name', formData['ppirFarmerName']),
              _buildFormField('Address', formData['ppirAddress']),
              _buildFormField('Type of Farmers', formData['ppirFarmerType']),
              _buildFormField('Mobile No.', formData['ppirMobileNo']),
              _buildFormField('Group Name', formData['ppirGroupName']),
              _buildFormField('Group Address', formData['ppirGroupAddress']),
              _buildFormField('Lender Name', formData['ppirLenderName']),
              _buildFormField('Lender Address', formData['ppirLenderAddress']),
              _buildFormField('CIC No.', formData['ppirCicNo']),
              _buildFormField('Location of Farm', formData['ppirFarmLoc']),
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
            ElevatedButton(
              onPressed: _navigateToGeotagPage,
              child:
                  const Text('Go to Geotag', style: TextStyle(fontSize: 16.0)),
            ),
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