// src/geotag/controls/gpx_service.dart
import 'dart:io';

import 'package:gpx/gpx.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../tasks/controllers/task_manager.dart';

class GpxService {
  Future<void> saveGpxFile(
      String gpxString, TaskManager task, bool saveOnline) async {
    if (saveOnline) {
      await _uploadGpxToFirebase(gpxString, task);
    } else {
      await _saveGpxLocally(gpxString, task);
    }
  }

  Future<void> _uploadGpxToFirebase(String gpxString, TaskManager task) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final folderRef =
          storageRef.child('PPIR_SAVES/${task.taskId}/Attachments');
      final ListResult result = await folderRef.listAll();

      for (Reference fileRef in result.items) {
        if (fileRef.name.endsWith('.gpx')) {
          await fileRef.delete();
        }
      }

      var uuid = const Uuid();
      String gpxFilename = '${uuid.v4()}.gpx';
      final gpxFileRef = folderRef.child(gpxFilename);
      await gpxFileRef.putString(gpxString, format: PutStringFormat.raw);
      final downloadUrl = await gpxFileRef.getDownloadURL();

      debugPrint('GPX file uploaded to Firebase: $downloadUrl');
      await task.updateTaskStatus('Ongoing');
    } catch (e) {
      debugPrint('Error uploading GPX file to Firebase: $e');
      throw Exception('Error uploading GPX file to Firebase');
    }
  }

  Future<void> _saveGpxLocally(String gpxString, TaskManager task) async {
    final directory = await getExternalStorageDirectory();
    final dataDirectory = directory?.path ?? '/storage/emulated/0/Android/data';
    final baseFilename = task.taskId;
    final insuranceDirectory = Directory('$dataDirectory/$baseFilename');

    if (await insuranceDirectory.exists()) {
      await insuranceDirectory.delete(recursive: true);
    }

    await insuranceDirectory.create(recursive: true);
    final attachmentsDirectory =
        Directory('${insuranceDirectory.path}/Attachments');

    if (!await attachmentsDirectory.exists()) {
      await attachmentsDirectory.create(recursive: true);
    }

    var uuid = const Uuid();
    String gpxFilename = '${uuid.v4()}.gpx';
    final gpxFile = File('${attachmentsDirectory.path}/$gpxFilename');

    await gpxFile.writeAsString(gpxString);
    debugPrint('GPX file saved: ${gpxFile.path}');
    await task.updateTaskStatus('Ongoing');
  }

  Gpx createGpxFromRoutePoints(List<LatLng> routePoints) {
    final gpx = Gpx();
    final trackSegment = Trkseg();
    trackSegment.trkpts = routePoints
        .map((point) => Wpt(lat: point.latitude, lon: point.longitude))
        .toList();
    final track = Trk();
    track.trksegs = [trackSegment];
    gpx.trks = [track];
    return gpx;
  }

  String convertGpxToString(Gpx gpx) {
    return GpxWriter().asString(gpx);
  }
}
