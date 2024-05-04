import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/home/_recent_task_data.dart';
import 'package:pcic_mobile_app/screens/tasks/_control_task.dart';
import 'package:pcic_mobile_app/screens/tasks/_task_details.dart';

class RecentTaskContainer extends StatefulWidget {
  final String searchQuery;
  const RecentTaskContainer(
      {super.key, required this.tasks, required this.searchQuery});

  final List<TaskManager> tasks;

  @override
  RecentTaskContainerState createState() => RecentTaskContainerState();
}

class RecentTaskContainerState extends State<RecentTaskContainer> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Only considering tasks that are not completed
    List<TaskManager> incompleteTasks =
        widget.tasks.where((task) => !task.isCompleted).toList();

    if (incompleteTasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks were recently added.',
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
          final TaskManager task =
              incompleteTasks[index]; // Corrected to use filtered list
          //Move this validation later
          String serviceGroup = task.csvData?['serviceGroup'] ?? '';
          int ppirInsuranceId = task.ppirInsuranceId;

          bool matchesSearchQuery = widget.searchQuery.isEmpty ||
              '$serviceGroup-$ppirInsuranceId'
                  .toLowerCase()
                  .contains(widget.searchQuery.toLowerCase());

          if (!matchesSearchQuery) {
            return const SizedBox
                .shrink(); // Skip rendering if task doesn't match search query
          }
          return MouseRegion(
            onEnter: (_) => setState(() => _hoveredIndex = index),
            onExit: (_) => setState(() => _hoveredIndex = -1),
            child: GestureDetector(
              onTap: () => _navigateToTaskDetails(
                  context, task), // Navigate to TaskDetailsPage
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.black38),
                    color: _hoveredIndex == index
                        ? Colors.grey[200]
                        : Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFF0F7D40), offset: Offset(-5, 5))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TaskData(
                        task:
                            task), // Assuming TaskData is a widget that takes a task and displays its details
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