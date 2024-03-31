import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/_job_start.dart';
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

  List<Map<String, dynamic>> filteredTasks = [];

  bool _showUpcomingTasks = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filterTasks('');
  }

  void _filterTasks(String query) {
    setState(() {
      _searchQuery = query;
      filteredTasks = tasks
          .where((task) =>
              task['title'].toLowerCase().contains(query.toLowerCase()) ||
              task['description'].toLowerCase().contains(query.toLowerCase()))
          .where((task) =>
              _showUpcomingTasks ? !task['isCompleted'] : task['isCompleted'])
          .toList();
    });
  }

  void _toggleTaskView() {
    setState(() {
      _showUpcomingTasks = !_showUpcomingTasks;
      _filterTasks(_searchQuery);
    });
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tasks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: _filterTasks,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: _showUpcomingTasks ? null : _toggleTaskView,
                  child: Text(
                    'Upcoming',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: _showUpcomingTasks ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: !_showUpcomingTasks ? null : _toggleTaskView,
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: !_showUpcomingTasks ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.separated(
              itemCount: filteredTasks.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return ListTile(
                  title: Text(
                    task['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    task['description'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _navigateToTaskDetails(task),
                );
              },
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
