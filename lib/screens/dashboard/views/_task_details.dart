import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_geotag.dart';

import '_pcic_form_1.dart';
import '_pcic_form_2.dart';

class TaskDetailsPage extends StatelessWidget {
  final Task task;

  const TaskDetailsPage({super.key, required this.task});

  void _navigateToGeotagPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GeotagPage(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   task.title,
            //   style: Theme.of(context).textTheme.titleLarge,
            // ),
            Text(
              task.id.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Date Added: ${DateFormat('MMM d, yyyy').format(task.dateAdded)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              // child: Text(
              //   task.description,
              //   style: const TextStyle(fontSize: 16.0),
              // ),
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Text(
                  'Status:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  task.isCompleted ? 'Completed' : 'Upcoming',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: task.isCompleted ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            if (!task.isCompleted)
              ElevatedButton(
                onPressed: () => _navigateToGeotagPage(context),
                child: const Text('Go to Job Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the PCICFormPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PCICFormPage(),
                    ),
                  );
                },
                child: const Text('Navigate to form'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the PCICFormPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PCICFormPage2(),
                    ),
                  );
                },
                child: const Text('Navigate to form2'),
              ),
          ],
          
        ),
        
      ),
    );
  }
}
