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
  String _initialFilter = 'Ongoing';

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      List<TaskManager> ongoingTasks =
          await TaskManager.getTasksByStatus('Ongoing');
      if (ongoingTasks.isNotEmpty) {
        setState(() {
          _tasks = ongoingTasks;
          _initialFilter = 'Ongoing';
        });
      } else {
        List<TaskManager> forDispatchTasks =
            await TaskManager.getTasksByStatus('For Dispatch');
        if (forDispatchTasks.isNotEmpty) {
          setState(() {
            _tasks = forDispatchTasks;
            _initialFilter = 'For Dispatch';
          });
        } else {
          List<TaskManager> completedTasks =
              await TaskManager.getTasksByStatus('Completed');
          setState(() {
            _tasks = completedTasks;
            _initialFilter = 'Completed';
          });
        }
      }
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
          : TaskView(tasks: _tasks, initialFilter: _initialFilter),
    );
  }
}
