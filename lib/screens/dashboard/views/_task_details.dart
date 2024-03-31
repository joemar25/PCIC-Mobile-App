import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_geotag.dart';

class TaskDetailsPage extends StatelessWidget {
  final int taskId;
  final bool isCompleted;

  const TaskDetailsPage({
    super.key,
    required this.taskId,
    required this.isCompleted,
  });

  void _navigateToGeotagPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GeotagPage(taskId: taskId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String jobTitle = 'Job Title';
    const String jobDescription = 'Job Description';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              jobDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            // Add more job details as needed
            const SizedBox(height: 24),
            if (!isCompleted)
              ElevatedButton(
                onPressed: () => _navigateToGeotagPage(context),
                child: const Text('Go to Job Page'),
              ),
          ],
        ),
      ),
    );
  }
}
