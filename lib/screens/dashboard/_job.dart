import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  MapController mapController = MapController();
  List<LatLng> routePoints = [];
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        mapController.move(
          LatLng(position.latitude, position.longitude),
          15.0,
        );
        routePoints.add(LatLng(position.latitude, position.longitude));
        markers.add(
          Marker(
            point: LatLng(position.latitude, position.longitude),
            child: const Icon(Icons.location_on, color: Colors.blue),
          ),
        );
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void _startRouting() {
    setState(() {
      routePoints = [];
      markers = [];
    });
  }

  void _stopRouting() {
    if (routePoints.length >= 2) {
      // Perform actions with the captured route points
      print('Captured route points: $routePoints');
      // Add your logic here to process the captured route points
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onTap: (position, point) {
            setState(() {
              routePoints.add(point);
              markers.add(
                Marker(
                  point: point,
                  child: const Icon(Icons.location_on, color: Colors.red),
                ),
              );
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                color: Colors.blue,
                strokeWidth: 5.0,
              ),
            ],
          ),
          MarkerLayer(
            markers: markers,
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _startRouting,
            child: const Icon(Icons.play_arrow),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _stopRouting,
            child: const Icon(Icons.stop),
          ),
        ],
      ),
    );
  }
}
