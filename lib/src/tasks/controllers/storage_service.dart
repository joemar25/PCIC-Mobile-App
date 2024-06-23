// src/tasks/controllers/storage_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';
import 'package:logging/logging.dart';

import 'ftp_service.dart';
import 'task_xml_generator.dart';

class StorageService {
  static final Logger _logger = Logger('StorageService');
  static final FTPService _ftpService = FTPService();

  static Future<void> compressAndUploadTaskFiles(
      String filename, String taskId, String serviceGroup) async {
    try {
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      final tempDirPath = tempDir.path;
      final zipFilePath = '$tempDirPath/$filename.task';

      // Download files from Firebase Storage and save them in the temporary directory
      await _downloadFilesFromFirebase(taskId, tempDirPath);

      // Create ZipFileEncoder
      final encoder = ZipFileEncoder();
      encoder.create(zipFilePath);

      // Add the contents of the task folder to the zip file
      final taskDir = Directory('$tempDirPath/PPIR_SAVES/$taskId');
      if (!await taskDir.exists()) {
        _logger.severe('Task directory does not exist: $taskDir');
        throw Exception('Task directory does not exist: $taskDir');
      }

      final taskContents = taskDir.listSync(recursive: true);
      for (var file in taskContents) {
        if (file is File) {
          final relativePath = file.path.replaceFirst('${taskDir.path}/', '');
          encoder.addFile(file, relativePath);
        }
      }

      // Close the encoder to finalize the zip file
      encoder.close();

      // Create File instance for the zip file
      final zipFile = File(zipFilePath);

      // Upload to Firebase Storage within the service group folder
      await _uploadToFirebase(filename, zipFile, serviceGroup);

      // Upload to FTP Server
      await _uploadToFTP(zipFile, serviceGroup);

      // Delete the temporary zip file and directory after upload
      await zipFile.delete();
      await taskDir.delete(recursive: true);

      _logger.info('Files compressed and uploaded successfully.');
    } catch (e) {
      _logger.severe('Error compressing and uploading task files: $e');
      throw Exception('Error compressing and uploading task files');
    }
  }

  static Future<void> _downloadFilesFromFirebase(
      String taskId, String tempDirPath) async {
    await _downloadDirectoryFromFirebase(
        FirebaseStorage.instance.ref().child('PPIR_SAVES/$taskId'),
        '$tempDirPath/PPIR_SAVES/$taskId');
  }

  static Future<void> _downloadDirectoryFromFirebase(
      Reference storageRef, String localPath) async {
    final listResult = await storageRef.listAll();
    for (var item in listResult.items) {
      String filePath = '$localPath/${item.name}';
      if (localPath.contains('Attachments')) {
        filePath = filePath.replaceAll(RegExp(r'\.[^.]+$'), '');
      }
      final file = File(filePath);
      await file.create(recursive: true);
      final bytes = await item.getData();
      await file.writeAsBytes(bytes!);
    }
    for (var prefix in listResult.prefixes) {
      await _downloadDirectoryFromFirebase(prefix, '$localPath/${prefix.name}');
    }
  }

  static Future<void> _uploadToFirebase(
      String filename, File file, String serviceGroup) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('PPIR_SAVES/$serviceGroup/submitted_tasks/$filename.task');
      await storageRef.putFile(file);
    } catch (e) {
      _logger.severe('Error uploading file to Firebase Storage: $e');
      throw Exception('Error uploading file to Firebase Storage');
    }
  }

  static Future<void> _uploadToFTP(File file, String serviceGroup) async {
    try {
      _logger.info('Connecting to FTP server for upload...');
      await _ftpService.connectUpload(serviceGroup);
      _logger.info('Uploading task file to FTP server...');
      await _ftpService.uploadTask(file);
      _logger.info('Disconnecting from FTP server...');
      await _ftpService.disconnectUpload();
    } catch (e) {
      _logger.severe('Error uploading file to FTP server: $e');
      throw Exception('Error uploading file to FTP server');
    }
  }

  static Future<void> saveTaskFileToFirebaseStorage(String taskId) async {
    try {
      final xmlContent = await generateTaskXmlContent(taskId);
      final storageRef =
          FirebaseStorage.instance.ref().child('PPIR_SAVES/$taskId/Task.xml');
      await storageRef.putString(xmlContent);
    } catch (e) {
      _logger.severe('Error saving task file: $e');
      throw Exception('Error saving task file');
    }
  }

  static Future<void> downloadAndResubmitTaskFile(
      String filename, String taskId, String serviceGroup) async {
    try {
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      final tempDirPath = tempDir.path;
      final zipFilePath = '$tempDirPath/$filename.task';

      debugPrint(
          "filename: $filename, taskId: $taskId, serviceGroup: $serviceGroup");

      // Check if the task file exists in Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('PPIR_SAVES/$serviceGroup/submitted_tasks/$filename.task');
      final fileExists = await storageRef
          .getDownloadURL()
          .then((_) => true)
          .catchError((_) => false);

      if (fileExists) {
        // Download the task file from Firebase Storage
        final bytes = await storageRef.getData();
        final zipFile = File(zipFilePath);
        await zipFile.writeAsBytes(bytes!);

        // Upload to FTP Server
        await _uploadToFTP(zipFile, serviceGroup);

        // Delete the temporary zip file after upload
        await zipFile.delete();

        _logger.info('File downloaded and resubmitted successfully.');
      } else {
        _logger.severe(
            'Task file does not exist in Firebase Storage: $filename.task');
        throw Exception('Task file does not exist in Firebase Storage');
      }
    } catch (e) {
      _logger.severe('Error downloading and resubmitting file: $e');
      throw Exception('Error downloading and resubmitting file');
    }
  }
}
