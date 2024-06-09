import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../tasks/controllers/csv_parser.dart';
import '../../tasks/controllers/firebase_service.dart';
import '../../tasks/controllers/ftp_service.dart';

class SyncController {
  final FTPService _ftpService = FTPService();
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> syncData() async {
    List<String> fileList = [];

    final isFTPConnected = await _tryConnectToFtp();

    if (isFTPConnected) {
      try {
        fileList = await _ftpService.getFileList();
      } catch (e) {
        debugPrint('Failed to get file list from FTP: $e');
      }
    }

    if (fileList.isEmpty) {
      try {
        await _readFilesLocally(fileList);
      } catch (localReadError) {
        debugPrint("Error reading local files: $localReadError");
      }
    }

    if (fileList.isNotEmpty) {
      await _processFiles(fileList);
    } else {
      debugPrint("No files found to process.");
    }
  }

  Future<bool> _tryConnectToFtp() async {
    const maxRetries = 3;
    var retryCount = 0;
    var retryDelay = const Duration(seconds: 1);

    while (retryCount < maxRetries) {
      debugPrint(
          'Attempting to connect to FTP server... (Attempt $retryCount)');
      final isConnected = await _ftpService.connectSync();
      if (isConnected) {
        debugPrint("Successfully connected to FTP server.");
        return true;
      } else {
        if (retryCount < maxRetries - 1) {
          await Future.delayed(retryDelay);
          retryDelay *= 2;
          retryCount++;
        } else {
          debugPrint(
              'Failed to connect to FTP server after $maxRetries retries');
          return false;
        }
      }
    }
    return false;
  }

  Future<void> _readFilesLocally(List<String> fileList) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final localFiles = manifestMap.keys
        .where((filePath) =>
            filePath.startsWith('assets/storage/ftp/Work/') &&
            filePath.endsWith('.csv') &&
            !filePath.contains('@Recycle'))
        .toList();

    for (final filePath in localFiles) {
      final fileName = filePath.split('/').last;
      final csvContent = await rootBundle.loadString(filePath);
      final csvData = CSVParser.parseCSV(csvContent);

      for (final rowData in csvData) {
        final userEmail = rowData['Assignee'] ?? '';
        final isUserExists = await _firebaseService.isUserExists(userEmail);

        final fileNameWithoutExtension =
            fileName.replaceFirst(RegExp(r'\.[^\.]+$'), ' ');
        rowData['filename'] = fileNameWithoutExtension +
            (rowData['ppir_insuranceid']?.toString() ?? '');
        debugPrint('filename: $fileName');

        if (!isUserExists) {
          final userData = extractUserData(rowData);
          await _createUserForSync(userData);
        }

        final taskData = extractTaskData(rowData);
        await _firebaseService.createTask(taskData);
      }

      await _firebaseService.updateFilesRead(fileName);
      fileList.add(fileName);
    }
  }

  Future<void> _processFiles(List<String> fileList) async {
    await _ftpService.connectSync();
    try {
      for (final fileName in fileList) {
        final shortFileName = fileName.split('/').last;
        final fileRead = await _firebaseService.isFileRead(shortFileName);

        if (!fileRead) {
          String csvContent;
          try {
            csvContent = await _ftpService.downloadFile(shortFileName);
          } catch (e) {
            continue;
          }

          final csvData = CSVParser.parseCSV(csvContent);
          final processedEmails = <String>[];

          await runZoned(() async {
            for (final rowData in csvData) {
              final userEmail = rowData['Assignee']?.toString() ?? '';

              if (!processedEmails.contains(userEmail)) {
                final isUserExists =
                    await _firebaseService.isUserExists(userEmail);

                if (!isUserExists) {
                  final userData = extractUserData(rowData);
                  await _createUserForSync(userData);
                }

                processedEmails.add(userEmail);
              }

              final fileNameWithoutExtension =
                  fileName.replaceFirst(RegExp(r'\.[^\.]+$'), ' ');
              rowData['filename'] = fileNameWithoutExtension +
                  (rowData['ppir_insuranceid']?.toString() ?? '');
              debugPrint('filename: $fileNameWithoutExtension');

              final taskData = extractTaskData(rowData);
              await _firebaseService.createTask(taskData);
            }
          }, zoneSpecification: ZoneSpecification(
            handleUncaughtError: (Zone self, ZoneDelegate parent, Zone zone,
                Object error, StackTrace stackTrace) {
              debugPrint('Error during syncing: $error');
              parent.handleUncaughtError(zone, error, stackTrace);
            },
          ));

          await _firebaseService.updateFilesRead(shortFileName);
        }
      }
    } finally {
      await _ftpService.disconnectSync();
    }
  }

  Future<void> _createUserForSync(Map<String, dynamic> userData) async {
    try {
      final isUserExists =
          await _firebaseService.isUserExists(userData['email']);

      if (!isUserExists) {
        final uid = await _firebaseService.createUserAccountWithoutSigningIn(
            userData['email'], 'password');
        if (uid != null) {
          await _firebaseService.createUserDocument(uid, userData);
        } else {
          throw Exception('User creation failed: UID is null');
        }
      } else {
        debugPrint(
            'User with email ${userData['email']} already exists. Skipping user creation.');
      }
    } catch (e) {
      debugPrint('Error creating user for sync: $e');
      rethrow;
    }
  }

  Map<String, dynamic> extractUserData(Map<String, dynamic> rowData) {
    return {
      'name': 'User',
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
      'filename': rowData['filename'] ?? "",
    };
  }
}
