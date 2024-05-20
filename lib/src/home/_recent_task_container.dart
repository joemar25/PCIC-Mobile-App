import '../tasks/_control_task.dart';
import '../tasks/_task_details.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/home/_recent_task_data.dart';

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
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<TaskManager> filteredTasks = widget.notCompletedTasks.where((task) {
      String identifier = '${task.formId}-${task.taskId}'.toLowerCase();
      return widget.searchQuery.isEmpty ||
          identifier.contains(widget.searchQuery.toLowerCase());
    }).toList();

    return ListView.builder(
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
                border: Border.all(width: 0.2, color: Colors.grey),
                color: _hoveredIndex == index ? Colors.grey[200] : Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F7D40).withOpacity(0.8),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return TaskData(task: task);
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 16,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 12,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 10,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 10,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToTaskDetails(BuildContext context, TaskManager task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailsPage(task: task)),
    );
  }
}
