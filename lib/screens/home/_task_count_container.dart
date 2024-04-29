import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/home/_task_box_container.dart';

class TaskCountContainer extends StatefulWidget {
  const TaskCountContainer({super.key});

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

  void fetchTaskCounts() {
    final databaseReference = FirebaseDatabase.instance.ref();
    final tasksReference = databaseReference.child('tasks');

    tasksReference.onValue.listen((event) {
      final tasksSnapshot = event.snapshot;
      int completedCount = 0;
      int remainingCount = 0;

      for (var taskSnapshot in tasksSnapshot.children) {
        final taskData = taskSnapshot.value as Map<dynamic, dynamic>;
        final isCompleted = taskData['isCompleted'] as bool? ?? false;

        if (isCompleted) {
          completedCount++;
        } else {
          remainingCount++;
        }
      }

      setState(() {
        completedTaskCount = completedCount;
        remainingTaskCount = remainingCount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TaskCountBox(
              label: 'Completed',
              count: completedTaskCount,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: TaskCountBox(
              label: 'Remaining',
              count: remainingTaskCount,
            ),
          ),
        ],
      ),
    );
  }
}
