import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_geotag.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/tasks_components/_task_container.dart'; // Import the TaskContainer widget

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> _tasks = []; // Initialize an empty list of tasks

  @override
  void initState() {
    super.initState();
    _fetchTasks(); // Fetch tasks when the page initializes
  }

  Future<void> _fetchTasks() async {
    try {
      List<Task> tasks = await Task.getAllTasks(); // Fetch all tasks
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
        title: const Text('Tasks'),
      ),
      body: _tasks.isNotEmpty
          ? TaskContainer(tasks: _tasks)
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
