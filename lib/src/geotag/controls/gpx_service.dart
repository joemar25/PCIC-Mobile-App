// src/geotag/controls/gpx_service.dart
import 'dart:io';
import 'dart:math' show sin, cos, atan2, sqrt;
import 'package:gpx/gpx.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../tasks/controllers/task_manager.dart';
import 'elevation_service.dart';

class GpxService {
  // WGS84 major axis
  static const double earthRadius = 6378137.0;
  // WGS84 flattening
  static const double flattening = 1 / 298.257223563;
  // Adjust this based on comparisons with professional devices
  static const double correctionFactor = 0.95;

  Future<void> saveGpxFile(String gpxString, TaskManager task, bool saveOnline,
      List<LatLng> routePoints) async {
    double areaInSquareMeters = calculateAreaOfPolygon(routePoints);
    double areaInHectares = (areaInSquareMeters * correctionFactor) / 10000;
    double distance = calculateTotalDistance(routePoints);

    // Update the task with calculated values
    await task.updateTaskData({
      'trackTotalarea': areaInHectares.toStringAsFixed(9),
      'trackTotaldistance': distance.toStringAsFixed(2),
    });

    var gpx = await createGpxFromRoutePoints(routePoints);
    var gpxString = convertGpxToString(gpx);

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

  Future<Gpx> createGpxFromRoutePoints(List<LatLng> routePoints) async {
    final gpx = Gpx();
    gpx.creator = "PCIC Mobile App - Geotagging";
    gpx.metadata = Metadata(
      name: "Geotagged Track",
      desc: "Track created with PCIC geotagging application",
      time: DateTime.now().toUtc(),
    );

    final track = Trk();
    track.name = "Geotagged Track";

    final trackSegment = Trkseg();
    for (var point in routePoints) {
      double elevation = await ElevationService.getElevationFromMapbox(point);
      trackSegment.trkpts.add(Wpt(
        lat: point.latitude,
        lon: point.longitude,
        ele: elevation,
        time: DateTime.now().toUtc(),
      ));
    }

    track.trksegs = [trackSegment];
    gpx.trks = [track];
    return gpx;
  }

  String convertGpxToString(Gpx gpx) {
    return GpxWriter().asString(gpx, pretty: true);
  }

  double calculateAreaOfPolygon(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    double area = 0.0;
    int len = points.length;

    for (int i = 0; i < len; i++) {
      int j = (i + 1) % len;
      double xi = points[i].longitudeInRad;
      double yi = points[i].latitudeInRad;
      double xj = points[j].longitudeInRad;
      double yj = points[j].latitudeInRad;

      area += (xj - xi) * (2 + sin(yi) + sin(yj));
    }

    area = area * earthRadius * earthRadius / 2.0;
    return area.abs();
  }

  double calculateTotalDistance(List<LatLng> points) {
    double totalDistance = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += calculateHaversineDistance(points[i], points[i + 1]);
    }
    return totalDistance;
  }

  double calculateHaversineDistance(LatLng start, LatLng end) {
    double lat1 = start.latitudeInRad;
    double lon1 = start.longitudeInRad;
    double lat2 = end.latitudeInRad;
    double lon2 = end.longitudeInRad;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }
}
