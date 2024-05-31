import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

import '../../tasks/controllers/csv_parser.dart';
import '../../tasks/controllers/firebase_service.dart';
import '../../tasks/controllers/ftp_service.dart';

class SyncController {
  final FTPService _ftpService = FTPService();
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> syncData() async {
    debugPrint("Starting data sync...");

    List<String> fileList = [];

    // Try to connect to the FTP server and get the file list
    try {
      await _tryConnectToFtp(fileList);
    } catch (e) {
      debugPrint('FTP connection failed after max retries: $e');
    }

    // If fileList is still empty, try to read from local files
    if (fileList.isEmpty) {
      try {
        await _readFilesLocally(fileList);
      } catch (localReadError) {
        debugPrint("Error reading local files: $localReadError");
      }
    }

    // Process the files if any were found
    if (fileList.isEmpty) {
      debugPrint("No files found to process.");
    } else {
      await _processFiles(fileList);
    }

    debugPrint("Data sync completed successfully.");
  }

  Future<void> _tryConnectToFtp(List<String> fileList) async {
    const maxRetries = 3;
    var retryCount = 0;
    var retryDelay = const Duration(seconds: 1);

    while (retryCount < maxRetries) {
      try {
        debugPrint(
            'Attempting to connect to FTP server... (Attempt $retryCount)');
        await _ftpService.connectSync();
        debugPrint(
            "Successfully connected to FTP server. Retrieving file list...");
        fileList.addAll(await _ftpService.getFileList());
        debugPrint("Received file list from FTP server: $fileList");
        debugPrint("Disconnecting from FTP server...");
        await _ftpService.disconnectSync();
        debugPrint("Disconnected from FTP server.");
        return;
      } catch (e) {
        debugPrint('FTP connection error: $e');
        if (retryCount < maxRetries - 1) {
          debugPrint('Retrying in ${retryDelay.inSeconds} seconds...');
          await Future.delayed(retryDelay);
          retryDelay *= 2;
          retryCount++;
        } else {
          throw Exception(
              'Failed to connect to FTP server after $maxRetries retries');
        }
      }
    }
  }

  Future<void> _readFilesLocally(List<String> fileList) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    debugPrint("AssetManifest.json content: $manifestContent");

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    debugPrint("Parsed AssetManifest.json content: $manifestMap");

    fileList.addAll(manifestMap.keys
        .where((filePath) =>
            filePath.startsWith('assets/storage/ftp/Work/') &&
            filePath.endsWith('.csv') &&
            !filePath.contains('@Recycle'))
        .toList());
    debugPrint("Filtered local file list: $fileList");
  }

  Future<void> _processFiles(List<String> fileList) async {
    for (final filePath in fileList) {
      final fileName = filePath.split('/').last;
      debugPrint("Processing file: $fileName");

      final fileRead = await _firebaseService.isFileRead(fileName);
      debugPrint("File read status for $fileName: $fileRead");

      if (!fileRead) {
        String csvContent;
        if (_ftpService.isConnected) {
          debugPrint("Downloading CSV content from FTP for file: $filePath");
          csvContent = await _ftpService.downloadFile(fileName);
        } else {
          debugPrint("Reading CSV content from local file: $filePath");
          csvContent = await rootBundle.loadString(filePath);
        }
        debugPrint("CSV content: $csvContent");

        debugPrint("Parsing CSV content...");
        final csvData = CSVParser.parseCSV(csvContent);
        debugPrint("Parsed CSV data: $csvData");

        for (final rowData in csvData) {
          final userEmail = rowData['Assignee'];
          debugPrint("Checking if user exists: $userEmail");
          final isUserExists = await _firebaseService.isUserExists(userEmail);
          debugPrint("User exists status for $userEmail: $isUserExists");

          if (!isUserExists) {
            debugPrint("User does not exist, creating user...");
            final userData = extractUserData(rowData);
            await _firebaseService.createUser(userData);
            debugPrint("User created: $userData");
          }

          debugPrint("Creating task...");
          final taskData = extractTaskData(rowData);
          await _firebaseService.createTask(taskData);
          debugPrint("Task created: $taskData");
        }

        debugPrint("Marking file as read: $fileName");
        await _firebaseService.updateFilesRead(fileName);
        debugPrint("File marked as read: $fileName");
      }
    }
  }

  Map<String, dynamic> extractUserData(Map<String, dynamic> rowData) {
    return {
      'name': rowData['ppir_name_iuia'] ?? '',
      'email': rowData['Assignee'] ?? '',
      'profilePicUrl': '',
      'role': 'user',
      'isVerified': false,
      'isActive': true,
    };
  }

  Map<String, dynamic> extractTaskData(Map<String, dynamic> rowData) {
    return {
      'task_number': rowData['Task Number'] ?? '',
      'service_group': rowData['Service Group'] ?? '',
      'service_type': rowData['Service Type'] ?? '',
      'priority': rowData['Priority'] ?? '',
      'task_status': rowData['Task Status'] ?? '',
      'assignee': rowData['Assignee'] ?? '',
      'ppir_assignmentid': rowData['ppir_assignmentid'] ?? '',
      'ppir_insuranceid': rowData['ppir_insuranceid'] ?? '',
      'ppir_farmername': rowData['ppir_farmername'] ?? '',
      'ppir_address': rowData['ppir_address'] ?? '',
      'ppir_farmertype': rowData['ppir_farmertype'] ?? '',
      'ppir_mobileno': rowData['ppir_mobileno'] ?? '',
      'ppir_groupname': rowData['ppir_groupname'] ?? '',
      'ppir_groupaddress': rowData['ppir_groupaddress'] ?? '',
      'ppir_lendername': rowData['ppir_lendername'] ?? '',
      'ppir_lenderaddress': rowData['ppir_lenderaddress'] ?? '',
      'ppir_cicno': rowData['ppir_cicno'] ?? '',
      'ppir_farmloc': rowData['ppir_farmloc'] ?? '',
      'ppir_north': rowData['ppir_north'] ?? '',
      'ppir_south': rowData['ppir_south'] ?? '',
      'ppir_east': rowData['ppir_east'] ?? '',
      'ppir_west': rowData['ppir_west'] ?? '',
      'ppir_att_1': rowData['ppir_att_1'] ?? '',
      'ppir_att_2': rowData['ppir_att_2'] ?? '',
      'ppir_att_3': rowData['ppir_att_3'] ?? '',
      'ppir_att_4': rowData['ppir_att_4'] ?? '',
      'ppir_area_aci': rowData['ppir_area_aci'] ?? '',
      'ppir_area_act': rowData['ppir_area_act'] ?? '',
      'ppir_dopds_aci': rowData['ppir_dopds_aci'] ?? '',
      'ppir_dopds_act': rowData['ppir_dopds_act'] ?? '',
      'ppir_doptp_aci': rowData['ppir_doptp_aci'] ?? '',
      'ppir_doptp_act': rowData['ppir_doptp_act'] ?? '',
      'ppir_svp_aci': rowData['ppir_svp_aci'] ?? '',
      'ppir_svp_act': rowData['ppir_svp_act'] ?? '',
      'ppir_variety': rowData['ppir_variety'] ?? '',
      'ppir_stagecrop': rowData['ppir_stagecrop'] ?? '',
      'ppir_remarks': rowData['ppir_remarks'] ?? '',
      'ppir_name_insured': rowData['ppir_name_insured'] ?? '',
      'ppir_name_iuia': rowData['ppir_name_iuia'] ?? '',
      'ppir_sig_insured': rowData['ppir_sig_insured'] ?? '',
      'ppir_sig_iuia': rowData['ppir_sig_iuia'] ?? '',
      'isPPIR': rowData['isPPIR'] ?? false,
      'formId': rowData['formId'] ?? '',
    };
  }
}
