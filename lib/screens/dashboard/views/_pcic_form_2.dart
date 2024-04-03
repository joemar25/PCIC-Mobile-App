// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';

void main() {
  runApp(const TaskFormPage());
}

class TaskFormPage extends StatelessWidget {
  const TaskFormPage({super.key, Task? task});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PCIC Form',
      home: const PCICFormPage2(),
    );
  }
}

class PCICFormPage2 extends StatefulWidget {
  final int? taskId;

  const PCICFormPage2({super.key, this.taskId});

  @override
  _PCICFormPage2State createState() => _PCICFormPage2State();
}

class CapitalizeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.splitMapJoin(
        RegExp(r'\b\w'),
        onMatch: (m) => m.group(0)!.toUpperCase(),
        onNonMatch: (n) => n,
      ),
      selection: newValue.selection,
    );
  }
}

class _PCICFormPage2State extends State<PCICFormPage2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _farmerFirstNameController =
      TextEditingController();
  final TextEditingController _farmerLastNameController =
      TextEditingController();
  final TextEditingController _farmerMiddleInitialController =
      TextEditingController();
  final TextEditingController _farmerAddressController =
      TextEditingController();
  final TextEditingController _farmerTypeController = TextEditingController();

  final TextEditingController _farmerMobileNumberController =
      TextEditingController();
  final TextEditingController _farmerGroupNameController =
      TextEditingController();
  final TextEditingController _farmerGroupAddressController =
      TextEditingController();
  final TextEditingController _lenderNameController = TextEditingController();
  final TextEditingController _lenderAddressController =
      TextEditingController();
  final TextEditingController _cicNumberTypeController =
      TextEditingController();
  final TextEditingController _locationTypeController = TextEditingController();

  final TextEditingController _locationWestController = TextEditingController();
  final TextEditingController _locationEastController = TextEditingController();
  final TextEditingController _locationNorthController =
      TextEditingController();
  final TextEditingController _locationSouthController =
      TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  final TextEditingController _perAreaPlantedController = TextEditingController();
  final TextEditingController _perDateDsController = TextEditingController();
  final TextEditingController _perDateTpController = TextEditingController();
  final TextEditingController _perSeedVarietyController =
      TextEditingController();

  final TextEditingController _actualAreaController = TextEditingController();
  final TextEditingController _actualDateDsController = TextEditingController();
  final TextEditingController _actualDateTpController = TextEditingController();
  final TextEditingController _actualSeedVarietyController =
      TextEditingController();

  // final TextEditingController _farmerTypeController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(
            0xFF89C53F), // Change the background color of the AppBar
        title: const Text(
          'PCIC Form',
          style: TextStyle(
            fontSize: 20, // Adjust the font size
            fontWeight: FontWeight.bold, // Make the title bold
            color: Colors.white, // Change the text color of the title
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const Text(
                'Farmer Name:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: TextFormField(
                        controller: _farmerFirstNameController,
                        inputFormatters: [CapitalizeInputFormatter()],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(fontSize: 14),
                          hintText: 'First Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: TextFormField(
                        controller: _farmerLastNameController,
                        inputFormatters: [CapitalizeInputFormatter()],
                        decoration: const InputDecoration(
                          hintText: 'Last Name',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(fontSize: 14),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        controller: _farmerMiddleInitialController,
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z]')),
                          UpperCaseTextFormatter(),
                        ],
                        decoration: const InputDecoration(
                          hintText: 'Middle Initial',
                          labelStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(),
                          counter: SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: const Text(
                  'Farmer Address:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: _farmerAddressController,
                inputFormatters: [CapitalizeInputFormatter()],
                decoration: const InputDecoration(
                  hintText: 'Address',
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: const Text(
                  'Type of Farmer:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: _farmerTypeController,
                inputFormatters: [CapitalizeInputFormatter()],
                decoration: const InputDecoration(
                  hintText: 'Type of Farmer',
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Type of Farmer';
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: const Text(
                  'Mobile Number:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: _farmerMobileNumberController,
                decoration: const InputDecoration(
                  hintText: 'Mobile No.',
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your mobile number';
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: const Text(
                  'Group Name:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: _farmerGroupNameController,
                inputFormatters: [CapitalizeInputFormatter()],
                decoration: const InputDecoration(
                  hintText: 'Group Name',
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your group name';
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: const Text(
                  'Group Address:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: _farmerGroupAddressController,
                inputFormatters: [CapitalizeInputFormatter()],
                decoration: const InputDecoration(
                  hintText: 'Group Address',
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your group address';
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: const Text(
                  'Lender Name:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: _lenderNameController,
                inputFormatters: [CapitalizeInputFormatter()],
                decoration: const InputDecoration(
                  hintText: 'Lender Name',
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter lender name';
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: const Text(
                  'Lender Address:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: _lenderAddressController,
                inputFormatters: [CapitalizeInputFormatter()],
                decoration: const InputDecoration(
                  hintText: 'Lender Address',
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter lender address';
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: const Text(
                  'CIC Number:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: _cicNumberTypeController,
                decoration: const InputDecoration(
                  hintText: 'CIC No.',
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter valid CIC number';
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: const Text(
                  'Location of Farm:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: _locationTypeController,
                inputFormatters: [CapitalizeInputFormatter()],
                decoration: const InputDecoration(
                  hintText: 'Location of Farm',
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter farm location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: const Text(
                  'Location of Sketch Plan:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // First row for North and East input fields
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            inputFormatters: [UpperCaseTextFormatter()],
                            controller: _locationNorthController,
                            decoration: const InputDecoration(
                              hintText: 'North',
                              labelStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'East',
                              labelStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: [UpperCaseTextFormatter()],
                            controller: _locationEastController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Second row for South and West input fields
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'South',
                              labelStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: [UpperCaseTextFormatter()],
                            controller: _locationSouthController,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'West',
                              labelStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: [UpperCaseTextFormatter()],
                            controller: _locationWestController,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: const Text(
                  'FINDINGS:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              //kulit
              Container(
                margin: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                child: const Text(
                  'PER ACI:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: _perAreaPlantedController,
                inputFormatters: [CapitalizeInputFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Area Planted',
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Area Planted';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _perDateDsController,
                        inputFormatters: [CapitalizeInputFormatter()],
                        decoration: const InputDecoration(
                          labelText: 'Date of Plantings (DS)',
                          labelStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Date DS';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _perDateTpController,
                        inputFormatters: [CapitalizeInputFormatter()],
                        decoration: const InputDecoration(
                          labelText: 'Date of Plantings (TP)',
                          labelStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Date TP';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _perSeedVarietyController,
                inputFormatters: [CapitalizeInputFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Seed Variety Planted',
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Seed Variety Planted';
                  }
                  return null;
                },
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                child: const Text(
                  'ACTUAL:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: _actualAreaController,
                inputFormatters: [CapitalizeInputFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Area Planted',
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Area Planted';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _actualDateDsController,
                        inputFormatters: [CapitalizeInputFormatter()],
                        decoration: const InputDecoration(
                          labelText: 'Date of Plantings (DS)',
                          labelStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Date DS';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _actualDateTpController,
                        inputFormatters: [CapitalizeInputFormatter()],
                        decoration: const InputDecoration(
                          labelText: 'Date of Plantings (TP)',
                          labelStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Date TP';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _actualSeedVarietyController,
                inputFormatters: [CapitalizeInputFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Seed Variety Planted',
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Seed Variety Planted';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                    child: const Text(
                      'Remarks:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFormField(
                    maxLines: 3,
                    controller: _remarksController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your remarks...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: const Text(
                  'Conformed By:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
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
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: const Text(
                  'Conformed By:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
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
                    print('Farmer Name: ${_farmerFirstNameController.text}');
                    print(
                        'Farmer Last Name: ${_farmerLastNameController.text}');
                    print(
                        'Farmer Middle Initial: ${_farmerMiddleInitialController.text}');
                    print('Farmer Address: ${_farmerAddressController.text}');
                    print('Farmer Type: ${_farmerTypeController.text}');
                    print(
                        'Farmer Mobile Number: ${_farmerMobileNumberController.text}');
                    print(
                        'Farmer Group Name: ${_farmerGroupNameController.text}');
                    print(
                        'Farmer Group Address: ${_farmerGroupAddressController.text}');
                    print('Lender Name: ${_lenderNameController.text}');
                    print('Lender Address: ${_lenderAddressController.text}');
                    print('CIC Number Type: ${_cicNumberTypeController.text}');
                    print('Location Type: ${_locationTypeController.text}');
                    print('Location North: ${_locationNorthController.text}');
                    print('Location East: ${_locationEastController.text}');
                    print('Location South: ${_locationSouthController.text}');
                    print('Location West: ${_locationWestController.text}');
                    print('Per ACI Area Planted: ${_perAreaPlantedController}');
                    print('Per Date DS: ${_perDateDsController.text}');
                    print('Per Date TP: ${_perDateTpController.text}');
                    print('Per Seed Variety: ${_perSeedVarietyController.text}');
                    print('Actual Area Planted: ${_actualAreaController.text}');
                    print('Actual Date DS: ${_actualDateDsController.text}');
                    print('Actual Date TP: ${_actualDateTpController.text}');
                    print('Actual Seed Variety: ${_actualSeedVarietyController.text}');

                    print('Remarks: ${_remarksController.text}');
                  }
                },
                child: const Text('Submit'),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     if (_formKey.currentState!.validate()) {
              //       // Create a map with the form data
              //       Map<String, dynamic> formData = {
              //         'farmerFirstName': _farmerFirstNameController.text,
              //         'farmerLastName': _farmerLastNameController.text,
              //         'farmerEmail': _farmerMiddleInitialController.text,
              //         'farmerAddress': _farmerAddressController.text,
              //         'farmerType': _farmerTypeController.text,
              //         'farmerMobileNumber':
              //             _farmerMobileNumberController.text,
              //         'farmerGroupName': _farmerGroupNameController.text,
              //         'farmerGroupAddress':
              //             _farmerGroupAddressController.text,
              //         'lenderName': _lenderNameController.text,
              //         'lenderAddress': _lenderAddressController.text,
              //         'cicNumberType': _cicNumberTypeController.text,
              //         'locationType': _locationTypeController.text,
              //       };

              //       if (widget.taskId == null) {
              //         // Add a new task
              //         Task.addTask(
              //           title: 'PCIC Form',
              //           description: 'PCIC Form submission',
              //           geotaggedPhoto: '',
              //           formData: formData,
              //         );
              //       } else {
              //         // Update an existing task
              //         // Retrieve the existing task based on the taskId
              //         List<Task> taskList = await Task.getAllTasks();
              //         Task existingTask = taskList.firstWhere(
              //           (task) => task.id == widget.taskId,
              //           orElse: () => throw Exception('Task not found'),
              //         );

              //         // Create an updated task with the new form data
              //         // ignore: unused_local_variable
              //         // Task updatedTask = Task(
              //         //   id: existingTask.id,
              //         //   title: existingTask.title,
              //         //   description: existingTask.description,
              //         //   isCompleted: existingTask.isCompleted,
              //         //   dateAdded: existingTask.dateAdded,
              //         //   geotaggedPhoto: existingTask.geotaggedPhoto,
              //         //   formData: formData,
              //         // );

              //         // Update the task in the database or storage mechanism
              //         // You need to implement the updateTask() function in the Task class
              //         // to handle the update logic based on your storage mechanism
              //         // For example:
              //         // Task.updateTask(updatedTask);
              //       }

              //       // Navigate back to the previous screen
              //       Navigator.pop(context);
              //     }
              //   },
              //   child: const Text('Submit'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _farmerFirstNameController.dispose();
    _farmerLastNameController.dispose();
    _farmerMiddleInitialController.dispose();
    _farmerAddressController.dispose();
    _farmerTypeController.dispose();
    _farmerMobileNumberController.dispose();
    _farmerGroupNameController.dispose();
    _farmerGroupAddressController.dispose();
    _lenderNameController.dispose();
    _lenderAddressController.dispose();
    _cicNumberTypeController.dispose();
    _locationTypeController.dispose();
    _locationNorthController.dispose();
    _locationEastController.dispose();
    _locationSouthController.dispose();
    _locationWestController.dispose();
    _perAreaPlantedController.dispose();
    _perDateDsController.dispose();
    _perDateTpController.dispose();
    _perSeedVarietyController.dispose();
    _actualAreaController.dispose();
    _actualDateDsController.dispose();
    _actualDateTpController.dispose();
    _actualSeedVarietyController.dispose();
    _remarksController.dispose();

    super.dispose();
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
