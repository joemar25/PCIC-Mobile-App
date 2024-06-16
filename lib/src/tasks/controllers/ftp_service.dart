// src/tasks/controllers/ftp_service.dart
import 'dart:io';
import 'package:ftpconnect/ftpconnect.dart';

class FTPService {
  final String _ftpHost = '122.55.242.110';
  final int _ftpPort = 21;
  final String _ftpUserUpload = 'k2c_User2';
  final String _ftpPasswordUpload = 'K2C@PC!C2024';
  final String _ftpUserSync = 'k2c_User1';
  final String _ftpPasswordSync = 'K2C@PC!C2024';
  final String _workDirectory = '/Work';
  final String _uploadDirectory = '/taskarchive';

  late FTPConnect _ftpConnectSync;
  late FTPConnect _ftpConnectUpload;
  bool _isConnectedSync = false;

  FTPService() {
    _ftpConnectSync = FTPConnect(_ftpHost,
        port: _ftpPort,
        user: _ftpUserSync,
        pass: _ftpPasswordSync,
        timeout: 10);
  }

  Future<bool> connectSync() async {
    // debugPrint('Connecting to FTP server...');
    try {
      await _ftpConnectSync.connect();
      await _ftpConnectSync.changeDirectory(_workDirectory);
      _isConnectedSync = true;
      return true;
    } catch (e) {
      _isConnectedSync = false;
      // debugPrint('Failed to connect to FTP or change directory: $e');
      return false;
    }
  }

  Future<void> connectUpload() async {
    _ftpConnectUpload = FTPConnect(_ftpHost,
        port: _ftpPort,
        user: _ftpUserUpload,
        pass: _ftpPasswordUpload,
        timeout: 10);

    try {
      await _ftpConnectUpload.connect();
      await _ftpConnectUpload.changeDirectory(_uploadDirectory);
    } catch (e) {
      // debugPrint('Failed to connect to FTP or change directory: $e');
      throw Exception('Failed to connect to FTP or change directory');
    }
  }

  Future<void> disconnectSync() async {
    // debugPrint('Disconnecting from FTP server...');
    try {
      await _ftpConnectSync.disconnect();
      _isConnectedSync = false;
    } catch (e) {
      // debugPrint('Failed to disconnect from FTP: $e');
      throw Exception('Failed to disconnect from FTP');
    }
    // debugPrint('Disconnected from FTP server');
  }

  Future<void> disconnectUpload() async {
    try {
      await _ftpConnectUpload.disconnect();
    } catch (e) {
      // debugPrint('Failed to disconnect from FTP: $e');
      throw Exception('Failed to disconnect from FTP');
    }
  }

  Future<List<String>> getFileList() async {
    try {
      // debugPrint('Getting file list from FTP...');
      final fileList = await _ftpConnectSync.listDirectoryContent();
      // debugPrint('File list: $fileList');

      return fileList
          .where((file) =>
              file.type == FTPEntryType.FILE &&
              file.name.endsWith('.csv') &&
              !file.name.contains('@Recycle'))
          .map((file) => file.name)
          .toList();
    } catch (e) {
      // debugPrint('Failed to get file list from FTP: $e');
      throw Exception('Failed to get file list from FTP');
    }
  }

  Future<String> downloadFile(String fileName) async {
    try {
      // debugPrint('Downloading file from FTP: $_workDirectory/$fileName');

      final tempDir = await Directory.systemTemp.createTemp();
      final localFilePath = '${tempDir.path}/$fileName';

      final file = File(localFilePath);
      await _ftpConnectSync.downloadFile(fileName, file);

      final csvContent = await file.readAsString();
      await file.delete();

      // debugPrint('CSV Content: $csvContent');

      return csvContent;
    } catch (e) {
      // debugPrint('Failed to download file from FTP: $e');
      throw Exception('Failed to download file from FTP');
    }
  }

  Future<void> uploadTask(File file) async {
    try {
      await _ftpConnectUpload.uploadFileWithRetry(file, pRetryCount: 2);
    } catch (e) {
      // debugPrint('Error uploading file to FTP server: $e');
      throw Exception('Error uploading file to FTP server');
    }
  }

  bool get isConnected => _isConnectedSync;
}
