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
      home: const PCICFormPage(),
    );
  }
}
class PCICFormPage extends StatefulWidget {
  final int? taskId;

  const PCICFormPage({super.key, this.taskId});

  @override
  _PCICFormPageState createState() => _PCICFormPageState();
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

class _PCICFormPageState extends State<PCICFormPage> {
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
  final TextEditingController _locationNorthController = TextEditingController();
  final TextEditingController _locationSouthController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  // final TextEditingController _farmerTypeController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: AppBar(
      backgroundColor: const Color(0xFF89C53F), // Change the background color of the AppBar
        title:const Text(
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
                
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: _farmerFirstNameController,
                          inputFormatters: [CapitalizeInputFormatter()],
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            border: UnderlineInputBorder(),
                            labelStyle: TextStyle(fontSize: 14),
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
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: _farmerLastNameController,
                          inputFormatters: [CapitalizeInputFormatter()],
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            border: UnderlineInputBorder(),
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
                      child: SizedBox(
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: TextFormField(
                            controller: _farmerMiddleInitialController,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                              UpperCaseTextFormatter(),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Middle Initial',
                              labelStyle: TextStyle(fontSize: 14),
                              border: UnderlineInputBorder(),
                              counter: SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

                TextFormField(
                  controller: _farmerAddressController,
                  inputFormatters: [CapitalizeInputFormatter()],
                  decoration: const InputDecoration(labelText: 'Address',
                  labelStyle: TextStyle(fontSize: 14),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _farmerTypeController,
                  inputFormatters: [CapitalizeInputFormatter()],
                  decoration:
                  const InputDecoration(labelText: 'Type of Farmer',
                  labelStyle: TextStyle(fontSize: 14),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Type of Farmer';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _farmerMobileNumberController,
                  decoration: const InputDecoration(labelText: 'Mobile No.',
                  labelStyle: TextStyle(fontSize: 14),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your mobile number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _farmerGroupNameController,
                  inputFormatters: [CapitalizeInputFormatter()],
                  decoration: const InputDecoration(labelText: 'Group Name',
                  labelStyle: TextStyle(fontSize: 14),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your group name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _farmerGroupAddressController,
                  inputFormatters: [CapitalizeInputFormatter()],
                  decoration: const InputDecoration(labelText: 'Group Address',
                  labelStyle: TextStyle(fontSize: 14),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your group address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lenderNameController,
                  inputFormatters: [CapitalizeInputFormatter()],
                  decoration: const InputDecoration(labelText: 'Lender Name',
                  labelStyle: TextStyle(fontSize: 14),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter lender name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lenderAddressController,
                  inputFormatters: [CapitalizeInputFormatter()],
                  decoration:
                      const InputDecoration(labelText: 'Lender Address',
                      labelStyle: TextStyle(fontSize: 14),
                      ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter lender address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cicNumberTypeController,
                  decoration: const InputDecoration(labelText: 'CIC No.',
                  labelStyle: TextStyle(fontSize: 14),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter valid CIC number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _locationTypeController,
                  inputFormatters: [CapitalizeInputFormatter()],
                  decoration:
                      const InputDecoration(labelText: 'Location of Farm',
                      labelStyle: TextStyle(fontSize: 14),
                      ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter farm location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  'Location of Sketch Plan:',
                  style: TextStyle(
                    fontSize: 14, // Example font size
                    color: Color.fromARGB(255, 31, 31, 31), // Example color
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
                                labelText: 'North',
                                labelStyle: TextStyle(fontSize: 14),
                                border: UnderlineInputBorder(),
                              ), 
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'East',
                                labelStyle: TextStyle(fontSize: 14),
                                border: UnderlineInputBorder(),
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
                                labelText: 'South',
                                labelStyle: TextStyle(fontSize: 14),
                                border: UnderlineInputBorder(),
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
                                labelText: 'West',
                                labelStyle: TextStyle(fontSize: 14),
                                border: UnderlineInputBorder(),
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
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text(
                      'Remarks',

                      style: TextStyle(
                        fontSize: 14,
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
                      print('Farmer Name: ${_farmerFirstNameController.text}');
                      print('Farmer Last Name: ${_farmerLastNameController.text}');
                      print('Farmer Middle Initial: ${_farmerMiddleInitialController.text}');
                      print('Farmer Address: ${_farmerAddressController.text}');
                      print('Farmer Type: ${_farmerTypeController.text}');
                      print('Farmer Mobile Number: ${_farmerMobileNumberController.text}');
                      print('Farmer Group Name: ${_farmerGroupNameController.text}');
                      print('Farmer Group Address: ${_farmerGroupAddressController.text}');
                      print('Lender Name: ${_lenderNameController.text}');
                      print('Lender Address: ${_lenderAddressController.text}');
                      print('CIC Number Type: ${_cicNumberTypeController.text}');
                      print('Location Type: ${_locationTypeController.text}');
                      print('Location North: ${_locationNorthController.text}');
                      print('Location East: ${_locationEastController.text}');
                      print('Location South: ${_locationSouthController.text}');
                      print('Location West: ${_locationWestController.text}');
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

