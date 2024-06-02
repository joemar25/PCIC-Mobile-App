import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';
import 'package:logging/logging.dart';
import 'ftp_service.dart';
import 'task_xml_generator.dart';

class StorageService {
  static final Logger _logger = Logger('StorageService');
  static final FTPService _ftpService = FTPService();

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

  static Future<void> compressAndUploadTaskFiles(String taskId) async {
    try {
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      final tempDirPath = tempDir.path;
      final zipFilePath = '$tempDirPath/$taskId.task';

      // Download files from Firebase Storage and save them in the temporary directory
      await _downloadFilesFromFirebase(taskId, tempDirPath);

      // Create ZipFileEncoder
      final encoder = ZipFileEncoder();
      encoder.create(zipFilePath);

      // Add the entire task folder to the zip file
      final taskDir = Directory('$tempDirPath/PPIR_SAVES/$taskId');
      if (!await taskDir.exists()) {
        _logger.severe('Task directory does not exist: $taskDir');
        throw Exception('Task directory does not exist: $taskDir');
      }
      encoder.addDirectory(taskDir);

      // Close the encoder to finalize the zip file
      encoder.close();

      // Create File instance for the zip file
      final zipFile = File(zipFilePath);

      // Upload to Firebase Storage
      await _uploadToFirebase(taskId, zipFile);

      // Upload to FTP Server
      await _uploadToFTP(zipFile);

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
      if (!await file.exists()) {
        await file.create(recursive: true);
      }
      final bytes = await item.getData();
      await file.writeAsBytes(bytes!);
    }
    for (var prefix in listResult.prefixes) {
      await _downloadDirectoryFromFirebase(prefix, '$localPath/${prefix.name}');
    }
  }

  static Future<void> _uploadToFirebase(String taskId, File file) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('PPIR_SAVES/submitted_tasks/$taskId.task');
      await storageRef.putFile(file);
    } catch (e) {
      _logger.severe('Error uploading file to Firebase Storage: $e');
      throw Exception('Error uploading file to Firebase Storage');
    }
  }

  static Future<void> _uploadToFTP(File file) async {
    try {
      await _ftpService.connectUpload();
      await _ftpService.uploadTask(file);
      await _ftpService.disconnectUpload();
    } catch (e) {
      _logger.severe('Error uploading file to FTP server: $e');
      throw Exception('Error uploading file to FTP server');
    }
  }
}
