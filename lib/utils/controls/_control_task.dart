import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class Task {
  final int id;
  late final bool isCompleted;
  final DateTime dateAdded;
  final DateTime dateAccess;
  final Map<String, dynamic> formData;

  Task({
    required this.id,
    this.isCompleted = false,
    required this.dateAdded,
    required this.dateAccess,
    required this.formData,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isCompleted': isCompleted,
      'dateAdded': dateAdded.toIso8601String(),
      'dateAccess': dateAdded.toIso8601String(),
      'formData': formData,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      isCompleted: map['isCompleted'],
      dateAdded: DateTime.parse(map['dateAdded']),
      dateAccess: DateTime.parse(map['dateAccess']),
      formData: Map<String, dynamic>.from(map['formData']),
    );
  }

  static Future<List<Task>> getAllTasks() async {
    // List<Task> tasks = [];

    // try {
    //   DatabaseReference databaseReference =
    //       FirebaseDatabase.instance.reference().child('agents');

    //   DatabaseEvent event = await databaseReference.once();
    //   DataSnapshot dataSnapshot = event.snapshot;

    //   if (dataSnapshot.value != null) {
    //     Map<String, dynamic> values =
    //         dataSnapshot.value as Map<String, dynamic>;

    //     values.forEach((key, value) {
    //       Map<String, dynamic> taskData = Map<String, dynamic>.from(value);
    //       taskData['id'] = int.parse(key);
    //       Task task = Task.fromMap(taskData);
    //       tasks.add(task);
    //     });
    //   }
    // } catch (error) {
    //   debugPrint('Error retrieving tasks from Firebase: $error');
    // }

    // return tasks;

    return [
      Task(
        id: 1,
        isCompleted: false,
        dateAdded: DateTime(2023, 6, 1),
        dateAccess: DateTime(2023, 6, 1),
        // geotaggedPhoto: '',
        formData: {},
      ),
      Task(
        id: 2,
        isCompleted: false,
        dateAdded: DateTime.now().subtract(const Duration(days: 4)),
        dateAccess: DateTime.now().subtract(const Duration(days: 4)),
        // geotaggedPhoto: '',
        formData: {},
      ),
      Task(
        id: 3,
        isCompleted: true,
        dateAdded: DateTime.now().subtract(const Duration(days: 2)),
        dateAccess: DateTime.now().subtract(const Duration(days: 2)),
        // geotaggedPhoto: '',
        formData: {},
      ),
      Task(
        id: 4,
        isCompleted: true,
        dateAdded: DateTime.now().subtract(const Duration(days: 2)),
        dateAccess: DateTime.now().subtract(const Duration(days: 2)),
        // geotaggedPhoto: '',
        formData: {},
      ),
    ];
  }
}
