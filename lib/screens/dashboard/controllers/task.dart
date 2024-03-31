class Task {
  int id;
  String title;
  String description;
  bool isCompleted;
  DateTime dateAdded;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        isCompleted = map['isCompleted'],
        dateAdded = DateTime.parse(map['dateAdded']);

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
        dateAdded: DateTime(2023, 6, 1), // DateTime.now(),
      ),
      Task(
        id: 2,
        title: 'Task 2 - ABC Woop',
        description: 'Buy fruits, vegetables, and milk.',
        isCompleted: false,
        dateAdded: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Task(
        id: 3,
        title: 'Task 3 - aa bbbbaa',
        description: 'Talk to mom about the weekend plans.',
        isCompleted: true,
        dateAdded: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}
