// filename: _recent_task_container.dart
import 'package:flutter/material.dart';
import '../tasks/_control_task.dart';
import '../tasks/_task_details.dart';
import '_recent_task_data.dart';

class RecentTaskContainer extends StatefulWidget {
  final String searchQuery;
  final List<TaskManager> notCompletedTasks;

  const RecentTaskContainer({
    super.key,
    required this.notCompletedTasks,
    required this.searchQuery,
  });

  @override
  RecentTaskContainerState createState() => RecentTaskContainerState();
}

class RecentTaskContainerState extends State<RecentTaskContainer> {
  List<TaskManager> _notCompletedTasks = [];
  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();
    _fetchNotCompletedTasks();
  }

  Future<void> _fetchNotCompletedTasks() async {
    List<TaskManager> tasks = await TaskManager.getNotCompletedTasks();
    setState(() {
      _notCompletedTasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter the tasks based on the search query
    List<TaskManager> filteredTasks = _notCompletedTasks.where((task) {
      // Assuming `formId` and `taskId` are used for forming a service identifier
      String identifier = '${task.formId}-${task.taskId}'.toLowerCase();
      return widget.searchQuery.isEmpty ||
          identifier.contains(widget.searchQuery.toLowerCase());
    }).toList();

    // Handling the case where there are no tasks after filtering
    if (filteredTasks.isEmpty) {
      return const Center(
        child: Text('No tasks were recently added.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final TaskManager task = filteredTasks[index];
          return MouseRegion(
            onEnter: (_) => setState(() => _hoveredIndex = index),
            onExit: (_) => setState(() => _hoveredIndex = -1),
            child: GestureDetector(
              onTap: () => _navigateToTaskDetails(context, task),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.black38),
                  color:
                      _hoveredIndex == index ? Colors.grey[200] : Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: const [
                    BoxShadow(color: Color(0xFF0F7D40), offset: Offset(-5, 5))
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
          );
        },
      ),
    );
  }

  void _navigateToTaskDetails(BuildContext context, TaskManager task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailsPage(task: task)),
    );
  }
}
