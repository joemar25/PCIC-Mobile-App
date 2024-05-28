import 'dart:io';
import 'package:archive/archive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';
import 'ftp_service.dart';
import 'task_xml_generator.dart';

class StorageService {
  static final Logger _logger = Logger('StorageService');

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
      await FTPService.uploadTask(zipFile);

      // Delete the temporary file
      await zipFile.delete();
    } catch (e) {
      _logError('Error compressing and uploading task files: $e');
      throw Exception('Error compressing and uploading task files');
    }
  }

  static Future<void> saveTaskFileToFirebaseStorage(
      String formId, Map<String, dynamic> formData) async {
    try {
      final xmlContent = await generateTaskXmlContent(formId, formData);
      final storageRef =
          FirebaseStorage.instance.ref().child('PPIR_SAVES/$formId/Task.xml');
      await storageRef.putString(xmlContent);
    } catch (e) {
      _logError('Error saving task file: $e');
      throw Exception('Error saving task file');
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

  static void _logError(String message) {
    _logger.severe(message);
  }
}
