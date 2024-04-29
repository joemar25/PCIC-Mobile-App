import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/tasks/_control_task.dart';
import 'package:pcic_mobile_app/screens/tasks/_task_view.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, Key? id});

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  List<TaskManager> _tasks = []; // Initialize an empty list of tasks

  @override
  void initState() {
    super.initState();
    _fetchTasks(); // Fetch tasks when the page initializes
  }

  Future<void> _fetchTasks() async {
    try {
      List<TaskManager> tasks =
          await TaskManager.getAllTasks(); // Fetch all tasks
      setState(() {
        _tasks = tasks; // Update the list of tasks
      });
    } catch (error) {
      debugPrint('Error fetching tasks: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Tasks',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 19.2, fontWeight: FontWeight.w600),
        ),
      ),
      body: _tasks.isNotEmpty
          ? TaskView(tasks: _tasks)
          : const Center(
              child: Text('No tasks'),
            ),
    );
  }
}
