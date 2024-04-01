// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:pcic_mobile_app/screens/dashboard/controllers/_control_task.dart';
// import 'package:pcic_mobile_app/screens/dashboard/views/_pcic_form_1.dart';
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
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PCICFormPage(
//             task: widget.task,
//             gpxFile: gpxFile,
//           ),
//         ),
//       );
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
//           title: const Text('Update Task'),
//         ),
//         body: Stack(
//           children: [
//             MapboxMap(
//               accessToken: Env.MAPBOX_ACCESS_TOKEN,
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(13.145467, 483.723563),
//                 zoom: 18,
//               ),
//               onMapCreated: (MapboxMapController controller) {
//                 mapController = controller;
//               },
//               styleString: 'mapbox://styles/mapbox/outdoors-v12',
//               onMapClick: (point, latLng) {
//                 setState(() {
//                   routePoints.add(latLng);
//                 });
//               },
//             ),
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 padding: const EdgeInsets.all(16),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0x192F2F2F),
//                       blurRadius: 20,
//                       offset: Offset(-10, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Geotagging',
//                           style: TextStyle(
//                             color: Color(0xFF1E1E1E),
//                             fontSize: 22,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               isColumnVisible = !isColumnVisible;
//                             });
//                           },
//                           child: Icon(
//                             isColumnVisible
//                                 ? Icons.keyboard_arrow_down
//                                 : Icons.keyboard_arrow_up,
//                           ),
//                         ),
//                       ],
//                     ),
//                     AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       height: isColumnVisible ? null : 0,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 16),
//                           const Text(
//                             'Your Location',
//                             style: TextStyle(
//                               color: Color(0xFF9D9D9D),
//                               fontSize: 12,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             currentLocation,
//                             style: const TextStyle(
//                               color: Color(0xFF343434),
//                               fontSize: 12,
//                             ),
//                           ),
//                           const Divider(height: 24),
//                           const Text(
//                             'Tracking Options',
//                             style: TextStyle(
//                               color: Color(0xFF9D9D9D),
//                               fontSize: 12,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               _buildTrackingOption('Start', _startRouting),
//                               const SizedBox(width: 8),
//                               _buildTrackingOption('Stop', _stopRouting),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           _buildTrackingOption('Pin Drop', () {}),
//                           const SizedBox(height: 24),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     // Navigate to PCIC Form with captured route points
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => PCICFormPage(
//                                           task: widget.task,
//                                           gpxFile:
//                                               _generateGPXFile(routePoints),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFF89C53F),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 16),
//                                   ),
//                                   child: const Text(
//                                     'Update',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               Expanded(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     // Reset button action
//                                     setState(() {
//                                       routePoints.clear();
//                                     });
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFF89C53F),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 16),
//                                   ),
//                                   child: const Text(
//                                     'Reset',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 16,
//               right: 16,
//               child: Container(
//                 width: 20,
//                 height: 31,
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage("https://via.placeholder.com/20x31"),
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//                 child: const Center(
//                   child: CircleAvatar(
//                     radius: 5,
//                     backgroundColor: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTrackingOption(String label, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: () {
//         if (label == 'Pin Drop') {
//           _addPinDrop();
//         } else {
//           onTap();
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF5F5F5),
//           borderRadius: BorderRadius.circular(2),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 24,
//               height: 24,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF45C53F),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.check,
//                 color: Colors.white,
//                 size: 16,
//               ),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Color(0xFF1E1E1E),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _addPinDrop() {
//     if (currentLocation.isNotEmpty && mapController != null) {
//       // Extract latitude and longitude from the current location string
//       final latLng = currentLocation.split(', ');
//       if (latLng.length == 2) {
//         final latitude = double.tryParse(latLng[0].split(': ')[1]);
//         final longitude = double.tryParse(latLng[1].split(': ')[1]);
//         if (latitude != null && longitude != null) {
//           // Add the pin at the location
//           mapController.addSymbol(SymbolOptions(
//             geometry: LatLng(latitude, longitude),
//             iconImage:
//                 'OIP.jpg', // Replace 'your-icon-image' with your custom pin icon
//             textField: 'Pin', // Optional: Label text for the pin
//           ));

//           // Move the camera to the dropped pin location
//           mapController.animateCamera(CameraUpdate.newLatLngZoom(
//             LatLng(latitude, longitude),
//             18, // Adjust zoom level as needed
//           ));
//         } else {
//           debugPrint('Invalid latitude or longitude.');
//         }
//       } else {
//         debugPrint('Error parsing current location.');
//       }
//     } else {
//       debugPrint('Current location is not available.');
//     }
//   }
// }
