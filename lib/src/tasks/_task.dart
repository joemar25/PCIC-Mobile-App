// filename: _task.dart
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';
import '../home/dashboard.dart';
import 'controllers/task_manager.dart';
import 'components/_task_view.dart';
import 'package:lottie/lottie.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, this.initialFilter = 'Ongoing'});
  final String initialFilter;

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  List<TaskManager> _tasks = [];
  String _initialFilter = 'Ongoing';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      List<TaskManager> tasks;

      if (widget.initialFilter == 'Completed') {
        tasks = await TaskManager.getTasksByStatus('Completed');
        setState(() {
          _tasks = tasks;
          _initialFilter = 'Completed';
        });
      } else {
        tasks = await TaskManager.getTasksByStatus('Ongoing');
        if (tasks.isNotEmpty) {
          setState(() {
            _tasks = tasks;
            _initialFilter = 'Ongoing';
          });
        } else {
          tasks = await TaskManager.getTasksByStatus('For Dispatch');
          setState(() {
            _tasks = tasks;
            _initialFilter = tasks.isNotEmpty ? 'For Dispatch' : 'Ongoing';
          });
        }
      }
    } catch (error) {
      debugPrint('Error fetching tasks: $error');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = _initialFilter == 'Completed' ? 'Completed Tasks' : 'Tasks';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _navigateToDashboard(context),
        ),
        iconTheme: const IconThemeData(
          color: mainColor,
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: mainColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/emptybox.json',
                        width: 500,
                        height: 500,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No ${_initialFilter.toLowerCase()} tasks available.',
                        style: const TextStyle(color: mainColor, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : TaskView(tasks: _tasks, initialFilter: _initialFilter),
    );
  }
}
