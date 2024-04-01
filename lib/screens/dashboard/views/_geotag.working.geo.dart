// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:pcic_mobile_app/screens/dashboard/controllers/_control_task.dart';
// import 'package:pcic_mobile_app/utils/_app_env.dart';
// import 'package:permission_handler/permission_handler.dart';

// class GeotagPage extends StatefulWidget {
//   final Task task;

//   const GeotagPage({super.key, required this.task});

//   @override
//   _GeotagPageState createState() => _GeotagPageState();
// }

// class _GeotagPageState extends State<GeotagPage> {
//   late MapboxMapController mapController;
//   final List<LatLng> routePoints = [];
//   String currentLocation = '';
//   bool isColumnVisible = true;

//   @override
//   void initState() {
//     super.initState();
//     debugPrint('Mapbox access token: ${Env.MAPBOX_ACCESS_TOKEN}');
//     _requestLocationPermission();
//   }

//   Future<void> _requestLocationPermission() async {
//     final status = await Permission.location.request();
//     if (status.isGranted) {
//       await _getCurrentLocation();
//     } else {
//       debugPrint('Location permission denied');
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       setState(() {
//         currentLocation =
//             'Lat: ${position.latitude}, Long: ${position.longitude}';
//         mapController.animateCamera(
//           CameraUpdate.newLatLng(
//             LatLng(position.latitude, position.longitude),
//           ),
//         );
//       });
//     } catch (e) {
//       debugPrint('Error getting current location: $e');
//     }
//   }

//   void _startRouting() {
//     debugPrint('Starting');
//     _getCurrentLocation();
//   }

//   void _stopRouting() {
//     if (routePoints.length >= 2) {
//       debugPrint('Captured route points: $routePoints');
//       // Generate the GPX file from the captured route points
//       String gpxFile = _generateGPXFile(routePoints);
//       // Navigate to the read-only form with the task and GPX file
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => PCICFormPage(
//       //       task: widget.task,
//       //       gpxFile: gpxFile,
//       //     ),
//       //   ),
//       // );
//     }
//   }

//   String _generateGPXFile(List<LatLng> routePoints) {
//     // Implement the logic to generate the GPX file from the captured route points
//     // You can use a library or create the GPX file structure manually
//     // Return the generated GPX file as a string
//     return 'Generated GPX file content';
//   }

//   Future<bool> _onWillPop() async {
//     final shouldPop = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirmation'),
//         content: const Text('Are you sure you want to cancel?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text('No'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: const Text('Yes'),
//           ),
//         ],
//       ),
//     );
//     return shouldPop ?? false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Geotag'),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: MapboxMap(
//                 accessToken: Env.MAPBOX_ACCESS_TOKEN,
//                 initialCameraPosition: const CameraPosition(
//                   target: LatLng(0, 0),
//                   zoom: 12,
//                 ),
//                 onMapCreated: (controller) {
//                   mapController = controller;
//                   _getCurrentLocation();
//                 },
//                 onMapClick: (point, latLng) {
//                   setState(() {
//                     routePoints.add(latLng);
//                   });
//                 },
//                 onMapLongClick: (point, latLng) {
//                   mapController.addSymbol(
//                     SymbolOptions(
//                       geometry: latLng,
//                       iconImage: 'assets/icon_location.png',
//                     ),
//                   );
//                 },
//                 onCameraTrackingDismissed: () {
//                   _getCurrentLocation();
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Current Location',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(currentLocation),
//                   const SizedBox(height: 20),
//                   Visibility(
//                     visible: isColumnVisible,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Route Points',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             ElevatedButton(
//                               onPressed: _startRouting,
//                               child: const Text('Start Routing'),
//                             ),
//                             ElevatedButton(
//                               onPressed: _stopRouting,
//                               child: const Text('Stop Routing'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
