// file: control_task.dart
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';
import 'package:external_path/external_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class TaskManager {
  final String formId;
  final String taskId;
  final String type;

  TaskManager({
    required this.formId,
    required this.taskId,
    required this.type,
  });

  factory TaskManager.fromMap(Map<String, dynamic> map) {
    return TaskManager(
      formId: map['formId'],
      taskId: map['taskId'],
      type: map['type'],
    );
  }

  static Future<void> syncDataFromCSV() async {
    try {
      debugPrint('Data sync from CSV started.');

      // Get the list of CSV files in the 'assets/storage/mergedtask/' folder
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      final csvFilePaths = manifestMap.keys
          .where((path) =>
              path.startsWith('assets/storage/mergedtask/') &&
              path.endsWith('.csv'))
          .toList();
      debugPrint('Csv file paths: $csvFilePaths');

      debugPrint('Loop Start...');
      for (final csvFilePath in csvFilePaths) {
        // Read the CSV file content
        final csvContent = await rootBundle.loadString(csvFilePath);
        // Parse the CSV data
        final csvData = const CsvToListConverter().convert(csvContent);
        debugPrint('Csv file content: $csvData');

        // Iterate over each row in the CSV data
        for (final row in csvData) {
          // Check if the row contains PPIR data
          if (row
              .any((cell) => cell.toString().toLowerCase().contains('ppir'))) {
            // Add or update the PPIR form data
            await _addOrUpdatePPIRForm(row);
          }
        }
      }
      debugPrint('Loop End...');

      debugPrint('Data sync from CSV completed.');
    } catch (error) {
      debugPrint('Error syncing data from CSV: $error');
    }
  }

  static Future<void> _addOrUpdatePPIRForm(List<dynamic> row) async {
    debugPrint("Row: $row");
    try {
      // Extract the PPIR form data from the CSV row
      final ppirFormData = {
        'taskManagerNumber': row[0]?.toString() ?? '',
        'serviceGroup': row[1]?.toString() ?? '',
        'serviceType': row[2]?.toString() ?? '',
        'priority': row[3]?.toString() ?? '',
        'status': row[4]?.toString() ?? '',
        'assigneeId': row[5]?.toString() ?? '',
        'ppirAssignmentId': row[6]?.toString() ?? '',
        'ppirInsuranceId': row[7]?.toString() ?? '',
        'ppirFarmerName': row[8]?.toString() ?? '',
        'ppirAddress': row[9]?.toString() ?? '',
        'ppirFarmerType': row[10]?.toString() ?? '',
        'ppirMobileNo': row[11]?.toString() ?? '',
        'ppirGroupName': row[12]?.toString() ?? '',
        'ppirGroupAddress': row[13]?.toString() ?? '',
        'ppirLenderName': row[14]?.toString() ?? '',
        'ppirLenderAddress': row[15]?.toString() ?? '',
        'ppirCicNo': row[16]?.toString() ?? '',
        'ppirFarmLoc': row[17]?.toString() ?? '',
        'ppirNorth': row[18]?.toString() ?? '',
        'ppirSouth': row[19]?.toString() ?? '',
        'ppirEast': row[20]?.toString() ?? '',
        'ppirWest': row[21]?.toString() ?? '',
        'ppirAtt1': row[22]?.toString() ?? '',
        'ppirAtt2': row[23]?.toString() ?? '',
        'ppirAtt3': row[24]?.toString() ?? '',
        'ppirAtt4': row[25]?.toString() ?? '',
        'ppirAreaAci': row[26]?.toString() ?? '',
        'ppirAreaAct': row[27]?.toString() ?? '',
        'ppirDopdsAci': row[28]?.toString() ?? '',
        'ppirDopdsAct': row[29]?.toString() ?? '',
        'ppirDoptpAci': row[30]?.toString() ?? '',
        'ppirDoptpAct': row[31]?.toString() ?? '',
        'ppirSvpAci': row[32]?.toString() ?? '',
        'ppirSvpAct': row[33]?.toString() ?? '',
        'ppirVariety': row[34]?.toString() ?? '',
        'ppirStagecrop': row[35]?.toString() ?? '',
        'ppirRemarks': row[36]?.toString() ?? '',
        'ppirNameInsured': row[37]?.toString() ?? '',
        'ppirNameIuia': row[38]?.toString() ?? '',
        'ppirSigInsured': row[39]?.toString() ?? '',
        'ppirSigIuia': row[40]?.toString() ?? '',
        'trackDatetime': '',
        'trackLastcoord': '',
        'trackTotalarea': '',
        'trackTotaldistance': '',
      };

      // Check if the PPIR form already exists in the ppirForms collection based on ppirInsuranceId and ppirAssignmentId
      final ppirFormsCollection =
          FirebaseFirestore.instance.collection('ppirForms');
      final querySnapshot = await ppirFormsCollection
          .where('ppirInsuranceId', isEqualTo: ppirFormData['ppirInsuranceId'])
          .where('ppirAssignmentId',
              isEqualTo: ppirFormData['ppirAssignmentId'])
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If the PPIR form doesn't exist, add it to the ppirForms collection
        final ppirFormRef = await ppirFormsCollection.add(ppirFormData);

        // Create a new form details document in the formDetails collection
        final formDetailsData = {
          'formId': ppirFormRef,
          'type': 'PPIR',
          'taskManagerNumber': ppirFormData['taskManagerNumber'],
          'assigneeId': ppirFormData['assigneeId'],
          'ppirInsuranceId': ppirFormData['ppirInsuranceId'],
        };
        final formDetailsRef = await FirebaseFirestore.instance
            .collection('formDetails')
            .add(formDetailsData);

        // Create a new task document in the tasks collection
        final taskData = {
          'assignee': FirebaseFirestore.instance
              .doc('users/${ppirFormData['assigneeId']}'),
          'assignor': FirebaseFirestore.instance.doc('users/assignorId'),
          'dateCreated': FieldValue.serverTimestamp(),
          'dateAccess': FieldValue.serverTimestamp(),
          'formDetailsId': formDetailsRef,
          'status': ppirFormData['status'],
        };
        final taskRef =
            await FirebaseFirestore.instance.collection('tasks').add(taskData);

        // Update the form details document with the taskId
        await formDetailsRef.update({'taskId': taskRef});

        // Add the taskId to the ppirFormData
        ppirFormData['taskId'] = taskRef.id;
        await ppirFormRef.update(ppirFormData);
      } else {
        debugPrint('PPIR form already exists. Skipping addition/update.');
      }
    } catch (error) {
      debugPrint('Error adding or updating PPIR form: $error');
    }
  }

  static Future<List<TaskManager>> getAllTasks() async {
    debugPrint('Loading tasks...');

    await syncDataFromCSV();

    List<TaskManager> tasks = [];

    try {
      CollectionReference formDetailsCollection =
          FirebaseFirestore.instance.collection('formDetails');
      QuerySnapshot querySnapshot = await formDetailsCollection.get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> formDetails =
            documentSnapshot.data() as Map<String, dynamic>;

        // Retrieve the taskId from the document reference
        String taskId = (formDetails['taskId'] as DocumentReference).id;
        String formId = (formDetails['formId'] as DocumentReference).id;

        TaskManager task = TaskManager.fromMap({
          'formId': formId,
          'taskId': taskId,
          'type': formDetails['type'],
        });

        tasks.add(task);
      }

      debugPrint('Loaded ${tasks.length} tasks from Firestore');
    } catch (error) {
      debugPrint('Error retrieving tasks from Firestore: $error');
    }
    return tasks;
  }

  /// Fetch Tasks and Form Data ****************************************
  Future<Map<String, dynamic>> getTaskData() async {
    try {
      DocumentReference taskRef =
          FirebaseFirestore.instance.collection('tasks').doc(taskId);
      DocumentSnapshot taskSnapshot = await taskRef.get();

      if (taskSnapshot.exists) {
        Map<String, dynamic> taskData =
            taskSnapshot.data() as Map<String, dynamic>;
        // debugPrint('Loaded task data: $taskData');
        return taskData;
      } else {
        // debugPrint('Task document does not exist for taskId: $taskId');
      }
    } catch (error) {
      // debugPrint('Error retrieving task data: $error');
    }

    return {};
  }

  Future<Map<String, dynamic>> getFormData(String type) async {
    try {
      if (type == "PPIR") {
        DocumentReference formRef =
            FirebaseFirestore.instance.collection('ppirForms').doc(formId);
        DocumentSnapshot formSnapshot = await formRef.get();

        if (formSnapshot.exists) {
          Map<String, dynamic> formData =
              formSnapshot.data() as Map<String, dynamic>;
          // debugPrint('Loaded form data: $formData');
          return formData;
        } else {
          // debugPrint('Form document does not exist for formId: $formId');
          return {};
        }
      } else {
        // debugPrint('Other Types here');
        return {};
      }
      // MAR: add other forms here

      /**
       * if if if if 
       */
    } catch (error) {
      // debugPrint('Error retrieving form data: $error');
      return {};
    }
  }

  static Future<List<TaskManager>> getTasksByStatus(String status) async {
    List<TaskManager> tasks = [];

    try {
      CollectionReference tasksCollection =
          FirebaseFirestore.instance.collection('tasks');
      QuerySnapshot querySnapshot =
          await tasksCollection.where('status', isEqualTo: status).get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        String taskId = documentSnapshot.id;
        Map<String, dynamic> taskData =
            documentSnapshot.data() as Map<String, dynamic>;

        // Get the formDetailsId reference
        DocumentReference? formDetailsIdRef =
            taskData['formDetailsId'] as DocumentReference?;

        if (formDetailsIdRef != null) {
          // Get the formDetailsId document
          DocumentSnapshot formDetailsSnapshot = await formDetailsIdRef.get();

          if (formDetailsSnapshot.exists) {
            Map<String, dynamic> formDetailsData =
                formDetailsSnapshot.data() as Map<String, dynamic>;

            // Get the formId reference
            DocumentReference? formIdRef =
                formDetailsData['formId'] as DocumentReference?;

            if (formIdRef != null) {
              String formId = formIdRef.id;
              String type = formDetailsData['type'];

              TaskManager task = TaskManager.fromMap({
                'formId': formId,
                'taskId': taskId,
                'type': type,
              });

              tasks.add(task);
            }
          }
        }
      }
    } catch (error) {
      debugPrint('Error retrieving tasks by status: $error');
    }

    return tasks;
  }

  /// Not Completed Tasks ****************************************
  static Future<List<TaskManager>> getNotCompletedTasks() async {
    List<TaskManager> tasks = [];

    try {
      CollectionReference tasksCollection =
          FirebaseFirestore.instance.collection('tasks');
      QuerySnapshot querySnapshot = await tasksCollection
          .where('status', isNotEqualTo: 'Completed')
          .get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        String taskId = documentSnapshot.id;
        Map<String, dynamic> taskData =
            documentSnapshot.data() as Map<String, dynamic>;

        // Get the formDetailsId reference
        DocumentReference? formDetailsIdRef =
            taskData['formDetailsId'] as DocumentReference?;

        if (formDetailsIdRef != null) {
          // Get the formDetailsId document
          DocumentSnapshot formDetailsSnapshot = await formDetailsIdRef.get();

          if (formDetailsSnapshot.exists) {
            Map<String, dynamic> formDetailsData =
                formDetailsSnapshot.data() as Map<String, dynamic>;

            // Get the formId reference
            DocumentReference? formIdRef =
                formDetailsData['formId'] as DocumentReference?;

            if (formIdRef != null) {
              String formId = formIdRef.id;
              String type = formDetailsData['type'];

              TaskManager task = TaskManager.fromMap({
                'formId': formId,
                'taskId': taskId,
                'type': type,
              });

              tasks.add(task);
            }
          }
        }
      }
    } catch (error) {
      debugPrint('Error retrieving completed tasks: $error');
    }

    return tasks;
  }

  static Future<List<TaskManager>> getForDispatchTasks() async {
    List<TaskManager> tasks = [];

    try {
      CollectionReference tasksCollection =
          FirebaseFirestore.instance.collection('tasks');
      QuerySnapshot querySnapshot = await tasksCollection
          .where('status', isEqualTo: 'For Dispatch')
          .get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        String taskId = documentSnapshot.id;
        Map<String, dynamic> taskData =
            documentSnapshot.data() as Map<String, dynamic>;

        // Get the formDetailsId reference
        DocumentReference? formDetailsIdRef =
            taskData['formDetailsId'] as DocumentReference?;

        if (formDetailsIdRef != null) {
          // Get the formDetailsId document
          DocumentSnapshot formDetailsSnapshot = await formDetailsIdRef.get();

          if (formDetailsSnapshot.exists) {
            Map<String, dynamic> formDetailsData =
                formDetailsSnapshot.data() as Map<String, dynamic>;

            // Get the formId reference
            DocumentReference? formIdRef =
                formDetailsData['formId'] as DocumentReference?;

            if (formIdRef != null) {
              String formId = formIdRef.id;
              String type = formDetailsData['type'];

              TaskManager task = TaskManager.fromMap({
                'formId': formId,
                'taskId': taskId,
                'type': type,
              });

              tasks.add(task);
            }
          }
        }
      }
    } catch (error) {
      debugPrint('Error retrieving completed tasks: $error');
    }

    return tasks;
  }

  static Future<List<TaskManager>> getOngoingTasks() async {
    List<TaskManager> tasks = [];

    try {
      CollectionReference tasksCollection =
          FirebaseFirestore.instance.collection('tasks');
      QuerySnapshot querySnapshot = await tasksCollection
          .where('status', isEqualTo: 'For Dispatch')
          .get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        String taskId = documentSnapshot.id;
        Map<String, dynamic> taskData =
            documentSnapshot.data() as Map<String, dynamic>;

        // Get the formDetailsId reference
        DocumentReference? formDetailsIdRef =
            taskData['formDetailsId'] as DocumentReference?;

        if (formDetailsIdRef != null) {
          // Get the formDetailsId document
          DocumentSnapshot formDetailsSnapshot = await formDetailsIdRef.get();

          if (formDetailsSnapshot.exists) {
            Map<String, dynamic> formDetailsData =
                formDetailsSnapshot.data() as Map<String, dynamic>;

            // Get the formId reference
            DocumentReference? formIdRef =
                formDetailsData['formId'] as DocumentReference?;

            if (formIdRef != null) {
              String formId = formIdRef.id;
              String type = formDetailsData['type'];

              TaskManager task = TaskManager.fromMap({
                'formId': formId,
                'taskId': taskId,
                'type': type,
              });

              tasks.add(task);
            }
          }
        }
      }
    } catch (error) {
      debugPrint('Error retrieving completed tasks: $error');
    }

    return tasks;
  }

  /// Specific data getters ****************************************
  Future<String?> get status async {
    try {
      Map<String, dynamic> taskData = await getTaskData();
      debugPrint("status is ${taskData['status']}");
      return taskData['status'];
    } catch (error) {
      debugPrint('Error retrieving status: $error');
    }
    return null;
  }

  Future<DateTime?> get dateAccess async {
    try {
      Map<String, dynamic> taskData = await getTaskData();
      Timestamp? dateAccessTimestamp = taskData['dateAccess'];
      if (dateAccessTimestamp != null) {
        return dateAccessTimestamp.toDate();
      }
    } catch (error) {
      // debugPrint('Error retrieving dateAccess: $error');
    }
    return null;
  }

  Future<DateTime?> get dateCreated async {
    try {
      Map<String, dynamic> taskData = await getTaskData();
      Timestamp? dateCreatedTimestamp = taskData['dateCreated'];
      if (dateCreatedTimestamp != null) {
        return dateCreatedTimestamp.toDate();
      }
    } catch (error) {
      // debugPrint('Error retrieving dateCreated: $error');
    }
    return null;
  }

  Future<String?> get assigneeId async {
    try {
      Map<String, dynamic> taskData = await getTaskData();
      return taskData['assignee'].id;
    } catch (error) {
      // debugPrint('Error retrieving assigneeId: $error');
    }
    return null;
  }

  Future<String?> get taskManagerNumber async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      // Get the form data
      Map<String, dynamic> formData = await getFormData(type);
      String? currentNumber = formData['taskManagerNumber'];

      // Check if the taskManagerNumber field is empty
      if (currentNumber == null || currentNumber.isEmpty) {
        // Check if there are pre-generated unique numbers available
        QuerySnapshot querySnapshot = await db
            .collection('uniqueNumbers')
            .where('isUsed', isEqualTo: false)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // If pre-generated numbers are available, use one of them
          String uniqueNumber = querySnapshot.docs.first.id;
          await db
              .collection('uniqueNumbers')
              .doc(uniqueNumber)
              .update({'isUsed': true});
          // Assign the unique number to the form data
          await assignTaskManagerNumberToFormData(uniqueNumber);

          // debugPrint("unique num in if $uniqueNumber");

          return uniqueNumber;
        } else {
          // If no pre-generated numbers are available, generate a new batch
          List<int> newNumbers = generateUniqueNumbersBatch();
          WriteBatch batch = db.batch();

          for (var number in newNumbers) {
            String documentId = number.toString();
            batch.set(db.collection('uniqueNumbers').doc(documentId),
                {'isUsed': false});
          }

          // Commit the batch to Firestore
          await batch.commit();

          // Return the first number from the newly generated batch
          String uniqueNumber = newNumbers.first.toString();
          // Assign the unique number to the form data
          await assignTaskManagerNumberToFormData(uniqueNumber);

          // debugPrint("Generated new batch of unique numbers: $newNumbers");

          // debugPrint("unique num in else $uniqueNumber");

          return uniqueNumber;
        }
      } else {
        // If the taskManagerNumber field is not empty, return the current value
        return currentNumber;
      }
    } catch (error) {
      // debugPrint('Error retrieving Task Number: $error');
      return null;
    }
  }

  Future<void> assignTaskManagerNumberToFormData(String uniqueNumber) async {
    try {
      if (type == "PPIR") {
        DocumentReference formRef =
            FirebaseFirestore.instance.collection('ppirForms').doc(formId);
        // Check if the document exists
        DocumentSnapshot formSnapshot = await formRef.get();
        if (!formSnapshot.exists) {
          // If the document doesn't exist, create it with the task manager number
          await formRef.set({'taskManagerNumber': uniqueNumber.toString()});
        } else {
          // If the document exists, update the task manager number
          await formRef.update({'taskManagerNumber': uniqueNumber.toString()});
        }
      }
    } catch (error) {
      // debugPrint('Error assigning Task Number to form data: $error');
    }
  }

  List<int> generateUniqueNumbersBatch() {
    List<int> numbers = [];
    // Generate a batch of unique numbers (e.g., 1000 numbers)
    // Adjust the batch size based on your requirements and expected workload
    for (int i = 0; i < 1000; i++) {
      numbers.add(100000 + Random().nextInt(900000)); // Range: 100000 - 999999
    }
    return numbers;
  }

  Future<String?> get formattedDateAccess async {
    DateTime? dateAccess = await this.dateAccess;
    if (dateAccess != null) {
      return formatDate(dateAccess);
    }
    return null;
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMMM d, y');
    return formatter.format(dateTime);
  }

  /// Tasks Counter ****************************************
  static Future<Map<String, int>> countTasks() async {
    int totalTasks = 0;
    int completedTasks = 0;
    int pendingTasks = 0;

    try {
      CollectionReference tasksCollection =
          FirebaseFirestore.instance.collection('tasks');
      QuerySnapshot querySnapshot = await tasksCollection.get();

      totalTasks = querySnapshot.docs.length;

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> taskData =
            documentSnapshot.data() as Map<String, dynamic>;

        if (taskData.containsKey('status')) {
          String? status = taskData['status'];
          if (status != null && status.isNotEmpty) {
            if (status.toLowerCase() == 'completed') {
              completedTasks++;
            } else {
              pendingTasks++;
            }
          } else {
            pendingTasks++;
          }
        } else {
          pendingTasks++;
        }
      }

      // debugPrint('Total tasks: $totalTasks');
      // debugPrint('Completed tasks: $completedTasks');
      // debugPrint('Pending tasks: $pendingTasks');
    } catch (error) {
      // debugPrint('Error counting tasks: $error');
    }

    return {
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'pendingTasks': pendingTasks,
    };
  }

  static Future<List<TaskManager>> sortTasks(
      List<TaskManager> tasks, String sortBy) async {
    // Ensure all tasks have their dateAccess and dateCreated loaded
    await Future.wait(
        tasks.map((task) => Future.wait([task.dateAccess, task.dateCreated])));

    // Now sort them
    if (sortBy == 'dateAccess') {
      tasks.sort((a, b) async {
        final aDateAccess = await a.dateAccess;
        final bDateAccess = await b.dateAccess;
        return bDateAccess?.compareTo(aDateAccess ?? DateTime(0)) ?? 1;
      } as int Function(TaskManager a, TaskManager b)?);
    } else if (sortBy == 'dateCreated') {
      tasks.sort((a, b) async {
        final aDateCreated = await a.dateCreated;
        final bDateCreated = await b.dateCreated;
        return bDateCreated?.compareTo(aDateCreated ?? DateTime(0)) ?? 1;
      } as int Function(TaskManager a, TaskManager b)?);
    }

    return tasks;
  }

  /// Saving XML Data ****************************************
  Future<void> saveXmlData() async {
    try {
      Map<String, dynamic> taskData = await getTaskData();
      Map<String, dynamic> formData = await getFormData(type);

      if (taskData.isNotEmpty && formData.isNotEmpty) {
        final filePath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS,
        );

        final downloadsDirectory = Directory(filePath);

        final serviceType = formData['serviceType'] ?? 'Service Group';
        final idMapping = {serviceType: taskId};

        // Provide a default if no mapping exists
        final mappedId = idMapping[serviceType] ?? '000000';

        final baseFilename =
            '${serviceType.replaceAll(' ', ' - ')}_${serviceType.replaceAll(' ', '_')}_$mappedId';

        final insuranceDirectory =
            Directory('${downloadsDirectory.path}/$baseFilename');

        // Create the insurance directory if it doesn't exist
        if (!await insuranceDirectory.exists()) {
          await insuranceDirectory.create(recursive: true);
        }

        // Define the Attachments directory inside the insurance directory
        final taskDirectory = Directory(insuranceDirectory.path);

        // Create the Attachments directory if it doesn't exist
        if (!await taskDirectory.exists()) {
          await taskDirectory.create(recursive: true);
        }

        final xmlFile = File('${taskDirectory.path}/Task.xml');

        // Create the XML builder
        final builder = XmlBuilder();

        // Start building the XML
        builder.processing('xml', 'version="1.0" encoding="UTF-8"');
        builder.element('TaskArchiveZipModel', nest: () {
          builder.namespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance');
          builder.namespace('xsd', 'http://www.w3.org/2001/XMLSchema');

          builder.element('AgentId', nest: () {
            builder.attribute('xsi:nil', 'true');
          });
          builder.element('AssignedDate', nest: taskData['dateAccess'] ?? '');

          builder.element('Attachments');

          builder.element('AuditLogs', nest: () {
            builder.element('TaskAuditLogZipModel', nest: () {
              builder.element('AuditLevel', nest: 'Task');
              builder.element('Label', nest: 'Task Status');
              builder.element('Message', nest: taskData['status'] ?? '');
              builder.element('SnapshotValue', nest: 'For Dispatch');
              builder.element('Source', nest: taskData['assigneeId'] ?? '');
              builder.element('TaskId', nest: taskId);
              builder.element('Timestamp', nest: taskData['dateAccess'] ?? '');
              builder.element('UpdatedValue', nest: 'In Progress');
              builder.element('FieldLabel', nest: 'Task Status');
              builder.element('IPAddress', nest: '');
            });

            builder.element('TaskAuditLogZipModel', nest: () {
              builder.element('AuditLevel', nest: 'Field');
              builder.element('Label', nest: 'Captured Mobile Location');
              builder.element('Source', nest: taskData['assigneeId'] ?? '');
              builder.element('TaskId', nest: taskId);
              builder.element('Timestamp', nest: taskData['dateAccess'] ?? '');
              builder.element('UpdatedValue',
                  nest: ''); // Capture mobile location
              builder.element('FieldLabel', nest: 'Captured Mobile Location');
              builder.element('IPAddress', nest: '');
            });
          });

          // Add other elements from formData
          builder.element('taskManagerNumber', nest: taskId);
          builder.element('serviceGroup', nest: formData['serviceGroup'] ?? '');
          builder.element('serviceType', nest: formData['serviceType'] ?? '');
          builder.element('priority', nest: formData['priority'] ?? '');
          builder.element('taskManagerStatus', nest: taskData['status'] ?? '');
          builder.element('assignee', nest: taskData['assigneeId'] ?? '');
          builder.element('ppirAssignmentid',
              nest: formData['ppirAssignmentId'] ?? '');
          builder.element('ppirInsuranceid',
              nest: formData['ppirInsuranceId'] ?? '');
          builder.element('ppirFarmername',
              nest: formData['ppirFarmerName'] ?? '');
          builder.element('ppirAddress', nest: formData['ppirAddress'] ?? '');
          builder.element('ppirFarmertype',
              nest: formData['ppirFarmerType'] ?? '');
          builder.element('ppirMobileno', nest: formData['ppirMobileNo'] ?? '');
          builder.element('ppirGroupname',
              nest: formData['ppirGroupName'] ?? '');
          builder.element('ppirGroupaddress',
              nest: formData['ppirGroupAddress'] ?? '');
          builder.element('ppirLendername',
              nest: formData['ppirLenderName'] ?? '');
          builder.element('ppirLenderaddress',
              nest: formData['ppirLenderAddress'] ?? '');
          builder.element('ppirCicno', nest: formData['ppirCicNo'] ?? '');
          builder.element('ppirFarmloc', nest: formData['ppirFarmLoc'] ?? '');
          builder.element('ppirNorth', nest: formData['ppirNorth'] ?? '');
          builder.element('ppirSouth', nest: formData['ppirSouth'] ?? '');
          builder.element('ppirEast', nest: formData['ppirEast'] ?? '');
          builder.element('ppirWest', nest: formData['ppirWest'] ?? '');
          builder.element('ppirAtt1', nest: formData['ppirAtt1'] ?? '');
          builder.element('ppirAtt2', nest: formData['ppirAtt2'] ?? '');
          builder.element('ppirAtt3', nest: formData['ppirAtt3'] ?? '');
          builder.element('ppirAtt4', nest: formData['ppirAtt4'] ?? '');
          builder.element('ppirAreaAci', nest: formData['ppirAreaAci'] ?? '');
          builder.element('ppirAreaAct', nest: formData['ppirAreaAct'] ?? '');
          builder.element('ppirDopdsAci', nest: formData['ppirDopdsAci'] ?? '');
          builder.element('ppirDopdsAct', nest: formData['ppirDopdsAct'] ?? '');
          builder.element('ppirDoptpAci', nest: formData['ppirDoptpAci'] ?? '');
          builder.element('ppirDoptpAct', nest: formData['ppirDoptpAct'] ?? '');
          builder.element('ppirSvpAci', nest: formData['ppirSvpAci'] ?? '');
          builder.element('ppirSvpAct', nest: formData['ppirSvpAct'] ?? '');
          builder.element('ppirVariety', nest: formData['ppirVariety'] ?? '');
          builder.element('ppirStagecrop',
              nest: formData['ppirStagecrop'] ?? '');
          builder.element('ppirRemarks', nest: formData['ppirRemarks'] ?? '');
          builder.element('ppirNameInsured',
              nest: formData['ppirNameInsured'] ?? '');

          builder.element('ppirNameIuia', nest: formData['ppirNameIuia'] ?? '');
          builder.element('ppirSigInsured',
              nest: formData['ppirSigInsured'] ?? '');
          builder.element('ppirSigIuia', nest: formData['ppirSigIuia'] ?? '');

          // Add track elements
          builder.element('trackTotalarea', nest: '');
          builder.element('trackDatetime', nest: '');
          builder.element('trackLastcoord', nest: '');
          builder.element('trackTotaldistance', nest: '');
        });

        // Generate the XML string
        final xmlString = builder.buildDocument().toXmlString(pretty: true);

        // Write the XML string to the file
        await xmlFile.writeAsString(xmlString);

        // debugPrint('XML file saved: ${xmlFile.path}');
      } else {
        // debugPrint('Task or form data is empty. Cannot save XML file.');
      }
    } catch (error) {
      // debugPrint('Error saving XML data: $error');
    }
  }
}
