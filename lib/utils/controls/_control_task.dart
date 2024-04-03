import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Task {
  final int id;
  late final bool isCompleted;
  final DateTime dateAdded;
  final DateTime dateAccess;
  final int ppirAssignmentId;
  final int ppirInsuranceId;

  Task({
    required this.id,
    this.isCompleted = false,
    required this.dateAdded,
    required this.dateAccess,
    required this.ppirAssignmentId,
    required this.ppirInsuranceId,
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
              tasks.add(task);
            }
          });
        }
      }
    } catch (error) {
      debugPrint('Error retrieving tasks from Firebase: $error');
    }

    return tasks;

    // return [
    //   Task(
    //     id: 1,
    //     isCompleted: false,
    //     dateAdded: DateTime(2023, 6, 1),
    //     dateAccess: DateTime(2023, 6, 1),
    //     // geotaggedPhoto: '',
    //     formData: {},
    //   ),
    //   Task(
    //     id: 2,
    //     isCompleted: false,
    //     dateAdded: DateTime.now().subtract(const Duration(days: 4)),
    //     dateAccess: DateTime.now().subtract(const Duration(days: 4)),
    //     // geotaggedPhoto: '',
    //     formData: {},
    //   ),
    //   Task(
    //     id: 3,
    //     isCompleted: true,
    //     dateAdded: DateTime.now().subtract(const Duration(days: 2)),
    //     dateAccess: DateTime.now().subtract(const Duration(days: 2)),
    //     // geotaggedPhoto: '',
    //     formData: {},
    //   ),
    //   Task(
    //     id: 4,
    //     isCompleted: true,
    //     dateAdded: DateTime.now().subtract(const Duration(days: 2)),
    //     dateAccess: DateTime.now().subtract(const Duration(days: 2)),
    //     // geotaggedPhoto: '',
    //     formData: {},
    //   ),
    // ];
  }
}
