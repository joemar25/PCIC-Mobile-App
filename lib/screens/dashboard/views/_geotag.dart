import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show Uint8List;

import 'package:gpx/gpx.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_pcic_form_1.dart';
import 'package:pcic_mobile_app/utils/_app_gpx.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';
import 'package:pcic_mobile_app/utils/controls/_location_service.dart';
import 'package:pcic_mobile_app/utils/controls/_map_service.dart';

class GeotagPage extends StatefulWidget {
  final Task task;
  const GeotagPage({super.key, required this.task});

  @override
  _GeotagPageState createState() => _GeotagPageState();
}

class _GeotagPageState extends State<GeotagPage> {
  final LocationService _locationService = LocationService();
  final MapService _mapService = MapService();

  bool retainPinDrop = false;
  bool showConfirmationDialog = true;
  String currentLocation = '';
  bool isColumnVisible = true;
  bool isRoutingStarted = false;

  @override
  void initState() {
    super.initState();
    _locationService.requestLocationPermission().then((_) {
      _getCurrentLocation(addMarker: false);
    });
  }

  Future<void> _getCurrentLocation({bool addMarker = true}) async {
    LatLng? position = await _locationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        currentLocation =
            'Lat: ${position.latitude}, Long: ${position.longitude}';
        _mapService.moveMap(position);
      });
      if (addMarker) {
        _mapService.addMarker(position);
      }
    }
  }

  void _startRouting() async {
    LatLng? position = await _locationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        isRoutingStarted = true;
        _mapService.clearRoutePoints();
        _mapService.addColoredMarker(position, Colors.green);
      });
      _trackRoutePoints();
    }
  }

  void _trackRoutePoints() async {
    while (isRoutingStarted) {
      LatLng? position = await _locationService.getCurrentLocation();
      if (position != null) {
        setState(() {
          currentLocation =
              'Lat: ${position.latitude}, Long: ${position.longitude}';
          _mapService.addRoutePoint(position);
        });
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  void _stopRouting() async {
    bool? shouldStop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Finish routing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (shouldStop == true) {
      List<Wpt> routePoints = _mapService.routePoints
          .map((point) => Wpt(lat: point.latitude, lon: point.longitude))
          .toList();

      var gpx = GpxUtil.createGpx(routePoints);
      var gpxString = GpxWriter().asString(gpx);

      String gpxFilePath = await _saveGpxFile(gpxString);
      String screenshotFilePath = '';

      final screenshotBytes = await _mapService.captureMapScreenshot();
      if (screenshotBytes != null) {
        screenshotFilePath = await _saveMapScreenshot(screenshotBytes);
      }

      setState(() {
        isRoutingStarted = false;
        _mapService.clearMarkers();
      });

      // Show a snackbar with the file locations
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Files saved:\nGPX: $gpxFilePath\nScreenshot: $screenshotFilePath'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to the forms page
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => PCICFormPage(
            imageFile: screenshotFilePath,
            gpxFile: gpxFilePath,
          ),
        ),
      );
    }
  }

  Future<String> _saveGpxFile(String gpxString) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/route.gpx');
    await file.writeAsString(gpxString);
    debugPrint('GPX file saved: ${file.path}');
    return file.path;
  }

  Future<String> _saveMapScreenshot(Uint8List screenshotBytes) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/map_screenshot.png');
    await file.writeAsBytes(screenshotBytes);
    debugPrint('Map screenshot saved: ${file.path}');
    return file.path;
  }

  Future<void> _addMarkerAtCurrentLocation() async {
    LatLng? position = await _locationService.getCurrentLocation();
    _mapService.addMarker(position!);

    if (showConfirmationDialog) {
      bool? shouldRetain = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Pin Drop'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return CheckboxListTile(
                title: const Text('Don\'t show again'),
                value: retainPinDrop,
                onChanged: (value) {
                  setState(() {
                    retainPinDrop = value!;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (shouldRetain == false) {
        _mapService.removeLastMarker();
      } else {
        showConfirmationDialog = !retainPinDrop;
      }
    } else {
      if (!retainPinDrop) {
        _mapService.removeLastMarker();
      }
    }
  }

  Future<bool> _onWillPop() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to cancel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Geotag'),
        ),
        body: Column(
          children: [
            Expanded(
              child: _mapService.buildMap(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Location',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(currentLocation),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: isColumnVisible,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Route Points',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed:
                                  isRoutingStarted ? null : _startRouting,
                              child: const Text('Start Routing'),
                            ),
                            ElevatedButton(
                              onPressed: isRoutingStarted ? _stopRouting : null,
                              child: const Text('Stop Routing'),
                            ),
                            Visibility(
                              visible: isRoutingStarted,
                              child: ElevatedButton(
                                onPressed: _addMarkerAtCurrentLocation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text('Pin Drop'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _getCurrentLocation(addMarker: false),
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }
}
