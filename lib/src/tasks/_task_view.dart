// filename: _task_view.dart
import 'package:flutter/material.dart';
import '../home/_recent_task_data.dart';
import '_control_task.dart';
import '_task_details.dart';
import '../home/_search_button.dart';
import '_task_filter_button.dart';
import '_task_filter_footer.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key, required this.tasks, required this.initialFilter});

  final List<TaskManager> tasks;
  final String initialFilter;

  @override
  TaskContainerState createState() => TaskContainerState();
}

class TaskContainerState extends State<TaskView> {
  int _hoveredIndex = -1;
  String _sortBy = 'Date Added';
  late String _statusFilter;
  String _searchQuery = '';
  bool _isLoading = false;
  List<TaskManager> _sortedTasks = [];

  @override
  void initState() {
    super.initState();
    _statusFilter = widget.initialFilter;
    _sortTasks(_sortBy);
  }

  void _updateStatusFilter(String newValue) {
    setState(() {
      _statusFilter = newValue;
    });
    _sortTasks(_sortBy);
  }

  void _updateSortBy(String newValue) {
    setState(() {
      _sortBy = newValue;
    });
    _sortTasks(newValue);
  }

  void _updateSearchQuery(String newValue) {
    setState(() {
      _searchQuery = newValue;
    });
  }

  Future<void> _sortTasks(String sortBy) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<TaskManager> sortedTasks;

      if (_statusFilter == 'Ongoing') {
        sortedTasks = await TaskManager.getTasksByStatus('Ongoing');
      } else if (_statusFilter == 'For Dispatch') {
        sortedTasks = await TaskManager.getTasksByStatus('For Dispatch');
      } else if (_statusFilter == 'Completed') {
        sortedTasks = await TaskManager.getTasksByStatus('Completed');
      } else {
        sortedTasks = await TaskManager.getAllTasks();
      }

      setState(() {
        _sortedTasks = sortedTasks;
      });

      debugPrint('Sorted Tasks: ${_sortedTasks.length}'); // Debugging statement
    } catch (error) {
      debugPrint("Error sorting tasks: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TaskManager> tasksToDisplay = _isLoading ? [] : _sortedTasks;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilterButton(
                      onUpdateState: _updateStatusFilter,
                      onUpdateValue: _updateSortBy,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: SearchButton(onUpdateValue: _updateSearchQuery),
                    ),
                  ],
                ),
                FilterFooter(
                  filter: _statusFilter,
                  orderBy: _sortBy,
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshTasks,
              child: tasksToDisplay.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasksToDisplay.length,
                      itemBuilder: (context, index) {
                        final task = tasksToDisplay[index];

                        bool matchesSearchQuery = _searchQuery.isEmpty ||
                            task.taskId
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase());

                        if (!matchesSearchQuery) {
                          return const SizedBox.shrink();
                        }

                        return MouseRegion(
                          onEnter: (_) => setState(() => _hoveredIndex = index),
                          onExit: (_) => setState(() => _hoveredIndex = -1),
                          child: GestureDetector(
                            onTap: () => _navigateToTaskDetails(context, task),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 21.0),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5, color: Colors.black38),
                                  color: _hoveredIndex == index
                                      ? Colors.grey[200]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xFF0F7D40),
                                      offset: Offset(-5, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TaskData(task: task),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshTasks() async {
    await Future.delayed(const Duration(seconds: 1));
    _sortTasks(_sortBy);
  }

  void _navigateToTaskDetails(BuildContext context, TaskManager task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailsPage(task: task)),
    );
  }
}
