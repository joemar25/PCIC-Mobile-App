import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/home/_task_box_container.dart';

class TaskCountContainer extends StatefulWidget {
  const TaskCountContainer({super.key});

  @override
  State<TaskCountContainer> createState() => _TaskCountContainerState();
}

class _TaskCountContainerState extends State<TaskCountContainer> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
                child: TaskCountBox(
              label: 'Completed',
              count: 10,
            )),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
                child: TaskCountBox(
              label: 'Remaining',
              count: 4,
            ))
          ],
        ));
  }
}
