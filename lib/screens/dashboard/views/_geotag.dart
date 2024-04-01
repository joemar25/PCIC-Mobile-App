import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pcic_mobile_app/screens/dashboard/controllers/_control_task.dart';
import 'package:permission_handler/permission_handler.dart';

class GeotagPage extends StatefulWidget {
  final Task task;
  const GeotagPage({super.key, required this.task});

  @override
  _GeotagPageState createState() => _GeotagPageState();
}

class _GeotagPageState extends State<GeotagPage> {
  String currentLocation = '';
  List<Marker> markers = [];
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      await _getCurrentLocation();
    } else {
      debugPrint('Location permission denied');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentLocation =
            'Lat: ${position.latitude}, Long: ${position.longitude}';
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(position.latitude, position.longitude),
            child: const Icon(
              // Change this line
              Icons.location_on,
              color: Colors.blue,
              size: 40.0,
            ),
          ),
        );
      });
    } catch (e) {
      debugPrint('Error getting current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geotagging'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: const MapOptions(
          center: LatLng(13.138769, 123.734005),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: markers),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
