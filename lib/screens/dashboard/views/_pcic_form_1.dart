import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/controllers/_control_task.dart';

void main() {
  runApp(const TaskFormPage());
}

class TaskFormPage extends StatelessWidget {
  const TaskFormPage({super.key, Task? task});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PCIC Form',
      home: PCICFormPage(),
    );
  }
}

class PCICFormPage extends StatefulWidget {
  final int? taskId;

  const PCICFormPage({super.key, this.taskId});

  @override
  _PCICFormPageState createState() => _PCICFormPageState();
}

class _PCICFormPageState extends State<PCICFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PCIC Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(labelText: 'Company Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter company name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _registrationNumberController,
                decoration:
                    const InputDecoration(labelText: 'Registration Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter registration number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(labelText: 'Owner Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter owner name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('Company Name: ${_companyNameController.text}');
                    print(
                        'Registration Number: ${_registrationNumberController.text}');
                    print('Owner Name: ${_ownerNameController.text}');
                    print('Email: ${_emailController.text}');
                  }
                },
                child: const Text('Submit'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Create a map with the form data
                    Map<String, dynamic> formData = {
                      'companyName': _companyNameController.text,
                      'registrationNumber': _registrationNumberController.text,
                      'ownerName': _ownerNameController.text,
                      'email': _emailController.text,
                    };

                    if (widget.taskId == null) {
                      // Add a new task
                      Task.addTask(
                        title: 'PCIC Form',
                        description: 'PCIC Form submission',
                        geotaggedPhoto: '',
                        formData: formData,
                      );
                    } else {
                      // Update an existing task
                      // Retrieve the existing task based on the taskId
                      Task existingTask = Task.getAllTasks().firstWhere(
                        (task) => task.id == widget.taskId,
                        orElse: () => throw Exception('Task not found'),
                      );

                      // Create an updated task with the new form data
                      Task updatedTask = Task(
                        id: existingTask.id,
                        title: existingTask.title,
                        description: existingTask.description,
                        isCompleted: existingTask.isCompleted,
                        dateAdded: existingTask.dateAdded,
                        geotaggedPhoto: existingTask.geotaggedPhoto,
                        formData: formData,
                      );

                      // Update the task in the database or storage mechanism
                      // You need to implement the updateTask() function in the Task class
                      // to handle the update logic based on your storage mechanism
                      // For example:
                      // Task.updateTask(updatedTask);
                    }

                    // Navigate back to the previous screen
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _registrationNumberController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
