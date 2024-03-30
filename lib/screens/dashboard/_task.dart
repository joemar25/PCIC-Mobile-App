import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/_job_start.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_task_add.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_task_details.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Map<String, dynamic>> tasks = [
    {
      'id': 1,
      'title': 'Task 1',
      'description': 'Description of task 1',
      'isCompleted': false,
    },
    {
      'id': 2,
      'title': 'Task 2',
      'description': 'Description of task 2',
      'isCompleted': true,
    },
    {
      'id': 3,
      'title': 'Task 3',
      'description': 'Description of task 3',
      'isCompleted': false,
    },
  ];

  List<Map<String, dynamic>> upcomingTasks = [];
  List<Map<String, dynamic>> completedTasks = [];

  bool _showUpcomingTasks = true;

  void _separateTasks() {
    upcomingTasks = tasks.where((task) => !task['isCompleted']).toList();
    completedTasks = tasks.where((task) => task['isCompleted']).toList();
  }

  void _toggleTaskView() {
    setState(() {
      _showUpcomingTasks = !_showUpcomingTasks;
    });
  }

  @override
  void initState() {
    super.initState();
    _separateTasks();
  }

  void _navigateToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    );
  }

  void _navigateToTaskDetails(Map<String, dynamic> task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(taskId: task['id']),
      ),
    );
  }

  void _navigateToJobPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JobPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        _toggleTaskView();
                      },
                      child: Text(
                        'Upcoming Tasks',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: _showUpcomingTasks ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        _toggleTaskView();
                      },
                      child: Text(
                        'Completed Tasks',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color:
                              !_showUpcomingTasks ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                _showUpcomingTasks
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: upcomingTasks.length,
                        itemBuilder: (context, index) {
                          final task = upcomingTasks[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: ListTile(
                              title: Text(task['title']),
                              subtitle: Text(task['description']),
                              trailing: ElevatedButton(
                                onPressed: () => _navigateToTaskDetails(task),
                                child: const Text('View Details'),
                              ),
                              onTap: () => _navigateToTaskDetails(task),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: completedTasks.length,
                        itemBuilder: (context, index) {
                          final task = completedTasks[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: ListTile(
                              title: Text(task['title']),
                              subtitle: Text(task['description']),
                              trailing: ElevatedButton(
                                onPressed: () => _navigateToTaskDetails(task),
                                child: const Text('View Details'),
                              ),
                              onTap: () => _navigateToTaskDetails(task),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToJobPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
