import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/home/_recent_task_data.dart';
// import 'package:pcic_mobile_app/screens/home/_search_button.dart';
import 'package:pcic_mobile_app/screens/tasks/_control_task.dart';
import 'package:pcic_mobile_app/screens/tasks/_task_details.dart'; // Import the TaskDetailsPage

class RecentTaskContainer extends StatefulWidget {
  const RecentTaskContainer({super.key, required this.tasks});

  final List<TaskManager> tasks;

  @override
  RecentTaskContainerState createState() => RecentTaskContainerState();
}

class RecentTaskContainerState extends State<RecentTaskContainer> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<TaskManager> incompleteTasks =
        widget.tasks.where((task) => !task.isCompleted).toList();

    if (incompleteTasks.isEmpty) {
      // If there are no incomplete tasks
      return const Center(
        child: Text(
          'No tasks were recently added.',
          style: TextStyle(fontSize: 16.0),
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: incompleteTasks.length,
          itemBuilder: (context, index) {
            final TaskManager task = widget.tasks[index];
            return MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = index),
              onExit: (_) => setState(() => _hoveredIndex = -1),
              child: GestureDetector(
                onTap: () => _navigateToTaskDetails(
                    context, task), // Navigate to TaskDetailsPage
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      color: _hoveredIndex == index
                          ? Colors.grey[200]
                          : Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xFF0F7D40), offset: Offset(-5, 5))
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [TaskData(task: task)],
                  ),
                ),
              ),
            );
          },
        ));
  }

  void _navigateToTaskDetails(BuildContext context, TaskManager task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailsPage(task: task)),
    );
  }
}










      //     Padding(
      // padding: const EdgeInsets.symmetric(horizontal: 10.0),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     const 
      //     ),
      //     const SizedBox(height: 8.0),
      //     const SearchButton(),
      //     const SizedBox(height: 16.0),
          
      //   ],
      // ),