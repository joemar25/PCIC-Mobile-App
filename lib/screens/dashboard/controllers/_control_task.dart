import 'package:flutter/foundation.dart';

class Task {
  final int id;
  final String title;
  final String description;
  late final bool isCompleted;
  final DateTime dateAdded;
  final String geotaggedPhoto;
  final Map<String, dynamic> formData;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.dateAdded,
    required this.geotaggedPhoto,
    required this.formData,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dateAdded': dateAdded.toIso8601String(),
      'geotaggedPhoto': geotaggedPhoto,
      'formData': formData,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      dateAdded: DateTime.parse(map['dateAdded']),
      geotaggedPhoto: map['geotaggedPhoto'],
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
        title: 'Task 1 - Woop Woop',
        description: 'Finish math assignment and submit it online.',
        isCompleted: false,
        dateAdded: DateTime(2023, 6, 1),
        geotaggedPhoto: '',
        formData: {},
      ),
      Task(
        id: 2,
        title: 'Task 2 - ABC Woop',
        description: 'Buy fruits, vegetables, and milk.',
        isCompleted: false,
        dateAdded: DateTime.now().subtract(const Duration(days: 4)),
        geotaggedPhoto: '',
        formData: {},
      ),
      Task(
        id: 3,
        title: 'Task 3 - aa bbbbaa',
        description: 'Talk to mom about the weekend plans.',
        isCompleted: true,
        dateAdded: DateTime.now().subtract(const Duration(days: 2)),
        geotaggedPhoto: '',
        formData: {},
      ),
      Task(
        id: 4,
        title: 'Task 4 - bbb ccc',
        description: 'Weekend plans are ruin!',
        isCompleted: true,
        dateAdded: DateTime.now().subtract(const Duration(days: 2)),
        geotaggedPhoto: '',
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
      title: title,
      description: description,
      dateAdded: DateTime.now(),
      geotaggedPhoto: geotaggedPhoto,
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
