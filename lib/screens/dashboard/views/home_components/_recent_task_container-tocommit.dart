import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/home_components/_recent_task_footer.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/home_components/_recent_task_header.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/tasks_components/_task_details.dart'; // Import the TaskDetailsPage

class RecentTaskContainer extends StatefulWidget {
  const RecentTaskContainer({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  _RecentTaskContainerState createState() => _RecentTaskContainerState();
}

class _RecentTaskContainerState extends State<RecentTaskContainer> {
  int _hoveredIndex = -1;
  @override
  Widget build(BuildContext context) {
    List<Task> incompleteTasks =
        widget.tasks.where((task) => !task.isCompleted).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: incompleteTasks.length,
      itemBuilder: (context, index) {
        final Task task = widget.tasks[index];
        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredIndex = index),
          onExit: (_) => setState(() => _hoveredIndex = -1),
          child: GestureDetector(
            onTap: () => _navigateToTaskDetails(
                context, task), // Navigate to TaskDetailsPage
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: _hoveredIndex == index ? Colors.grey[200] : Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RecentTaskHeader(task: task),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Divider(
                      color: const Color(0xFF7C7C7C).withOpacity(0.1),
                    ),
                  ),
                  RecentTaskFooter(task: task),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToTaskDetails(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailsPage(task: task)),
    );
  }
}
