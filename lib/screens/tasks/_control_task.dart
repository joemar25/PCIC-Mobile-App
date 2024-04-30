// file: control_task.dart
import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

class TaskManager {
  final int id;
  final DateTime dateAdded;
  final DateTime dateAccess;
  final int ppirAssignmentId;
  final int ppirInsuranceId;
  Map<String, dynamic>? csvData;
  Map<String, dynamic>? originalCsvData;
  bool isCompleted;
  bool hasChanges = false;

  TaskManager({
    required this.id,
    this.isCompleted = false,
    required this.dateAdded,
    required this.dateAccess,
    required this.ppirAssignmentId,
    required this.ppirInsuranceId,
    this.csvData,
  });

  void setCompleted(bool value) {
    isCompleted = value;
  }

  Map<String, bool> getColumnStatus() {
    Map<String, bool> columnStatus = {};
    csvData?.forEach((key, value) {
      columnStatus[key] = value != null && value.toString().isNotEmpty;
    });
    return columnStatus;
  }

  factory TaskManager.fromMap(Map<String, dynamic> map) {
    return TaskManager(
      id: map['id'],
      isCompleted: map['isCompleted'],
      dateAdded: _parseDate(map['dateAdded']),
      dateAccess: _parseDate(map['dateAccess']),
      ppirAssignmentId: map['ppir_assignmentid'],
      ppirInsuranceId: map['ppir_insuranceid'],
    );
  }

  static DateTime _parseDate(dynamic dateString) {
    if (dateString is String && dateString.length == 6) {
      try {
        final int month = int.parse(dateString.substring(0, 2));
        final int day = int.parse(dateString.substring(2, 4));
        final int year = int.parse(dateString.substring(4, 6)) + 2000;
        return DateTime(year, month, day);
      } catch (e) {
        debugPrint('Error parsing date: $e');
      }
    }
    // Return current date if parsing fails
    return DateTime.now();
  }

  static Future<List<TaskManager>> getAllTasks() async {
    Future<List<String>> getAssetPaths(String folderPath) async {
      // Load the AssetManifest.json file as a string
      String manifestContent =
          await rootBundle.loadString('AssetManifest.json');

      // Parse the JSON string to extract asset paths
      Map<String, dynamic> manifestMap = json.decode(manifestContent);

      List<String> assetPaths = manifestMap.keys
          .where((key) => key.startsWith("assets/storage/mergedtask/"))
          .toList();

      return assetPaths;
    }

    Future<List<List<dynamic>>> mergeCSVsFromAssets(String folderPath) async {
      // Get the list of asset paths
      List<String> assetPaths = await getAssetPaths(folderPath);

      // Create a List to store the contents of all CSV files
      List<List<dynamic>> combinedContents = [];

      // Iterate through each CSV file
      for (String assetPath in assetPaths) {
        // Read the CSV file as a String from the asset bundle
        String csvString = await rootBundle.loadString(assetPath);

        // Parse the CSV string into a 2D List of dynamic values
        List<List<dynamic>> csvTable =
            const CsvToListConverter().convert(csvString);

        // Exclude the first row (header) of each CSV file
        List<List<dynamic>> dataWithoutHeader = csvTable.sublist(1);

        // Append the remaining rows to the combined contents
        combinedContents.addAll(dataWithoutHeader);
      }

      // Write the combined contents to a new CSV file
      // print(combinedContents[5]);
      return combinedContents;
    }

    List<TaskManager> tasks = [];

    try {
      // Load the original CSV data
      String folderPath = '/assets/storage/mergedtask';
      await mergeCSVsFromAssets(folderPath);
      List<List<dynamic>> csvList = await mergeCSVsFromAssets(folderPath);

      // Create a map to store the CSV data with ppir_insuranceid as the key
      Map<String, Map<String, dynamic>> csvDataMap = {};
      for (List<dynamic> row in csvList) {
        // Skip the header row
        String ppirInsuranceId = row[7].toString();
        csvDataMap[ppirInsuranceId] = {
          // Convert all values to strings
          'serviceGroup': row[1],
          'serviceType': row[2],
          'priority': row[3],
          'taskStatus': row[4],
          'assignee': row[5],
          'ppirAssignmentId': row[6],
          'ppirInsuranceId': row[7],
          'ppirFarmerName': row[8],
          'ppirAddress': row[9],
          'ppirFarmerType': row[10],
          'ppirMobileNo': row[11],
          'ppirGroupName': row[12],
          'ppirGroupAddress': row[13],
          'ppirLenderName': row[14],
          'ppirLenderAddress': row[15],
          'ppirCicNo': row[16],
          'ppirFarmLoc': row[17],
          'ppirNorth': row[18],
          'ppirSouth': row[19],
          'ppirEast': row[20],
          'ppirWest': row[21],
          'ppirAtt1': row[22],
          'ppirAtt2': row[23],
          'ppirAtt3': row[24],
          'ppirAtt4': row[25],
          'ppirAreaAci': row[26],
          'ppirAreaAct': row[27],
          'ppirDopdsAci': row[28],
          'ppirDopdsAct': row[29],
          'ppirDoptpAci': row[30],
          'ppirDoptpAct': row[31],
          'ppirSvpAci': row[32],
          'ppirSvpAct': row[33],
          'ppirVariety': row[34],
          'ppirStagecrop': row[35],
          'ppirRemarks': row[36],
          'ppirNameInsured': row[37],
          'ppirNameIuia': row[38],
          'ppirSigInsured': row[39],
          'ppirSigIuia': row[40],
        };
      }

      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref().child('tasks');
      DatabaseEvent event = await databaseReference.once();
      DataSnapshot dataSnapshot = event.snapshot;

      if (dataSnapshot.value != null) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> values =
              dataSnapshot.value as Map<dynamic, dynamic>;
          // print(values);
          values.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              Map<String, dynamic> taskData = Map<String, dynamic>.from(value);
              TaskManager task = TaskManager.fromMap(taskData);

              // Retrieve the CSV data for the task based on its ppirInsuranceId
              String ppirInsuranceId = task.ppirInsuranceId.toString();
              if (csvDataMap.containsKey(ppirInsuranceId)) {
                task.originalCsvData = csvDataMap[ppirInsuranceId];
                task.csvData = Map<String, dynamic>.from(task.originalCsvData!);
              }

              tasks.add(task);
            }
          });

          // Upload to db if not existing

          // Get list of all ppid in db
          List<String> insuranceinDB = [];
          values.forEach((key, value) =>
              (insuranceinDB.add(value["ppir_insuranceid"].toString())));

          csvDataMap.forEach((key, value) {
            if (!insuranceinDB.contains(key)) {
              // DB data structure

              databaseReference.child('task-$key').set({
                "ppir_assignmentid": value["ppirAssignmentId"],
                "ppir_insuranceid": int.parse(key),
                "id": 0,
                "isCompleted": false,
                "dateAdded": DateTime.now().toString(),
                "dateAccess": DateTime.now().toString(),
              });
            }
          });
        }
      }
    } catch (error) {
      debugPrint('Error retrieving tasks from Firebase: $error');
    }

    return tasks;
  }

  void updateCsvData(Map<String, dynamic> newData) {
    csvData ??= {};
    newData.forEach((key, value) {
      if (value.toString().isNotEmpty) {
        csvData![key] = value;
      }
    });
    hasChanges = true;
  }

  void updateColumnStatus(Map<String, bool> newColumnStatus) {
    csvData ??= {};
    newColumnStatus.forEach((key, value) {
      if (!value) {
        csvData![key] = '';
      }
    });
    hasChanges = true;
  }

  Future<void> saveXmlData(String serviceType, int ppirInsuranceId) async {
    if (csvData != null) {
      try {
        final filePath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS,
        );

        final downloadsDirectory = Directory(filePath);

        // final serviceType = task.csvData?['serviceType'] ?? 'Service Group';
        // final idMapping = {serviceType: widget.task.ppirInsuranceId};
        final idMapping = {serviceType: ppirInsuranceId};

        // Provide a default if no mapping exists
        final mappedId = idMapping[serviceType] ?? '000000';

        final baseFilename =
            '${serviceType.replaceAll(' ', ' - ')}_${serviceType.replaceAll(' ', '_')}_$mappedId';

        final insuranceDirectory =
            Directory('${downloadsDirectory.path}/$baseFilename');

        // Create the insurance directory if it doesn't exist
        if (!await insuranceDirectory.exists()) {
          await insuranceDirectory.create(recursive: true);
        }

        // Define the Attachments directory inside the insurance directory
        final taskDirectory = Directory(insuranceDirectory.path);

        // Create the Attachments directory if it doesn't exist
        if (!await taskDirectory.exists()) {
          await taskDirectory.create(recursive: true);
        }

        final xmlFile = File('${taskDirectory.path}/Task.xml');

        // Create the XML builder
        final builder = XmlBuilder();

        // Start building the XML
        builder.processing('xml', 'version="1.0" encoding="UTF-8"');
        builder.element('task', nest: () {
          builder.element('taskManagerNumber',
              nest: originalCsvData!['taskManagerNumber'] ?? '');
          builder.element('serviceGroup', nest: csvData!['serviceGroup'] ?? '');
          builder.element('serviceType', nest: csvData!['serviceType'] ?? '');
          builder.element('priority', nest: csvData!['priority'] ?? '');
          builder.element('taskManagerStatus',
              nest: csvData!['taskStatus'] ?? '');
          builder.element('assignee', nest: csvData!['assignee'] ?? '');
          builder.element('ppirAssignmentid',
              nest: csvData!['ppirAssignmentId'] ?? '');
          builder.element('ppirInsuranceid',
              nest: csvData!['ppirInsuranceId'] ?? '');
          builder.element('ppirFarmername',
              nest: csvData!['ppirFarmerName'] ?? '');
          builder.element('ppirAddress', nest: csvData!['ppirAddress'] ?? '');
          builder.element('ppirFarmertype',
              nest: csvData!['ppirFarmerType'] ?? '');
          builder.element('ppirMobileno', nest: csvData!['ppirMobileNo'] ?? '');
          builder.element('ppirGroupname',
              nest: csvData!['ppirGroupName'] ?? '');
          builder.element('ppirGroupaddress',
              nest: csvData!['ppirGroupAddress'] ?? '');
          builder.element('ppirLendername',
              nest: csvData!['ppirLenderName'] ?? '');
          builder.element('ppirLenderaddress',
              nest: csvData!['ppirLenderAddress'] ?? '');
          builder.element('ppirCicno', nest: csvData!['ppirCicNo'] ?? '');
          builder.element('ppirFarmloc', nest: csvData!['ppirFarmLoc'] ?? '');
          builder.element('ppirNorth', nest: csvData!['ppirNorth'] ?? '');
          builder.element('ppirSouth', nest: csvData!['ppirSouth'] ?? '');
          builder.element('ppirEast', nest: csvData!['ppirEast'] ?? '');
          builder.element('ppirWest', nest: csvData!['ppirWest'] ?? '');
          builder.element('ppirAtt1', nest: csvData!['ppirAtt1'] ?? '');
          builder.element('ppirAtt2', nest: csvData!['ppirAtt2'] ?? '');
          builder.element('ppirAtt3', nest: csvData!['ppirAtt3'] ?? '');
          builder.element('ppirAtt4', nest: csvData!['ppirAtt4'] ?? '');
          builder.element('ppirAreaAci', nest: csvData!['ppirAreaAci'] ?? '');
          builder.element('ppirAreaAct', nest: csvData!['ppirAreaAct'] ?? '');
          builder.element('ppirDopdsAci', nest: csvData!['ppirDopdsAci'] ?? '');
          builder.element('ppirDopdsAct', nest: csvData!['ppirDopdsAct'] ?? '');
          builder.element('ppirDoptpAci', nest: csvData!['ppirDoptpAci'] ?? '');
          builder.element('ppirDoptpAct', nest: csvData!['ppirDoptpAct'] ?? '');
          builder.element('ppirSvpAci', nest: csvData!['ppirSvpAci'] ?? '');
          builder.element('ppirSvpAct', nest: csvData!['ppirSvpAct'] ?? '');
          builder.element('ppirVariety', nest: csvData!['ppirVariety'] ?? '');
          builder.element('ppirStagecrop',
              nest: csvData!['ppirStagecrop'] ?? '');
          builder.element('ppirRemarks', nest: csvData!['ppirRemarks'] ?? '');
          builder.element('ppirNameInsured',
              nest: csvData!['ppirNameInsured'] ?? '');

          builder.element('ppirNameIuia', nest: csvData!['ppirNameIuia'] ?? '');
          builder.element('ppirSigInsured',
              nest: csvData!['ppirSigInsured'] ?? '');
          builder.element('ppirSigIuia', nest: csvData!['ppirSigIuia'] ?? '');

          builder.element('trackTotalarea',
              nest: csvData!['trackTotalarea'] ?? '');
          builder.element('trackDatetime',
              nest: csvData!['trackDatetime'] ?? '');
          builder.element('trackLastcoord',
              nest: csvData!['trackLastcoord'] ?? '');
          builder.element('trackTotaldistance',
              nest: csvData!['trackTotaldistance'] ?? '');
        });

        // Generate the XML string
        final xmlString = builder.buildDocument().toXmlString(pretty: true);

        // Write the XML string to the file
        await xmlFile.writeAsString(xmlString);

        debugPrint('XML file saved: ${xmlFile.path}');
      } catch (error) {
        debugPrint('Error saving XML data: $error');
      }
    }
  }

  void debugPrintCsvData() {
    debugPrint('Current CSV Data:');
    csvData?.forEach((key, value) {
      if (value is String || value is int || value is double || value is bool) {
        debugPrint('$key: $value');
      } else {
        debugPrint('$key: Unsupported data type');
      }
    });
  }
}
