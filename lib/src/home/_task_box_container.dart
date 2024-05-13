import '../tasks/_task.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';
// filename: _task_count_box.dart

class TaskCountBox extends StatefulWidget {
  final String label;
  final int count;
  const TaskCountBox({super.key, required this.label, required this.count});

  @override
  State<TaskCountBox> createState() => _TaskCountBoxState();
}

class _TaskCountBoxState extends State<TaskCountBox> {
  void _navigateToTaskPage() {
    String initialFilter;
    if (widget.label == 'Completed') {
      initialFilter = 'Completed';
    } else {
      initialFilter = 'Ongoing';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskPage(
          initialFilter: initialFilter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    Color containerColor, circleColor;
    String imagePath;
    if (widget.label == 'Completed') {
      containerColor = shadowMainColor;
      circleColor = mainColor;
      imagePath = 'assets/storage/images/completed.svg';
    } else {
      containerColor = shadowMainColor2;
      circleColor = mainColor2;
      imagePath = 'assets/storage/images/clock.svg';
    }

    return GestureDetector(
      onTap: _navigateToTaskPage,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration:
                  BoxDecoration(color: circleColor, shape: BoxShape.circle),
              height: 45,
              width: 45,
              child: SvgPicture.asset(
                imagePath,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 10.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: t?.body ?? 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Tasks: ${widget.count}',
                  style: TextStyle(
                    fontSize: t?.caption ?? 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
