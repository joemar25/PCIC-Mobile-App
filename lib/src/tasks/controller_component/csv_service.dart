import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:logging/logging.dart';
import 'ftp_service.dart';
import 'account_service.dart';

class CSVService {
  static final Logger _logger = Logger('CSVService');

  static Future<List<String>> _getCSVFilePaths() async {
    return await FTPService.syncTask();
  }

  static List<List<dynamic>> _loadCSVData(String fileContent) {
    return const CsvToListConverter().convert(fileContent);
  }

  static Future<void> syncDataFromCSV() async {
    List<String> emails = ['scottandrewpro@gmail.com'];
    try {
      final csvContents = await _getCSVFilePaths();

      for (final csvContent in csvContents) {
        final csvData = _loadCSVData(csvContent);

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
            }
          }
        }
      }

      await AccountService.createAccountsForEmails(emails);
      await _deleteDuplicateForms();
    } catch (error) {
      _logError('Error syncing data from CSV: $error');
    }
  }

  static Future<void> _createNewTaskAndRelatedDocuments(
      List<dynamic> row) async {
    try {
      final taskId = row[0]?.toString().trim() ?? '';
      final ppirInsuranceId = row[7]?.toString().trim() ?? '';

      // Create new task document
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).set({
        'taskId': taskId,
        'ppirInsuranceId': ppirInsuranceId,
        'ftpFileName': null,
        // Add other necessary fields
      });

      // Create related documents if needed
      // Example: Creating a related document in another collection
      await FirebaseFirestore.instance
          .collection('relatedDocuments')
          .doc(taskId)
          .set({
        'taskId': taskId,
        'relatedField': 'relatedValue',
        // Add other necessary fields
      });
    } catch (error) {
      _logError('Error creating new task and related documents: $error');
    }
  }

  static Future<void> _deleteDuplicateForms() async {
    // Implement logic to delete duplicate forms
    // Example: Query to find and delete duplicates
    try {
      final duplicateFormsQuerySnapshot = await FirebaseFirestore.instance
          .collection('ppirForms')
          .where('isDuplicate', isEqualTo: true)
          .get();

      for (final doc in duplicateFormsQuerySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (error) {
      _logError('Error deleting duplicate forms: $error');
    }
  }

  static void _logError(String message) {
    _logger.severe(message);
  }
}
