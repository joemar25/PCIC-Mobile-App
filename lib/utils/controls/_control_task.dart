import 'package:csv/csv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Task {
  final int id;
  late final bool isCompleted;
  final DateTime dateAdded;
  final DateTime dateAccess;
  final int ppirAssignmentId;
  final int ppirInsuranceId;
  Map<String, dynamic>? csvData;

  Task({
    required this.id,
    this.isCompleted = false,
    required this.dateAdded,
    required this.dateAccess,
    required this.ppirAssignmentId,
    required this.ppirInsuranceId,
    this.csvData,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isCompleted': isCompleted,
      'dateAdded': dateAdded.toIso8601String(),
      'dateAccess': dateAccess.toIso8601String(),
      'ppir_assignmentid': ppirAssignmentId,
      'ppir_insuranceid': ppirInsuranceId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
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

  static Future<List<Task>> getAllTasks() async {
    List<Task> tasks = [];

    try {
      // Load the CSV data
      String csvData = await rootBundle
          .loadString('assets/storage/tasks/1706671193108371-1.csv');
      List<List<dynamic>> csvList = const CsvToListConverter().convert(csvData);

      // Create a map to store the CSV data with ppir_insuranceid as the key
      Map<String, Map<String, dynamic>> csvDataMap = {};
      for (List<dynamic> row in csvList) {
        String ppirInsuranceId = row[7].toString();
        csvDataMap[ppirInsuranceId] = {
          // Task Number
          'serviceGroup': row[1],
          'serviceType': row[2],
          'priority': row[3],
          'taskStatus': row[4],
          'assignee': row[5],
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
          // ppir_area_aci
          // ppir_area_act
          // ppir_dopds_aci
          // ppir_dopds_act
          // ppir_doptp_aci
          // ppir_doptp_act
          // ppir_svp_aci
          // ppir_svp_act
          // ppir_variety
          // ppir_stagecrop
          // ppir_remarks
          // ppir_name_insured
          // ppir_name_iuia
          // ppir_sig_insured
          // ppir_sig_iuia
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
          values.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              Map<String, dynamic> taskData = Map<String, dynamic>.from(value);
              Task task = Task.fromMap(taskData);

              // Retrieve the CSV data for the task based on its ppirInsuranceId
              String ppirInsuranceId = task.ppirInsuranceId.toString();
              if (csvDataMap.containsKey(ppirInsuranceId)) {
                task.csvData = csvDataMap[ppirInsuranceId];
              }

              tasks.add(task);
            }
          });
        }
      }
    } catch (error) {
      debugPrint('Error retrieving tasks from Firebase: $error');
    }

    return tasks;
  }
}
