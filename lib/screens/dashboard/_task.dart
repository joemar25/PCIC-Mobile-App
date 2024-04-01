import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pcic_mobile_app/screens/dashboard/controllers/_control_task.dart';
import 'package:pcic_mobile_app/screens/dashboard/controllers/_filter_task.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_task_details.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> tasks = Task.getAllTasks();
  List<Task> filteredTasks = [];

  bool _isUpcomingTasksSelected = true;
  String _searchQuery = '';
  bool _sortEarliest = true;

  @override
  void initState() {
    super.initState();
    _loadFilters();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postFrameCallback();
    });
  }

  void _postFrameCallback() {
    _filterTasksAsync();
  }

  void _loadFilters() {
    final filters =
        Provider.of<TaskFiltersNotifier>(context, listen: false).filters;
    setState(() {
      _isUpcomingTasksSelected = filters.isUpcomingTasksSelected;
      _searchQuery = filters.searchQuery;
      _sortEarliest = filters.sortEarliest;
    });
  }

  Future<void> _filterTasksAsync() async {
    final filteredList = tasks
        // .where((task) =>
        // task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        // task.description.toLowerCase().contains(_searchQuery.toLowerCase()))
        .where((task) =>
            _isUpcomingTasksSelected ? !task.isCompleted : task.isCompleted)
        .toList();

    filteredList.sort((a, b) {
      if (_sortEarliest) {
        return a.dateAdded.compareTo(b.dateAdded);
      } else {
        return b.dateAdded.compareTo(a.dateAdded);
      }
    });

    setState(() {
      filteredTasks = filteredList;
    });

    Provider.of<TaskFiltersNotifier>(context, listen: false).updateFilters(
      TaskFilters(
        isUpcomingTasksSelected: _isUpcomingTasksSelected,
        searchQuery: _searchQuery,
        sortEarliest: _sortEarliest,
      ),
    );
  }

  void _toggleTaskView() {
    setState(() {
      _isUpcomingTasksSelected = !_isUpcomingTasksSelected;
    });
    _filterTasksAsync();
  }

  void _navigateToTaskDetails(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _filterTasksAsync();
              },
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sort by:'),
                DropdownButton<bool>(
                  value: _sortEarliest,
                  onChanged: (value) {
                    setState(() {
                      _sortEarliest = value!;
                    });
                    _filterTasksAsync();
                  },
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Earliest')),
                    DropdownMenuItem(value: false, child: Text('Latest')),
                  ],
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
                          task.id.toString(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        // subtitle: Text(
                        //   '${task.description}\nDate Added: ${DateFormat('MMM d, yyyy').format(task.dateAdded)}',
                        //   maxLines: 2,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _navigateToTaskDetails(task),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ),
          ),
        ],
      ),
    );
  }
}
