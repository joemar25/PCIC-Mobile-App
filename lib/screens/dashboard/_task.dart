import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_geotag.dart';
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

  bool _isUpcomingTasksSelected = true;
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
          .where((task) => _isUpcomingTasksSelected
              ? !task['isCompleted']
              : task['isCompleted'])
          .toList();
    });
  }

  void _toggleTaskView() {
    setState(() {
      _isUpcomingTasksSelected = !_isUpcomingTasksSelected;
      _filterTasks(_searchQuery);
    });
  }

  void _navigateToTaskDetails(Map<String, dynamic> task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(
          taskId: task['id'],
          isCompleted: task['isCompleted'],
        ),
      ),
    );
  }

  void _navigateToGeotagPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GeotagPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tasks',
              style: Theme.of(context).textTheme.titleLarge,
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
                Expanded(
                  child: TextButton(
                    onPressed:
                        _isUpcomingTasksSelected ? null : _toggleTaskView,
                    style: TextButton.styleFrom(
                      backgroundColor: _isUpcomingTasksSelected
                          ? Colors.blue.withOpacity(0.2)
                          : null,
                    ),
                    child: const Text('Upcoming'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextButton(
                    onPressed:
                        !_isUpcomingTasksSelected ? null : _toggleTaskView,
                    style: TextButton.styleFrom(
                      backgroundColor: !_isUpcomingTasksSelected
                          ? Colors.blue.withOpacity(0.2)
                          : null,
                    ),
                    child: const Text('Completed'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Text(
                      _isUpcomingTasksSelected
                          ? 'No upcoming tasks'
                          : 'No completed tasks',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return ListTile(
                        title: Text(
                          task['title'],
                          style: Theme.of(context).textTheme.titleLarge,
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
                    separatorBuilder: (context, index) => const Divider(),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToGeotagPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
