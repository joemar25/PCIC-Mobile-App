// filename: _task_details.dart
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';
import 'package:pcic_mobile_app/screens/geotag/_geotag.dart';

class TaskDetailsPage extends StatefulWidget {
  final TaskManager task;
  const TaskDetailsPage({super.key, required this.task});

  @override
  TaskDetailsPageState createState() => TaskDetailsPageState();
}

class TaskDetailsPageState extends State<TaskDetailsPage> {
  Map<String, String> formData = {};
  Map<String, bool> columnStatus = {};

  @override
  void initState() {
    super.initState();
    _initializeFormData();
    _initializeColumnStatus();
  }

  String _convertServiceGroupToRoman(String? serviceCode) {
    if (serviceCode == null) return '';
    // map of service codes to Roman numerals
    const romanMap = {
      'P01': 'I',
      'P02': 'II',
      'P03': 'III',
      'P04': 'IV',
      'P05': 'V',
      'P06': 'VI',
    };
    // return default to original code if not found in map
    return romanMap[serviceCode] ?? serviceCode;
  }

  void _initializeFormData() {
    // function to convert 'serviceGroup' to Roman numeral
    formData = widget.task.csvData?.map((key, value) {
          if (key == 'serviceGroup') {
            return MapEntry(key, _convertServiceGroupToRoman(value));
          }
          return MapEntry(key, value?.toString() ?? '');
        }) ??
        {};
  }

  void _initializeColumnStatus() {
    columnStatus = widget.task.getColumnStatus();
  }

  void _navigateToGeotagPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GeotagPage(task: widget.task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskManager Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormFields(),
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: _navigateToGeotagPage,
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  child: Text(
                    'Go to Geotag',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPostPlantingInspectionReport(),
        _buildLocationSketchPlanFormField(),
        _buildFindingsPerAci(),
      ],
    );
  }

  Widget _buildPostPlantingInspectionReport() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'POST PLANTING INSPECTION REPORT',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16.0),
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
        ],
      ),
    );
  }

  Widget _buildLocationSketchPlanFormField() {
    widget.task.debugPrintCsvData();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Location of Sketch Plan:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormField('North', formData['ppirNorth']),
                      _buildFormField('East', formData['ppirEast']),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormField('South', formData['ppirSouth']),
                      _buildFormField('West', formData['ppirWest']),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFindingsPerAci() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Findings (Per ACI):',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildFormField('Area Planted', formData['ppirAreaAci']),
          _buildFormField('Date of Planting (DS)', formData['ppirDopdsAci']),
          _buildFormField('Date of Planting (TS)', formData['ppirDoptpAci']),
          _buildFormField('Seed Variety Planted', formData['ppirVariety']),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, String? value) {
    // Replace empty values with 'test'
    final displayValue = value?.isNotEmpty ?? false ? value : 'test';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: displayValue,
              enabled: false, // Disable editing
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
