import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart' as logging;
import 'package:flutter/material.dart';

class TaskManager {
  final String taskId;

  static final logging.Logger _logger = logging.Logger('TaskManager');

  TaskManager({
    required this.taskId,
  });

  Future<String?> get confirmedByName async {
    debugPrint('Fetching confirmedByName for taskId: $taskId');
    return await _getFieldFromTask('ppirNameInsured');
  }

  Future<String?> get preparedByName async {
    debugPrint('Fetching preparedByName for taskId: $taskId');
    return await _getFieldFromTask('ppirNameIuia');
  }

  Future<String?> get taskManagerNumber async {
    debugPrint('Fetching taskManagerNumber for taskId: $taskId');
    return await _getFieldFromTask('ppirInsuranceId');
  }

  Future<String?> get farmerName async {
    debugPrint('Fetching farmerName for taskId: $taskId');
    return await _getFieldFromTask('ppirFarmerName');
  }

  Future<String?> get status async {
    debugPrint('Fetching status for taskId: $taskId');
    return await _getFieldFromTask('taskStatus');
  }

  Future<DateTime?> get dateAccess async {
    debugPrint('Fetching dateAccess for taskId: $taskId');
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
      _logger.severe('Error fetching dateAccess: $error');
      debugPrint('Error fetching dateAccess: $error');
    }
    return null;
  }

  Future<List<LatLng>?> get routePoints async {
    debugPrint('Fetching routePoints for taskId: $taskId');
    try {
      final taskSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (taskSnapshot.exists) {
        final taskData = taskSnapshot.data();
        if (taskData?['routePoints'] != null) {
          List<dynamic> points = taskData!['routePoints'];
          return points
              .map((point) => LatLng(
                    double.parse(point.split(',')[0]),
                    double.parse(point.split(',')[1]),
                  ))
              .toList();
        }
      }
      return null;
    } catch (error) {
      _logger.severe('Error fetching routePoints: $error');
      debugPrint('Error fetching routePoints: $error');
      return null;
    }
  }

  Future<LatLng?> get lastCoordinates async {
    debugPrint('Fetching lastCoordinates for taskId: $taskId');
    try {
      final taskSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (taskSnapshot.exists) {
        final taskData = taskSnapshot.data();
        if (taskData?['trackLastcoord'] != null) {
          List<String> lastCoord = taskData!['trackLastcoord'].split(',');
          return LatLng(double.parse(lastCoord[0]), double.parse(lastCoord[1]));
        }
      }
      return null;
    } catch (error) {
      _logger.severe('Error fetching lastCoordinates: $error');
      debugPrint('Error fetching lastCoordinates: $error');
      return null;
    }
  }

  Future<String?> _getFieldFromTask(String fieldName) async {
    debugPrint('Fetching $fieldName for taskId: $taskId');
    try {
      final taskSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (taskSnapshot.exists) {
        final taskData = taskSnapshot.data();
        debugPrint('$fieldName: ${taskData?[fieldName]}');
        return taskData?[fieldName] as String?;
      }
    } catch (error) {
      _logger.severe('Error fetching $fieldName: $error');
      debugPrint('Error fetching $fieldName: $error');
    }
    return null;
  }

  Future<void> updateTaskData(Map<String, dynamic> taskData) async {
    debugPrint('Updating task data for taskId: $taskId with data: $taskData');
    final taskRef = FirebaseFirestore.instance.collection('tasks').doc(taskId);

    await taskRef.update(taskData);
  }

  Future<void> updateLastCoordinates(LatLng coordinates) async {
    debugPrint(
        'Updating last coordinates for taskId: $taskId with coordinates: $coordinates');
    try {
      final taskRef =
          FirebaseFirestore.instance.collection('tasks').doc(taskId);

      await taskRef.update({
        'trackLastcoord': '${coordinates.latitude},${coordinates.longitude}',
        'dateAccess': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logger.severe('Error updating last coordinates or dateAccess: $e');
      debugPrint('Error updating last coordinates or dateAccess: $e');
      throw Exception('Error updating last coordinates or dateAccess');
    }
  }

  Future<void> updateTaskStatus(String status) async {
    debugPrint('Updating task status for taskId: $taskId to status: $status');
    try {
      final taskRef =
          FirebaseFirestore.instance.collection('tasks').doc(taskId);
      await taskRef.update({'taskStatus': status});
    } catch (e) {
      _logger.severe('Error updating task status: $e');
      debugPrint('Error updating task status: $e');
      throw Exception('Error updating task status');
    }
  }

  static Future<void> createTasks(
      List<Map<String, dynamic>> taskDataList) async {
    debugPrint('Creating tasks: $taskDataList');
    final batch = FirebaseFirestore.instance.batch();
    final tasksRef = FirebaseFirestore.instance.collection('tasks');

    for (final taskData in taskDataList) {
      final taskId = taskData['taskId'] as String;
      final newTaskRef = tasksRef.doc(taskId);
      batch.set(newTaskRef, taskData);
    }

    await batch.commit();
  }

  static Future<List<TaskManager>> getTasksByStatus(String status) async {
    debugPrint('Fetching tasks by status: $status');
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _logger.severe('User is not authenticated.');
      debugPrint('User is not authenticated.');
      return [];
    }

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    final query = FirebaseFirestore.instance
        .collection('tasks')
        .where('taskStatus', isEqualTo: status)
        .where('user', isEqualTo: userRef);

    return await _getTasksByQuery(query);
  }

  static Future<List<TaskManager>> getAllTasks() async {
    debugPrint('Fetching all tasks');
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _logger.severe('User is not authenticated.');
      debugPrint('User is not authenticated.');
      return [];
    }

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    final query = FirebaseFirestore.instance
        .collection('tasks')
        .where('user', isEqualTo: userRef);

    return await _getTasksByQuery(query);
  }

  static Future<List<TaskManager>> getNotCompletedTasks() async {
    debugPrint('Fetching not completed tasks');
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _logger.severe('User is not authenticated.');
      debugPrint('User is not authenticated.');
      return [];
    }

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    debugPrint('User reference: $userRef');

    final query = FirebaseFirestore.instance
        .collection('tasks')
        .where('taskStatus', isNotEqualTo: 'Completed')
        .where('user', isEqualTo: userRef);

    return await _getTasksByQuery(query);
  }

  static Future<List<TaskManager>> _getTasksByQuery(Query query) async {
    debugPrint('Executing query: ${query.parameters}');
    try {
      final querySnapshot = await query.get();
      debugPrint('Query snapshot length: ${querySnapshot.size}');
      final tasks = <TaskManager>[];

      for (final documentSnapshot in querySnapshot.docs) {
        final taskId = documentSnapshot.id;
        debugPrint(
            'Found taskId: $taskId with data: ${documentSnapshot.data()}');

        final task = TaskManager(
          taskId: taskId,
        );

        tasks.add(task);
      }
      debugPrint('Total tasks found: ${tasks.length}');
      return tasks;
    } catch (error) {
      _logger.severe('Error executing query: $error');
      debugPrint('Error executing query: $error');
      return [];
    }
  }

  Future<String?> get north async {
    debugPrint('Fetching north for taskId: $taskId');
    return await _getFieldFromTask('ppirNorth');
  }

  Future<String?> get south async {
    debugPrint('Fetching south for taskId: $taskId');
    return await _getFieldFromTask('ppirSouth');
  }

  Future<String?> get east async {
    debugPrint('Fetching east for taskId: $taskId');
    return await _getFieldFromTask('ppirEast');
  }

  Future<String?> get west async {
    debugPrint('Fetching west for taskId: $taskId');
    return await _getFieldFromTask('ppirWest');
  }

  Future<String> getGpxFilePath() async {
    debugPrint('Fetching GPX file path for taskId: $taskId');
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('PPIR_SAVES/$taskId/Attachments');
      final ListResult result = await storageRef.listAll();
      for (Reference fileRef in result.items) {
        if (fileRef.name.endsWith('.gpx')) {
          final downloadURL = await fileRef.getDownloadURL();
          debugPrint('Found GPX file: ${fileRef.name}, URL: $downloadURL');
          return downloadURL;
        }
      }
      throw Exception('GPX file not found in Firebase Storage');
    } catch (error) {
      _logger.severe('Error fetching GPX file path: $error');
      debugPrint('Error fetching GPX file path: $error');
      throw Exception('Error fetching GPX file path');
    }
  }

  Future<Map<String, dynamic>> getTaskData() async {
    debugPrint('Fetching task data for taskId: $taskId');
    try {
      final taskSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (taskSnapshot.exists) {
        debugPrint('Task data: ${taskSnapshot.data()}');
        return taskSnapshot.data() ?? {};
      } else {
        throw Exception('Task not found');
      }
    } catch (error) {
      _logger.severe('Error fetching task data: $error');
      debugPrint('Error fetching task data: $error');
      throw Exception('Error fetching task data');
    }
  }

  Future<void> updatePpirFormData(Map<String, dynamic> updatedTaskData) async {
    debugPrint(
        'Updating task data for taskId: $taskId with data: $updatedTaskData');
    try {
      final taskRef =
          FirebaseFirestore.instance.collection('tasks').doc(taskId);

      await taskRef.update(updatedTaskData);
    } catch (error) {
      _logger.severe('Error updating task data: $error');
      debugPrint('Error updating task data: $error');
      throw Exception('Error updating task data');
    }
  }
}
