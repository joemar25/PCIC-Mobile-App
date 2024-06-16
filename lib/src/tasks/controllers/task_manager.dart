// src/tasks/controllers/task_manager.dart
import 'package:firebase_storage/firebase_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' as logging;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskManager {
  final String taskId;

  static final logging.Logger _logger = logging.Logger('TaskManager');

  TaskManager({
    required this.taskId,
  });

  Future<String?> get filename async {
    return await _getFieldFromTask('filename');
  }

  Future<String?> get confirmedByName async {
    return await _getFieldFromTask('ppirNameInsured');
  }

  Future<String?> get preparedByName async {
    return await _getFieldFromTask('ppirNameIuia');
  }

  Future<String?> get taskManagerNumber async {
    return await _getFieldFromTask('ppirInsuranceId');
  }

  Future<String?> get farmerName async {
    return await _getFieldFromTask('ppirFarmerName');
  }

  Future<String?> get status async {
    return await _getFieldFromTask('taskStatus');
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
      _logger.severe('Error fetching dateAccess: $error');
    }
    return null;
  }

  Future<List<LatLng>?> get routePoints async {
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
      return null;
    }
  }

  Future<LatLng?> get lastCoordinates async {
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
      return null;
    }
  }

  Future<String?> _getFieldFromTask(String fieldName) async {
    try {
      final taskSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (taskSnapshot.exists) {
        final taskData = taskSnapshot.data();
        return taskData?[fieldName] as String?;
      }
    } catch (error) {
      _logger.severe('Error fetching $fieldName: $error');
    }
    return null;
  }

  Future<void> updateTaskData(Map<String, dynamic> taskData) async {
    final taskRef = FirebaseFirestore.instance.collection('tasks').doc(taskId);
    await taskRef.update(taskData);
  }

  Future<void> updateLastCoordinates(LatLng coordinates) async {
    try {
      final taskRef =
          FirebaseFirestore.instance.collection('tasks').doc(taskId);

      await taskRef.update({
        'trackLastcoord': '${coordinates.latitude},${coordinates.longitude}',
        'dateAccess': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logger.severe('Error updating last coordinates or dateAccess: $e');
      throw Exception('Error updating last coordinates or dateAccess');
    }
  }

  Future<void> updateTaskStatus(String status) async {
    try {
      final taskRef =
          FirebaseFirestore.instance.collection('tasks').doc(taskId);
      await taskRef.update({'taskStatus': status});
    } catch (e) {
      _logger.severe('Error updating task status: $e');
      throw Exception('Error updating task status');
    }
  }

  static Future<void> createTasks(
      List<Map<String, dynamic>> taskDataList) async {
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _logger.severe('User is not authenticated.');
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _logger.severe('User is not authenticated.');
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _logger.severe('User is not authenticated.');
      return [];
    }

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final query = FirebaseFirestore.instance
        .collection('tasks')
        .where('taskStatus', isNotEqualTo: 'Completed')
        .where('user', isEqualTo: userRef);

    return await _getTasksByQuery(query);
  }

  static Future<List<TaskManager>> _getTasksByQuery(Query query) async {
    try {
      final querySnapshot = await query.get();
      final tasks = <TaskManager>[];

      for (final documentSnapshot in querySnapshot.docs) {
        final taskId = documentSnapshot.id;

        final task = TaskManager(
          taskId: taskId,
        );

        tasks.add(task);
      }
      return tasks;
    } catch (error) {
      _logger.severe('Error executing query: $error');
      return [];
    }
  }

  Future<String?> get north async {
    return await _getFieldFromTask('ppirNorth');
  }

  Future<String?> get south async {
    return await _getFieldFromTask('ppirSouth');
  }

  Future<String?> get east async {
    return await _getFieldFromTask('ppirEast');
  }

  Future<String?> get west async {
    return await _getFieldFromTask('ppirWest');
  }

  Future<int?> get assignmentID async {
    return await _getFieldFromTasks('ppirAssignmentId');
  }

  Future<String?> get address async {
    return await _getFieldFromTask('ppirAddress');
  }

  Future<int?> _getFieldFromTasks(String fieldName) async {
    try {
      final taskSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (taskSnapshot.exists) {
        final taskData = taskSnapshot.data();
        // debugPrint('$fieldName: ${taskData?[fieldName]}');
        if (fieldName == 'ppirAssignmentId' && taskData?[fieldName] is int) {
          return taskData?[fieldName] as int?;
        }
      }
    } catch (error) {
      _logger.severe('Error fetching $fieldName: $error');
      // debugPrint('Error fetching $fieldName: $error');
    }
    return null;
  }

  Future<String> getGpxFilePath() async {
    // debugPrint('Fetching GPX file path for taskId: $taskId');
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('PPIR_SAVES/$taskId/Attachments');
      final ListResult result = await storageRef.listAll();
      for (Reference fileRef in result.items) {
        if (fileRef.name.endsWith('.gpx')) {
          final downloadURL = await fileRef.getDownloadURL();
          return downloadURL;
        }
      }
      throw Exception('GPX file not found in Firebase Storage');
    } catch (error) {
      _logger.severe('Error fetching GPX file path: $error');
      // debugPrint('Error fetching GPX file path: $error');
      throw Exception('Error fetching GPX file path');
    }
  }

  Future<Map<String, dynamic>> getTaskData() async {
    try {
      final taskSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (taskSnapshot.exists) {
        return taskSnapshot.data() ?? {};
      } else {
        throw Exception('Task not found');
      }
    } catch (error) {
      _logger.severe('Error fetching task data: $error');
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
      throw Exception('Error updating task data');
    }
  }
}
