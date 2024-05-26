import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:latlong2/latlong.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

import 'task_xml_generator.dart';
// import 'package:path/path.dart' as path;

class TaskManager {
  final String taskId;
  final String formId;
  final String type;

  TaskManager({
    required this.formId,
    required this.taskId,
    required this.type,
  });

  factory TaskManager.fromMap(Map<String, dynamic> data) {
    return TaskManager(
      formId: data['formId'] ?? '',
      taskId: data['taskId'] ?? '',
      type: data['type'] ?? '',
    );
  }

  Future<String?> get confirmedByName async {
    try {
      final formData = await getFormData(type);
      return formData['ppirNameInsured'] as String?;
    } catch (error) {
      // debugPrint('Error retrieving Task Number: $error');
      return null;
    }
  }

  Future<String?> get preparedByName async {
    try {
      final formData = await getFormData(type);
      return formData['ppirNameIuia'] as String?;
    } catch (error) {
      // debugPrint('Error retrieving Task Number: $error');
      return null;
    }
  }

  static Future<List<TaskManager>> getTasksByQuery(Query query) async {
    List<TaskManager> tasks = [];

    try {
      final querySnapshot = await query.get();
      // debugPrint('Tasks fetched: ${querySnapshot.docs.length}');

      for (final documentSnapshot in querySnapshot.docs) {
        final taskId = documentSnapshot.id;
        final taskData = documentSnapshot.data() as Map<String, dynamic>?;

        if (taskData != null) {
          final formDetailsIdRef =
              taskData['formDetailsId'] as DocumentReference?;

          if (formDetailsIdRef != null) {
            final formDetailsSnapshot = await formDetailsIdRef.get();

            if (formDetailsSnapshot.exists) {
              final formDetailsData =
                  formDetailsSnapshot.data() as Map<String, dynamic>?;

              if (formDetailsData != null) {
                final formIdRef =
                    formDetailsData['formId'] as DocumentReference?;
                final formId = formIdRef?.id ?? '';
                final type = formDetailsData['type'] ?? '';

                final task = TaskManager(
                  formId: formId,
                  taskId: taskId,
                  type: type,
                );

                tasks.add(task);
              }
            }
          }
        }
      }
    } catch (error) {
      // debugPrint('Error retrieving tasks: $error');
    }

    return tasks;
  }

  static Future<List<TaskManager>> getTasksByStatus(String status) async {
    final query = FirebaseFirestore.instance
        .collection('tasks')
        .where('status', isEqualTo: status);
    return await getTasksByQuery(query);
  }

  static Future<List<TaskManager>> getAllTasks() async {
    final query = FirebaseFirestore.instance.collection('tasks');
    return await getTasksByQuery(query);
  }

  Future<void> updatePpirFormData(
      Map<String, dynamic> formData, Map<String, dynamic> taskData) async {
    final formRef =
        FirebaseFirestore.instance.collection('ppirForms').doc(formId);
    final taskRef = FirebaseFirestore.instance.collection('tasks').doc(taskId);

    final batch = FirebaseFirestore.instance.batch();
    batch.update(formRef, formData);
    batch.update(taskRef, taskData);

    // debugPrint("formData = $formData");
    // debugPrint("taskData = $taskData");

    await batch.commit();
  }

  Future<void> updateLastCoordinates(LatLng coordinates) async {
    try {
      // debugPrint('Updating last coordinates and dateAccess...');

      final ppirFormRef =
          FirebaseFirestore.instance.collection('ppirForms').doc(formId);
      final taskRef =
          FirebaseFirestore.instance.collection('tasks').doc(taskId);

      // debugPrint("ppirFormRef = ${coordinates.latitude},${coordinates.longitude}")
      await ppirFormRef.update({
        'trackLastcoord': '${coordinates.latitude},${coordinates.longitude}',
      });
      // debugPrint('Last coordinates updated to (${coordinates.latitude}, ${coordinates.longitude})')

      // debugPrint("Updating dateAccess for taskRef = $taskId");
      await taskRef.update({
        'dateAccess': FieldValue.serverTimestamp(),
      });
      // debugPrint('dateAccess updated for task $taskId');
    } catch (e) {
      // debugPrint('Error updating last coordinates or dateAccess: $e');
      throw Exception('Error updating last coordinates or dateAccess');
    }
  }

  Future<String> getGpxFilePath() async {
    final storageRef =
        FirebaseStorage.instance.ref().child('PPIR_SAVES/$formId/Attachments');
    final ListResult result = await storageRef.listAll();
    for (Reference fileRef in result.items) {
      if (fileRef.name.endsWith('.gpx')) {
        return await fileRef.getDownloadURL();
      }
    }
    throw Exception('GPX file not found in Firebase Storage');
  }

  static Future<List<String>> _getCSVFilePaths() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

    List<String> csvPaths = manifestMap.keys
        .where((path) =>
            path.startsWith('assets/storage/ftp/Work') && path.endsWith('.csv'))
        .toList();

    return csvPaths;
  }

  static Future<List<TaskManager>> getNotCompletedTasks() async {
    // Joemar is here
    // await syncDataFromCSV();

    final query = FirebaseFirestore.instance
        .collection('tasks')
        .where('status', isNotEqualTo: 'Completed');

    return await getTasksByQuery(query);
  }

  static Future<List<List<dynamic>>> _loadCSVData(String filePath) async {
    final fileContent = await rootBundle.loadString(filePath);
    return const CsvToListConverter().convert(fileContent);
  }

  static Future<void> syncDataFromCSV() async {
    List<String> emails = [];
    try {
      final csvFilePaths = await _getCSVFilePaths();

      for (final csvFilePath in csvFilePaths) {
        final csvData = await _loadCSVData(csvFilePath);

        // Skip the first row and empty rows
        final Iterable<List<dynamic>> rowsToProcess =
            csvData.skip(1).where((row) => row.isNotEmpty);

        for (final row in rowsToProcess) {
          final ppirInsuranceId = row[7]?.toString().trim() ?? '';

          final email = row[5]?.toString().trim() ?? '';
          if (email.isNotEmpty) {
            emails.add(email);
          }

          if (ppirInsuranceId.isNotEmpty) {
            final ppirFormQuerySnapshot = await FirebaseFirestore.instance
                .collection('ppirForms')
                .where('ppirInsuranceId', isEqualTo: ppirInsuranceId)
                .limit(1)
                .get();

            if (ppirFormQuerySnapshot.docs.isEmpty) {
              await _createNewTaskAndRelatedDocuments(row);
            } else {
              // debugPrint('Duplicate PPIR form detected with ppirInsuranceId: $ppirInsuranceId')
            }
          }
        }
      }

      // debugPrint('Error syncing data from CSV: $emails');
      await _createAccountsForEmails(emails);
      await _deleteDuplicateForms();
    } catch (error) {
      // debugPrint('Error syncing data from CSV: $error');
    }
  }

  static Future<void> _createAccountsForEmails(List<String> emails) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    for (final email in emails) {
      try {
        await auth.createUserWithEmailAndPassword(
            email: email, password: 'admin1234');

        await sendEmail(email, 'Your New Account Details',
            'Your account has been created.\nEmail: $email\nPassword: admin1234');
      } catch (e) {
        if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
          // Account already exists, skip creation
          debugPrint('Account already exists for email: $email');
        } else {
          debugPrint('Error creating account for email: $email - $e');
        }
      }
    }
  }

  static Future<void> sendEmail(
      // Scott is here
      String recipientEmail,
      String subject,
      String body) async {
    String username = 'quanbydevs@gmail.com'; // Your email address
    String password = 'ghpnvhypovidmqdn'; // Your app password

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Quanby Admin')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: $sendReport');
    } on MailerException catch (e) {
      debugPrint('Message not sent.');
      for (var p in e.problems) {
        debugPrint('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  static Future<void> _deleteDuplicateForms() async {
    final ppirFormsSnapshot =
        await FirebaseFirestore.instance.collection('ppirForms').get();
    final Map<String, List<QueryDocumentSnapshot>> duplicateFormsMap = {};

    for (final ppirForm in ppirFormsSnapshot.docs) {
      final ppirInsuranceId =
          ppirForm['ppirInsuranceId']?.toString().trim() ?? '';
      if (ppirInsuranceId.isNotEmpty) {
        if (duplicateFormsMap.containsKey(ppirInsuranceId)) {
          duplicateFormsMap[ppirInsuranceId]!.add(ppirForm);
        } else {
          duplicateFormsMap[ppirInsuranceId] = [ppirForm];
        }
      }
    }

    final List<Future> deletionFutures = [];

    for (var entry in duplicateFormsMap.entries) {
      final duplicateForms = entry.value;

      if (duplicateForms.length > 1) {
        for (int i = 1; i < duplicateForms.length; i++) {
          final duplicateForm = duplicateForms[i];
          final data = duplicateForm.data() as Map<String, dynamic>?;
          final formDetailsRef = data?['formDetailsId'] as DocumentReference?;
          final taskRef = data?['taskId'] as DocumentReference?;

          // Delete the ppirForm
          // debugPrint('Deleting ppirForm: ${duplicateForm.id}');
          deletionFutures.add(duplicateForm.reference.delete());

          // Delete the formDetails
          if (formDetailsRef != null) {
            // debugPrint('Deleting formDetailsRef: ${formDetailsRef.id}');
            try {
              final formDetailsSnapshot = await formDetailsRef.get();
              if (formDetailsSnapshot.exists) {
                final formDetailsData =
                    formDetailsSnapshot.data() as Map<String, dynamic>?;
                final relatedTaskRef =
                    formDetailsData?['taskId'] as DocumentReference?;

                // Delete the related task
                if (relatedTaskRef != null) {
                  // debugPrint('Deleting related taskRef from formDetails: ${relatedTaskRef.id}')
                  deletionFutures.add(relatedTaskRef.delete());
                }

                // Delete the formDetails
                deletionFutures.add(formDetailsRef.delete());
              }
            } catch (e) {
              // debugPrint('Error deleting formDetailsRef: ${formDetailsRef.id}, error: $e')
            }
          }

          // Delete the task
          if (taskRef != null) {
            // debugPrint('Deleting taskRef: ${taskRef.id}');
            try {
              final taskSnapshot = await taskRef.get();
              if (taskSnapshot.exists) {
                final taskData = taskSnapshot.data() as Map<String, dynamic>?;
                final relatedFormDetailsRef =
                    taskData?['formDetailsId'] as DocumentReference?;

                // Delete the related formDetails
                if (relatedFormDetailsRef != null) {
                  // debugPrint('Deleting related formDetailsRef from task: ${relatedFormDetailsRef.id}')
                  deletionFutures.add(relatedFormDetailsRef.delete());
                }

                // Delete the task
                deletionFutures.add(taskRef.delete());
              }
            } catch (e) {
              // debugPrint('Error deleting taskRef: ${taskRef.id}, error: $e');
            }
          }
        }
      }
    }

    await Future.wait(deletionFutures);
    // debugPrint('Deletion of duplicate forms completed.');
  }

  static Map<String, dynamic> _createTaskData(
      List<dynamic> row, String taskId, DocumentReference formDetailsRef) {
    return {
      'assignee': FirebaseFirestore.instance
          .collection('users')
          .doc(row[5]?.toString().trim() ?? ''),
      'assignor': null, // Assign appropriate assignor
      'formDetailsId': formDetailsRef,
      'dateCreated': FieldValue.serverTimestamp(),
      'dateAccess': FieldValue.serverTimestamp(),
      'status': row[4]?.toString().trim() ?? '',
    };
  }

  static Map<String, dynamic> _createFormDetailsData(
      List<dynamic> row, String formDetailsId, DocumentReference taskRef) {
    return {
      'taskId': taskRef,
      'formId':
          FirebaseFirestore.instance.collection('ppirForms').doc(formDetailsId),
      'type': row[2]?.toString().trim() ?? '',
    };
  }

  static Map<String, dynamic> _createPPIRFormData(
      List<dynamic> row, String ppirFormId, DocumentReference taskRef) {
    return {
      'taskId': taskRef,
      'generatedFilename': '',
      'taskManagerNumber': row[7]?.toString().trim() ?? '',
      'serviceGroup': row[1]?.toString().trim() ?? '',
      'serviceType': row[2]?.toString().trim() ?? '',
      'priority': row[3]?.toString().trim() ?? '',
      'status': row[4]?.toString().trim() ?? '',
      'assigneeId': row[5]?.toString().trim() ?? '',
      'ppirAssignmentId': row[6]?.toString().trim() ?? '',
      'ppirInsuranceId': row[7]?.toString().trim() ?? '',
      'ppirFarmerName': row[8]?.toString().trim() ?? '',
      'ppirAddress': row[9]?.toString().trim() ?? '',
      'ppirFarmerType': row[10]?.toString().trim() ?? '',
      'ppirMobileNo': row[11]?.toString().trim() ?? '',
      'ppirGroupName': row[12]?.toString().trim() ?? '',
      'ppirGroupAddress': row[13]?.toString().trim() ?? '',
      'ppirLenderName': row[14]?.toString().trim() ?? '',
      'ppirLenderAddress': row[15]?.toString().trim() ?? '',
      'ppirCicNo': row[16]?.toString().trim() ?? '',
      'ppirFarmLoc': row[17]?.toString().trim() ?? '',
      'ppirNorth': row[18]?.toString().trim() ?? '',
      'ppirSouth': row[19]?.toString().trim() ?? '',
      'ppirEast': row[20]?.toString().trim() ?? '',
      'ppirWest': row[21]?.toString().trim() ?? '',
      'ppirAtt1': row[22]?.toString().trim() ?? '',
      'ppirAtt2': row[23]?.toString().trim() ?? '',
      'ppirAtt3': row[24]?.toString().trim() ?? '',
      'ppirAtt4': row[25]?.toString().trim() ?? '',
      'ppirAreaAci': row[26]?.toString().trim() ?? '',
      'ppirAreaAct': row[27]?.toString().trim() ?? '',
      'ppirDopdsAci': row[28]?.toString().trim() ?? '',
      'ppirDopdsAct': row[29]?.toString().trim() ?? '',
      'ppirDoptpAci': row[30]?.toString().trim() ?? '',
      'ppirDoptpAct': row[31]?.toString().trim() ?? '',
      'ppirSvpAci': row[32]?.toString().trim() ?? '',
      'ppirSvpAct': row[33]?.toString().trim() ?? '',
      'ppirVariety': row[34]?.toString().trim() ?? '',
      'ppirStagecrop': row[35]?.toString().trim() ?? '',
      'ppirRemarks': row[36]?.toString().trim() ?? '',
      'ppirNameInsured': row[37]?.toString().trim() ?? '',
      'ppirNameIuia': row[38]?.toString().trim() ?? '',
      'ppirSigInsured': row[39]?.toString().trim() ?? '',
      'ppirSigIuia': row[40]?.toString().trim() ?? '',
      'trackTotalarea': '',
      'trackDatetime': FieldValue.serverTimestamp(),
      'trackLastcoord': '',
      'trackTotaldistance': '',
    };
  }

  static Future<void> _createNewTaskAndRelatedDocuments(
      List<dynamic> row) async {
    final ppirInsuranceId = row[7]?.toString().trim() ?? '';
    final assigneeEmail = row[5]?.toString().trim() ?? '';
    final ppirAssignmentId = row[6]?.toString().trim() ?? '';

    if (ppirInsuranceId.isNotEmpty &&
        assigneeEmail.isNotEmpty &&
        ppirAssignmentId.isNotEmpty) {
      final existingPPIRForms = await FirebaseFirestore.instance
          .collection('ppirForms')
          .where('ppirInsuranceId', isEqualTo: ppirInsuranceId)
          .get();

      if (existingPPIRForms.docs.isEmpty) {
        final taskRef = FirebaseFirestore.instance.collection('tasks').doc();
        final formDetailsRef =
            FirebaseFirestore.instance.collection('formDetails').doc();
        final ppirFormRef =
            FirebaseFirestore.instance.collection('ppirForms').doc();

        final taskData = _createTaskData(row, taskRef.id, formDetailsRef);
        final formDetailsData =
            _createFormDetailsData(row, ppirFormRef.id, taskRef);
        final ppirFormData = _createPPIRFormData(row, ppirFormRef.id, taskRef);

        final batch = FirebaseFirestore.instance.batch();
        batch.set(taskRef, taskData);
        batch.set(formDetailsRef, formDetailsData);
        batch.set(ppirFormRef, ppirFormData);
        await batch.commit();
      } else {
        // debugPrint('Duplicate PPIR form detected with ppirInsuranceId: $ppirInsuranceId')
      }
    }
  }

  Future<String?> get taskManagerNumber async {
    try {
      final formData = await getFormData(type);
      return formData['ppirInsuranceId'] as String?;
    } catch (error) {
      // debugPrint('Error retrieving Task Number: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>> getFormData(String formType) async {
    final db = FirebaseFirestore.instance;
    final document = await db.collection('ppirForms').doc(formId).get();

    if (document.exists) {
      return document.data() ?? {};
    }

    return {};
  }

  Future<void> assignTaskManagerNumberToFormData(
      String taskManagerNumber) async {
    final db = FirebaseFirestore.instance;

    await db.collection(type).doc(formId).update({
      'taskManagerNumber': taskManagerNumber,
    });
  }

  Future<String?> get farmerName async {
    try {
      final formData = await getFormData(type);
      return formData['ppirFarmerName'] as String?;
    } catch (error) {
      // debugPrint('Error retrieving farmer name: $error');
      return null;
    }
  }

  Future<String?> get status async {
    try {
      final taskSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (taskSnapshot.exists) {
        final taskData = taskSnapshot.data();
        return taskData?['status'] as String?;
      }
    } catch (error) {
      // debugPrint('Error retrieving task status: $error');
    }
    return null;
  }

  static Future<void> saveTaskFileToFirebaseStorage(
      String formId, Map<String, dynamic> formData) async {
    try {
      final xmlContent = await generateTaskXmlContent(formId, formData);
      final storageRef =
          FirebaseStorage.instance.ref().child('PPIR_SAVES/$formId/Task.xml');
      await storageRef.putString(xmlContent);
    } catch (e) {
      debugPrint('Error saving task file: $e');
      throw Exception('Error saving task file');
    }
  }

  static Future<void> uploadFileToFTP(File file) async {
    // Replace these with your FTP server details
    const String ftpHost = '122.55.242.110';
    const int ftpPort = 21;
    const String ftpUser = 'k2c_User2';
    const String ftpPassword = 'K2C@PC!C2024';

    FTPConnect ftpConnect =
        FTPConnect(ftpHost, port: ftpPort, user: ftpUser, pass: ftpPassword);

    try {
      await ftpConnect.connect();
      debugPrint('Connected to FTP server');

      await ftpConnect.changeDirectory('taskarchive');
      debugPrint('Changed directory to taskarchive');

      bool result = await ftpConnect.uploadFileWithRetry(file, pRetryCount: 2);
      debugPrint('Upload result: $result');

      await ftpConnect.disconnect();
      debugPrint('Disconnected from FTP server');
    } catch (e) {
      debugPrint('Error uploading file to FTP server: $e');
      throw Exception('Error uploading file to FTP server: $e');
    } finally {
      await ftpConnect.disconnect();
    }
  }

  static Future<void> compressAndUploadTaskFiles(
      String formId, String taskId) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('PPIR_SAVES/$formId');
      final List<Reference> allFiles = await _getAllFiles(storageRef);

      // Directory to store downloaded files temporarily
      final tempDir = await getTemporaryDirectory();
      final tempDirPath = tempDir.path;

      // Archive creation
      final archive = Archive();

      // Download each file and add it to the archive
      for (final fileRef in allFiles) {
        final String fileName =
            fileRef.fullPath.replaceFirst('PPIR_SAVES/$formId/', '');
        final File tempFile = File('$tempDirPath/$fileName');
        await tempFile.parent.create(recursive: true);
        final DownloadTask downloadTask = fileRef.writeToFile(tempFile);
        await downloadTask.whenComplete(() async {
          final List<int> fileBytes = await tempFile.readAsBytes();
          archive.addFile(ArchiveFile(fileName, fileBytes.length, fileBytes));
        });
      }

      // Encode the archive to a zip file
      final ZipEncoder encoder = ZipEncoder();
      final List<int>? zipData = encoder.encode(archive);

      // Save the zip file temporarily
      final zipFile = File('$tempDirPath/$taskId.task');
      await zipFile.writeAsBytes(zipData!);

      // Upload the zip file to Firebase Storage
      final compressedRef = FirebaseStorage.instance
          .ref()
          .child('PPIR_SAVES/tasks_saves/$taskId.task');
      await compressedRef.putFile(zipFile);

      // Upload to FTP server
      await uploadFileToFTP(zipFile);

      // Delete the temporary file
      await zipFile.delete();

      // debugPrint('Task files compressed and uploaded successfully.');
    } catch (e) {
      // debugPrint('Error compressing and uploading task files: $e');
      throw Exception('Error compressing and uploading task files');
    }
  }

  static Future<List<Reference>> _getAllFiles(Reference storageRef) async {
    List<Reference> allFiles = [];
    final ListResult result = await storageRef.listAll();

    for (final ref in result.items) {
      allFiles.add(ref);
    }

    for (final prefix in result.prefixes) {
      allFiles.addAll(await _getAllFiles(prefix));
    }

    return allFiles;
  }

  Future<DateTime?> get dateAccess async {
    try {
      final taskSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (taskSnapshot.exists) {
        final taskData = taskSnapshot.data();
        final timestamp = taskData?['dateAccess'] as Timestamp?;
        return timestamp?.toDate();
      }
    } catch (error) {
      // debugPrint('Error retrieving task date access: $error');
    }
    return null;
  }

  Future<String?> get north async {
    try {
      final formData = await getFormData(type);
      return formData['ppirNorth'] as String?;
    } catch (error) {
      // debugPrint('Error retrieving north coordinate: $error');
      return null;
    }
  }

  Future<String?> get south async {
    try {
      final formData = await getFormData(type);
      return formData['ppirSouth'] as String?;
    } catch (error) {
      // debugPrint('Error retrieving south coordinate: $error');
      return null;
    }
  }

  Future<String?> get east async {
    try {
      final formData = await getFormData(type);
      return formData['ppirEast'] as String?;
    } catch (error) {
      // debugPrint('Error retrieving east coordinate: $error');
      return null;
    }
  }

  Future<String?> get west async {
    try {
      final formData = await getFormData(type);
      return formData['ppirWest'] as String?;
    } catch (error) {
      // debugPrint('Error retrieving west coordinate: $error');
      return null;
    }
  }

  Future<String?> get gpxFile async {
    try {
      final formData = await getFormData(type);
      return formData['gpxFile'] as String?;
    } catch (error) {
      // debugPrint('Error retrieving gpxFile: $error');
      return null;
    }
  }

  Future<List<LatLng>?> get routePoints async {
    try {
      final formData = await getFormData(type);
      if (formData['routePoints'] != null) {
        List<dynamic> points = formData['routePoints'];
        return points
            .map((point) => LatLng(
                  double.parse(point.split(',')[0]),
                  double.parse(point.split(',')[1]),
                ))
            .toList();
      }
      return null;
    } catch (error) {
      // debugPrint('Error retrieving routePoints: $error');
      return null;
    }
  }

  Future<LatLng?> get lastCoordinates async {
    try {
      final formData = await getFormData(type);
      if (formData['trackLastcoord'] != null) {
        List<String> lastCoord = formData['trackLastcoord'].split(',');
        return LatLng(double.parse(lastCoord[0]), double.parse(lastCoord[1]));
      }
      return null;
    } catch (error) {
      // debugPrint('Error retrieving lastCoordinates: $error');
      return null;
    }
  }

  static Future<void> saveTaskToXML(
      Map<String, dynamic> taskData, Map<String, dynamic> formData) async {
    try {
      final directory = await getExternalStorageDirectory();
      final dataDirectory =
          directory?.path ?? '/storage/emulated/0/Android/data';

      final baseFilename = formData['formId'] ?? 'unknown_form';
      final insuranceDirectory = Directory('$dataDirectory/$baseFilename');

      // Create the insurance directory if it doesn't exist
      if (!await insuranceDirectory.exists()) {
        await insuranceDirectory.create(recursive: true);
      }

      // Define the Attachments directory inside the insurance directory
      final attachmentsDirectory =
          Directory('${insuranceDirectory.path}/Attachments');

      // Create the Attachments directory if it doesn't exist
      if (!await attachmentsDirectory.exists()) {
        await attachmentsDirectory.create(recursive: true);
      }

      final String fileName = 'task_${taskData['taskId']}.xml';
      final File xmlFile = File('${attachmentsDirectory.path}/$fileName');

      if (taskData.isNotEmpty && formData.isNotEmpty) {
        final builder = XmlBuilder();
        builder.processing('xml', 'version="1.0" encoding="UTF-8"');
        builder.element('Task', nest: () {
          builder.element('TaskId', nest: taskData['taskId']);
          builder.element('TaskNumber',
              nest: taskData['taskManagerNumber'] ?? '');
          builder.element('FormType', nest: formData['serviceType'] ?? '');
          builder.element('Audit', nest: () {
            builder.element('TaskAuditLogZipModel', nest: () {
              builder.element('AuditLevel', nest: 'Task');
              builder.element('Label', nest: 'Task Owner');
              builder.element('Message', nest: taskData['assigneeId'] ?? '');
              builder.element('SnapshotValue', nest: 'Office Clerk');
              builder.element('Source', nest: taskData['assigneeId'] ?? '');
              builder.element('TaskId', nest: taskData['taskId']);
              builder.element('Timestamp',
                  nest: taskData['dateAccess']?.toString() ?? '');
              builder.element('UpdatedValue',
                  nest: taskData['assigneeEmail'] ?? '');
              builder.element('FieldLabel', nest: 'Task Owner');
              builder.element('IPAddress', nest: '');
            });
          });

          builder.element('Details', nest: () {
            builder.element('TaskDetailZipModel', nest: () {
              builder.element('ServiceType',
                  nest: formData['serviceType'] ?? '');
              builder.element('TaskStatus', nest: taskData['status'] ?? '');
              builder.element('TaskOwner',
                  nest: taskData['assigneeEmail'] ?? '');
            });
          });
        });

        final xmlDocument = builder.buildDocument();
        await xmlFile
            .writeAsString(xmlDocument.toXmlString(pretty: true, indent: '\t'));
        // debugPrint('Task XML saved successfully.');
      } else {
        // debugPrint('No task data or form data available to save.');
      }
    } catch (error) {
      // debugPrint('Error saving Task XML: $error');
    }
  }

  Future<void> updateTaskStatus(String status) async {
    try {
      final taskRef =
          FirebaseFirestore.instance.collection('tasks').doc(taskId);
      await taskRef.update({'status': status});
      // debugPrint('Task status updated to $status');
    } catch (e) {
      // debugPrint('Error updating task status: $e');
      throw Exception('Error updating task status');
    }
  }
}
