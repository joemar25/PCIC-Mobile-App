import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'csv_service.dart';

class TaskManager {
  final String taskId;
  final String formId;
  final String type;

  static final Logger _logger = Logger('TaskManager');

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
      _logError('Error fetching confirmedByName: $error');
      return null;
    }
  }

  Future<String?> get preparedByName async {
    try {
      final formData = await getFormData(type);
      return formData['ppirNameIuia'] as String?;
    } catch (error) {
      _logError('Error fetching preparedByName: $error');
      return null;
    }
  }

  Future<String?> get taskManagerNumber async {
    try {
      final formData = await getFormData(type);
      return formData['ppirInsuranceId'] as String?;
    } catch (error) {
      _logError('Error fetching taskManagerNumber: $error');
      return null;
    }
  }

  Future<String?> get farmerName async {
    try {
      final formData = await getFormData(type);
      return formData['ppirFarmerName'] as String?;
    } catch (error) {
      _logError('Error fetching farmerName: $error');
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
      _logError('Error fetching status: $error');
    }
    return null;
  }

  Future<String?> get north async {
    try {
      final formData = await getFormData(type);
      return formData['ppirNorth'] as String?;
    } catch (error) {
      _logError('Error fetching north: $error');
      return null;
    }
  }

  Future<String?> get south async {
    try {
      final formData = await getFormData(type);
      return formData['ppirSouth'] as String?;
    } catch (error) {
      _logError('Error fetching south: $error');
      return null;
    }
  }

  Future<String?> get east async {
    try {
      final formData = await getFormData(type);
      return formData['ppirEast'] as String?;
    } catch (error) {
      _logError('Error fetching east: $error');
      return null;
    }
  }

  Future<String?> get west async {
    try {
      final formData = await getFormData(type);
      return formData['ppirWest'] as String?;
    } catch (error) {
      _logError('Error fetching west: $error');
      return null;
    }
  }

  Future<String?> get gpxFile async {
    try {
      final formData = await getFormData(type);
      return formData['gpxFile'] as String?;
    } catch (error) {
      _logError('Error fetching gpxFile: $error');
      return null;
    }
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
      _logError('Error fetching dateAccess: $error');
    }
    return null;
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
      _logError('Error fetching routePoints: $error');
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
      _logError('Error fetching lastCoordinates: $error');
      return null;
    }
  }

  static Future<List<TaskManager>> getTasksByQuery(Query query) async {
    List<TaskManager> tasks = [];

    try {
      final querySnapshot = await query.get();

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
      _logError('Error fetching tasks by query: $error');
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

  static Future<List<TaskManager>> getNotCompletedTasks() async {
    await CSVService.syncDataFromCSV();

    final query = FirebaseFirestore.instance
        .collection('tasks')
        .where('status', isNotEqualTo: 'Completed');

    return await getTasksByQuery(query);
  }

  Future<Map<String, dynamic>> getFormData(String formType) async {
    final db = FirebaseFirestore.instance;
    final document = await db.collection('ppirForms').doc(formId).get();

    if (document.exists) {
      return document.data() ?? {};
    }

    return {};
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

  /// ***************               UPDATE              ***************** ///
  Future<void> updatePpirFormData(
      Map<String, dynamic> formData, Map<String, dynamic> taskData) async {
    final formRef =
        FirebaseFirestore.instance.collection('ppirForms').doc(formId);
    final taskRef = FirebaseFirestore.instance.collection('tasks').doc(taskId);

    final batch = FirebaseFirestore.instance.batch();
    batch.update(formRef, formData);
    batch.update(taskRef, taskData);

    await batch.commit();
  }

  Future<void> updateLastCoordinates(LatLng coordinates) async {
    try {
      final ppirFormRef =
          FirebaseFirestore.instance.collection('ppirForms').doc(formId);
      final taskRef =
          FirebaseFirestore.instance.collection('tasks').doc(taskId);

      await ppirFormRef.update({
        'trackLastcoord': '${coordinates.latitude},${coordinates.longitude}',
      });

      await taskRef.update({
        'dateAccess': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logError('Error updating last coordinates or dateAccess: $e');
      throw Exception('Error updating last coordinates or dateAccess');
    }
  }

  Future<void> updateTaskStatus(String status) async {
    try {
      final taskRef =
          FirebaseFirestore.instance.collection('tasks').doc(taskId);
      await taskRef.update({'status': status});
    } catch (e) {
      _logError('Error updating task status: $e');
      throw Exception('Error updating task status');
    }
  }

  static void _logError(String message) {
    _logger.severe(message);
  }
}
