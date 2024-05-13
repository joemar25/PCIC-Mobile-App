// filename: _task.dart
import 'package:flutter/material.dart';
import '_control_task.dart';
import '_task_view.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, this.initialFilter = 'Ongoing'});
  final String initialFilter;

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  List<TaskManager> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      List<TaskManager> tasks = await TaskManager.getAllTasks();
      setState(() {
        _tasks = tasks;
      });
    } catch (error) {
      debugPrint('Error fetching tasks: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Tasks',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 19.2, fontWeight: FontWeight.w600),
        ),
      ),
      body: _tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(child: Text('No tasks'))
              : TaskView(tasks: _tasks, initialFilter: widget.initialFilter),
    );
  }
}
