// filename: home/_task_count_container.dart
import 'package:flutter/material.dart';
import '../../tasks/controllers/task_manager.dart';
import '_task_box_container.dart';

class TaskCountContainer extends StatefulWidget {
  final Function(bool) onTasksPressed;
  const TaskCountContainer({super.key, required this.onTasksPressed});

  @override
  State<TaskCountContainer> createState() => _TaskCountContainerState();
}

class _TaskCountContainerState extends State<TaskCountContainer> {
  int completedTaskCount = 0;
  int remainingTaskCount = 0;

  @override
  void initState() {
    super.initState();
    fetchTaskCounts();
  }

  Future<void> fetchTaskCounts() async {
    try {
      List<TaskManager> tasks = await TaskManager.getAllTasks();
      int completedCount = 0;
      int remainingCount = 0;
      for (var task in tasks) {
        String? status = await task.status;
        if (status != null && status.toLowerCase() == 'completed') {
          completedCount++;
        } else {
          remainingCount++;
        }
      }
      if (mounted) {
        setState(() {
          completedTaskCount = completedCount;
          remainingTaskCount = remainingCount;
        });
      }
    } catch (error) {
      if (mounted) {
        debugPrint('Error fetching task counts: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onTasksPressed(true),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TaskCountBox(
                  label: 'Completed',
                  count: completedTaskCount,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onTasksPressed(false),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TaskCountBox(
                  label: 'Remaining',
                  count: remainingTaskCount,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
