// ftp_service.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart' as log;

class FTPService {
  static const String _ftpHost = '122.55.242.110';
  static const int _ftpPort = 21;
  static const String _ftpUserUpload = 'k2c_User2';
  static const String _ftpPasswordUpload = 'K2C@PC!C2024';
  static const String _ftpUserSync = 'k2c_User1';
  static const String _ftpPasswordSync = 'K2C@PC!C2024';

  static final log.Logger _logger = log.Logger('FTPService');

  static Future<void> uploadTask(File file) async {
    FTPConnect ftpConnect = FTPConnect(
      _ftpHost,
      port: _ftpPort,
      user: _ftpUserUpload,
      pass: _ftpPasswordUpload,
    );

    try {
      await ftpConnect.connect();
      await ftpConnect.changeDirectory('taskarchive');
      await ftpConnect.uploadFileWithRetry(file, pRetryCount: 2);
    } catch (e) {
      _logError('Error uploading file to FTP server: $e');
      throw Exception('Error uploading file to FTP server: $e');
    } finally {
      await ftpConnect.disconnect();
    }
  }

  static Future<List<String>> syncTask() async {
    FTPConnect ftpConnect = FTPConnect(
      _ftpHost,
      port: _ftpPort,
      user: _ftpUserSync,
      pass: _ftpPasswordSync,
    );
    List<String> csvContents = [];

    try {
      await ftpConnect.connect();
      await ftpConnect.changeDirectory('Work');

      List<FTPEntry> ftpFiles = await ftpConnect.listDirectoryContent();

      Directory tempDir = await getTemporaryDirectory();
      for (FTPEntry ftpFile in ftpFiles) {
        if (ftpFile.type == FTPEntryType.FILE &&
            ftpFile.name.endsWith('.csv')) {
          bool isProcessed = await _isFileProcessed(ftpFile.name);
          if (isProcessed) continue;

          String localPath = '${tempDir.path}/${ftpFile.name}';
          File localFile = File(localPath);
          await ftpConnect.downloadFile(ftpFile.name, localFile);

          String fileContent = await localFile.readAsString();
          csvContents.add(fileContent);

          await _markFileAsProcessed(ftpFile.name);
          await _updateTasksWithFTPFile(ftpFile.name);

          await localFile.delete();
        }
      }
    } catch (e) {
      _logError('Error downloading files from FTP: $e');
      throw Exception('Error downloading files from FTP: $e');
    } finally {
      await ftpConnect.disconnect();
    }

    return csvContents;
  }

  static Future<bool> _isFileProcessed(String fileName) async {
    final processedFileSnapshot = await FirebaseFirestore.instance
        .collection('processedFiles')
        .doc(fileName)
        .get();
    return processedFileSnapshot.exists;
  }

  static Future<void> _markFileAsProcessed(String fileName) async {
    await FirebaseFirestore.instance
        .collection('processedFiles')
        .doc(fileName)
        .set({'processedAt': Timestamp.now()});
  }

  static Future<void> _updateTasksWithFTPFile(String fileName) async {
    final tasksSnapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('ftpFileName', isEqualTo: fileName)
        .get();

    if (tasksSnapshot.docs.isNotEmpty) {
      for (final taskDoc in tasksSnapshot.docs) {
        await taskDoc.reference.update({'ftpFileName': fileName});
      }
    }
  }

  static void _logError(String message) {
    _logger.severe(message);
  }
}
