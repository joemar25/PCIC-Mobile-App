import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';

class PCICFormPage extends StatelessWidget {
  final Task task;
  final String gpxFile;

  const PCICFormPage({super.key, required this.task, required this.gpxFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PCIC Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // TextFormField(
            //   initialValue: task.title,
            //   decoration: const InputDecoration(labelText: 'Title'),
            //   enabled: false,
            // ),
            // TextFormField(
            //   initialValue: task.description,
            //   decoration: const InputDecoration(labelText: 'Description'),
            //   enabled: false,
            // ),
            TextFormField(
              initialValue: task.formData['companyName'] ?? '',
              decoration: const InputDecoration(labelText: 'Company Name'),
              enabled: false,
            ),
            TextFormField(
              initialValue: task.formData['registrationNumber'] ?? '',
              decoration:
                  const InputDecoration(labelText: 'Registration Number'),
              enabled: false,
            ),
            TextFormField(
              initialValue: task.formData['ownerName'] ?? '',
              decoration: const InputDecoration(labelText: 'Owner Name'),
              enabled: false,
            ),
            TextFormField(
              initialValue: task.formData['email'] ?? '',
              decoration: const InputDecoration(labelText: 'Email'),
              enabled: false,
            ),
            const SizedBox(height: 20),
            const Text(
              'Signature Area',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 200,
              color: Colors.grey[200],
              child: const Center(
                child: Text(
                  'Signature Placeholder',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'GPX File',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              gpxFile,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
