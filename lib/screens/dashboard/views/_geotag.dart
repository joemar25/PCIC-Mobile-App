import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pcic_mobile_app/screens/dashboard/controllers/_control_task.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

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
  bool isColumnVisible = true;
  bool isPinDropMode = false;
  bool isRoutingStarted = false;

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
        _addMarker(LatLng(position.latitude, position.longitude));
        mapController.move(
          LatLng(position.latitude, position.longitude),
          15.0,
        );
      });
    } catch (e) {
      debugPrint('Error getting current location: $e');
    }
  }

  void _addMarker(LatLng point) {
    setState(() {
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: point,
          child: const Icon(
            // Change this line
            Icons.location_on,
            color: Colors.blue,
            size: 40.0,
          ),
        ),
      );
    });
  }

  void _startRouting() {
    debugPrint('Starting');
    setState(() {
      isRoutingStarted = true;
    });
    _getCurrentLocation();
  }

  void _stopRouting() {
    setState(() {
      isRoutingStarted = false;
      isPinDropMode = false;
    });
    // Add your logic for stopping the routing here
  }

  void _togglePinDropMode() {
    setState(() {
      isPinDropMode = !isPinDropMode;
    });
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
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: const LatLng(13.138769, 123.734005),
                  initialZoom: 18.0, // Increase the initial zoom level
                  maxZoom: 22.0, // Set the maximum zoom level
                  onTap: (tapPosition, point) {
                    if (isPinDropMode && isRoutingStarted) {
                      _addMarker(point);
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/quanbysolutions/cluhoxol502q801oi8od2cmvz/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicXVhbmJ5c29sdXRpb25zIiwiYSI6ImNsdWhrejRwdDJyYnAya3A2NHFqbXlsbHEifQ.WJ5Ng-AO-dTrlkUHD_ebMw',
                    additionalOptions: const {
                      'accessToken':
                          'pk.eyJ1IjoicXVhbmJ5c29sdXRpb25zIiwiYSI6ImNsdWhrejRwdDJyYnAya3A2NHFqbXlsbHEifQ.WJ5Ng-AO-dTrlkUHD_ebMw',
                      'id': 'mapbox.satellite',
                    },
                    tileProvider: CancellableNetworkTileProvider(),
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
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
                              onPressed: _startRouting,
                              child: const Text('Start Routing'),
                            ),
                            ElevatedButton(
                              onPressed: _stopRouting,
                              child: const Text('Stop Routing'),
                            ),
                            Visibility(
                              visible: isRoutingStarted,
                              child: ElevatedButton(
                                onPressed: _togglePinDropMode,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isPinDropMode
                                      ? Colors.green
                                      : Colors.blue,
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
          onPressed: _getCurrentLocation,
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }
}
