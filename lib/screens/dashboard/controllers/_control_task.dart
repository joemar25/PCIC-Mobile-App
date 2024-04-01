import 'package:flutter/foundation.dart';

class Task {
  final int id;
  late final bool isCompleted;
  final DateTime dateAdded;
  final DateTime dateAccess;
  // final String geotaggedPhoto;
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
      // 'geotaggedPhoto': geotaggedPhoto,
      'formData': formData,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      isCompleted: map['isCompleted'],
      dateAdded: DateTime.parse(map['dateAdded']),
      dateAccess: DateTime.parse(map['dateAccess']),
      // geotaggedPhoto: map['geotaggedPhoto'],
      formData: Map<String, dynamic>.from(map['formData']),
    );
  }

  // Getter to retrieve all tasks
  static List<Task> getAllTasks() {
    // Here you can fetch tasks from a database or some other storage mechanism.
    // For the sake of example, let's return a hardcoded list of tasks.
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

  static void addTask({
    required String title,
    required String description,
    required String geotaggedPhoto,
    required Map<String, dynamic> formData,
  }) {
    // Generate a new task ID
    int newTaskId = getAllTasks().length + 1;

    // Create a new task instance
    Task newTask = Task(
      id: newTaskId,
      dateAdded: DateTime.now(),
      dateAccess: DateTime.now(),
      // geotaggedPhoto: geotaggedPhoto,
      formData: formData,
    );

    // Here you can save the new task to a database or some other storage mechanism.
    // For the sake of example, let's print a message.
    debugPrint('Adding new task: ${newTask.toMap()}');
  }

  static void doTask(Task task) {
    // Here you can perform actions related to doing the task.
    // For the sake of example, let's print a message.
    debugPrint('Doing task: ${task.toMap()}');
  }
}
