import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/home_views/_recent_task_footer.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/home_views/_recent_task_header.dart';

class RecentTaskContainer extends StatelessWidget {
  const RecentTaskContainer({super.key, required this.tasks});

  final List<String> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const RecentTaskHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Divider(
                  color: const Color(0xFF7C7C7C).withOpacity(0.1),
                ),
              ),
              const RecentTaskFooter(),
            ],
          ),
        );
      },
    );
  }
}
