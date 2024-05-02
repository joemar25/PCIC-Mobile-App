import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pcic_mobile_app/theme/_theme.dart';

class TaskCountBox extends StatefulWidget {
  final String label;
  final int count;
  const TaskCountBox({super.key, required this.label, required this.count});

  @override
  State<TaskCountBox> createState() => _TaskCountBoxState();
}

class _TaskCountBoxState extends State<TaskCountBox> {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<CustomThemeExtension>()!;
    Color containerColor, circleColor;
    String imagePath;

    if (widget.label == 'Completed') {
      containerColor = const Color(0xFFD2FFCB);
      circleColor = const Color(0xFF0F7D40);
      imagePath = 'assets/storage/images/completed.svg';
    } else {
      containerColor = const Color(0xFFD9F7FA);
      circleColor = const Color(0xFF4894FE);
      imagePath = 'assets/storage/images/clock.svg';
    }

    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: containerColor, borderRadius: BorderRadius.circular(15.0)),
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
              )),
          const SizedBox(
            width: 10.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: TextStyle(fontSize: t.body),
              ),
              Text(
                'Tasks: ${widget.count}',
                style: TextStyle(fontSize: t.caption),
              )
            ],
          )
        ],
      ),
    );
  }
}
