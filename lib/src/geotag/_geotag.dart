// filename: geotag/_geotag.dart
import 'dart:async';
import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:gpx/gpx.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../ppir_form/_pcic_form.dart';
import '_map_service.dart';
import '../theme/_theme.dart';
import '_location_service.dart';
import '_geotag_bottomsheet.dart';
import '../../utils/app/_gpx.dart';
import '../tasks/_control_task.dart';
import '../../utils/app/_show_flash_message.dart';

class GeotagPage extends StatefulWidget {
  final TaskManager task;

  const GeotagPage({
    super.key,
    required this.task,
  });

  @override
  GeotagPageState createState() => GeotagPageState();
}

class GeotagPageState extends State<GeotagPage> with WidgetsBindingObserver {
  final LocationService _locationService = LocationService();
  final MapService _mapService = MapService();
  final panelController = PanelController();

  static const double fabHeightClosed = 225.0;
  double fabHeight = fabHeightClosed;

  String latitude = '';
  String address = '';
  String longitude = '';
  String currentLocation = '';

  bool isLoading = false;
  bool retainPinDrop = false;
  bool isInitializing = true;
  bool isColumnVisible = true;
  bool isRoutingStarted = false;
  bool showConfirmationDialog = true;

  // joemar is here
  bool saveOnline = true;

  StreamSubscription<LatLng>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeLocation().then((_) {
      setState(() {
        isInitializing = false;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationSubscription?.cancel();
    _mapService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _locationSubscription?.cancel();
      _mapService.dispose();
    }
  }

  Future<void> _initializeLocation() async {
    await _requestPermissions();
    await _locationService.requestLocationPermission();
    _getCurrentLocation(addMarker: false);
  }

  Future<void> _requestPermissions() async {
    final locationStatus = await Permission.location.request();
    final storageStatus = await Permission.storage.request();

    if (mounted) {
      if (locationStatus.isGranted && storageStatus.isGranted) {
        // Permissions granted, proceed with location and geocoding
      } else {
        if (!locationStatus.isGranted) {
          debugPrint('Location permission denied');
        }
        if (!storageStatus.isGranted) {
          debugPrint('Storage permission denied');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Storage permission is required to save files'),
            ),
          );
        }
      }
    }
  }

  Future<void> _getCurrentLocation({bool addMarker = true}) async {
    LatLng? position = await _locationService.getCurrentLocation();
    if (position != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          setState(() {
            latitude = '${position.latitude}';
            longitude = '${position.longitude}';
            currentLocation =
                'Lat: ${position.latitude}, Long: ${position.longitude}';
          });
          if (addMarker) {
            _mapService.addMarker(position);
          }
        }
      });
    }
  }

  void _startRouting() async {
    LatLng? position = await _locationService.getCurrentLocation();
    if (position != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            isRoutingStarted = true;
            _mapService.clearRoutePoints();
            _mapService.addColoredMarker(position, Colors.green);
          });
          _trackRoutePoints();
        }
      });
    }
  }

  void _trackRoutePoints() {
    _locationSubscription ??=
        _locationService.getLocationStream().listen((position) async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            latitude = '${position.latitude}';
            longitude = '${position.longitude}';
            currentLocation =
                'Lat: ${position.latitude}, Long: ${position.longitude}';
            _mapService
                .addRoutePoint(LatLng(position.latitude, position.longitude));
          });
        }
      });
    });
  }

  void _stopRouting() async {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    bool? shouldStop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        title: Text(
          'Confirmation',
          style: TextStyle(
              fontSize: t?.title ?? 14.0, fontWeight: FontWeight.w600),
        ),
        content: Text('Finish routing?',
            style: TextStyle(fontSize: t?.caption ?? 14.0)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('OK',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );

    if (shouldStop == true) {
      setState(() {
        isLoading = true;
      });

      await _locationSubscription?.cancel();
      _locationSubscription = null;

      try {
        List<Wpt> routePoints = _mapService.routePoints
            .map((point) => Wpt(lat: point.latitude, lon: point.longitude))
            .toList();

        // Add starting point coordinates to close the route
        routePoints.add(Wpt(
          lat: routePoints.first.lat,
          lon: routePoints.first.lon,
        ));

        var gpx = GpxUtil.createGpx(routePoints);
        var gpxString = GpxWriter().asString(gpx);

        final gpxFilePath = await _saveGpxFile(gpxString);

        // Wait for the current frame to complete before navigating
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              isRoutingStarted = false;
              _mapService.clearMarkers();
              isLoading = false;
            });

            // Dispose of the MapService before navigating
            _mapService.dispose();

            // Navigate to the forms page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PPIRFormPage(
                  gpxFile: gpxFilePath,
                  task: widget.task,
                  routePoints: _mapService.routePoints,
                  lastCoordinates: _mapService.routePoints.last,
                ),
              ),
            );
          }
        });
      } catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
            // Handle the exception gracefully
            debugPrint('Exception caught: $e');

            // Show an error message to the user
            showFlashMessage(context, 'Error', 'Error Saving File',
                'Something went wrong! Please try again.');
            Navigator.pop(context);
          }
        });
      }
    }
  }

  /// tiga save so GPX file either online to Firebase Storage or locally
  /// tiga delete so existing GPX files in the Firebase Storage folder if `saveOnline` is true
  Future<String> _saveGpxFile(String gpxString) async {
    if (saveOnline) {
      try {
        // Create a reference to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref();

        // Create a reference to the folder named after widget.task.formId
        final folderRef = storageRef.child('PPIR_SAVES/${widget.task.formId}');

        // List all items in the folder
        final ListResult result = await folderRef.listAll();

        // Delete all existing GPX files in the folder
        for (Reference fileRef in result.items) {
          if (fileRef.name.endsWith('.gpx')) {
            await fileRef.delete();
          }
        }

        // Generate a unique filename using Uuid
        var uuid = const Uuid();
        String gpxFilename = '${uuid.v4()}.gpx';

        // Create a reference to the file location inside the folder
        final gpxFileRef = folderRef.child(gpxFilename);

        // Upload the GPX file as a string (blob)
        await gpxFileRef.putString(gpxString, format: PutStringFormat.raw);

        // Get the download URL of the uploaded file
        final downloadUrl = await gpxFileRef.getDownloadURL();

        debugPrint('GPX file uploaded to Firebase: $downloadUrl');

        return downloadUrl;
      } catch (e) {
        debugPrint('Error uploading GPX file to Firebase: $e');
        throw Exception('Error uploading GPX file to Firebase');
      }
    } else {
      final directory = await getExternalStorageDirectory();
      final dataDirectory =
          directory?.path ?? '/storage/emulated/0/Android/data';

      // Access the relevant task data directly from the TaskManager
      final baseFilename = widget.task.formId;
      final insuranceDirectory = Directory('$dataDirectory/$baseFilename');

      // Delete the insurance directory if it already exists
      if (await insuranceDirectory.exists()) {
        await insuranceDirectory.delete(recursive: true);
      }

      // Create the insurance directory
      await insuranceDirectory.create(recursive: true);

      // Define the Attachments directory inside the insurance directory
      final attachmentsDirectory =
          Directory('${insuranceDirectory.path}/Attachments');

      // Create the Attachments directory if it doesn't exist
      if (!await attachmentsDirectory.exists()) {
        await attachmentsDirectory.create(recursive: true);
      }

      // Generate a unique ID for the files
      var uuid = const Uuid();
      String gpxFilename = '${uuid.v4()}.gpx';

      final gpxFile = File('${attachmentsDirectory.path}/$gpxFilename');

      await gpxFile.writeAsString(gpxString);

      debugPrint('GPX file saved: ${gpxFile.path}');

      return gpxFile.path;
    }
  }

  Future<void> _addMarkerAtCurrentLocation() async {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    LatLng? position = await _locationService.getCurrentLocation();
    _mapService.addMarker(position!);

    if (mounted) {
      if (showConfirmationDialog) {
        bool? shouldRetain = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            title: Text('Confirm Pin Drop',
                style: TextStyle(
                    fontSize: t?.title ?? 14.0, fontWeight: FontWeight.w600)),
            content: StatefulBuilder(
              builder: (context, setState) {
                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFF0F7D40),
                  title: Text('Don\'t show again',
                      style: TextStyle(fontSize: t?.caption ?? 14.0)),
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
                child: const Text('Cancel',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('OK',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500)),
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
  }

  Future<bool> _onWillPop() async {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    if (isLoading) {
      return false;
    }

    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        title: Text(
          'Confirmation',
          style: TextStyle(
              fontSize: t?.title ?? 14.0, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to cancel?',
          style: TextStyle(fontSize: t?.caption ?? 14.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'No',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  void _showAlert(BuildContext context) {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        title: Text('Confirm Action',
            style: TextStyle(
                fontSize: t?.title ?? 14.0, fontWeight: FontWeight.w600)),
        content: Text('Are you sure you want to go back?',
            style: TextStyle(fontSize: t?.caption ?? 14.0)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Yes',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  void _handleStopRoutingRequest() {
    _stopRouting();
  }

  void _handleStartRoutingRequest() {
    _startRouting();
  }

  void _handleAddMarkerCurrentLocation() {
    _addMarkerAtCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final panelMaxHeight = MediaQuery.of(context).size.height * 0.45;
    final panelMinHeight = MediaQuery.of(context).size.height * 0.25;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (isInitializing)
            const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Scaffold(
              body: SlidingUpPanel(
                onPanelSlide: (position) => setState(() {
                  final panelMaxScrollElement = panelMaxHeight - panelMinHeight;
                  fabHeight =
                      position * panelMaxScrollElement + fabHeightClosed;
                }),
                controller: panelController,
                parallaxEnabled: true,
                parallaxOffset: 0.3,
                minHeight: panelMinHeight,
                maxHeight: panelMaxHeight,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30.0)),
                body: _mapService.buildMap(),
                panelBuilder: (controller) => GeoTagBottomSheet(
                  controller: controller,
                  panelController: panelController,
                  latitude: latitude,
                  longitude: longitude,
                  address: address,
                  isRoutingStarted: isRoutingStarted,
                  onStartRoutingRequest: _handleStartRoutingRequest,
                  onStopRoutingRequest: _handleStopRoutingRequest,
                  onAddMarkerCurrentLocationRequest:
                      _handleAddMarkerCurrentLocation,
                ),
              ),
              floatingActionButton: Stack(
                children: [
                  Positioned(
                      right: 0,
                      bottom: fabHeight,
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: FloatingActionButton(
                          onPressed: () =>
                              _getCurrentLocation(addMarker: false),
                          shape: const CircleBorder(),
                          backgroundColor: const Color(0xFF0F7D40),
                          elevation: 4.0,
                          child: SvgPicture.asset(
                            'assets/storage/images/position.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                        ),
                      )),
                  Positioned(
                      top: 80.0,
                      left: 40.0,
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: FloatingActionButton(
                            onPressed: isRoutingStarted
                                ? () {
                                    _showAlert(context);
                                  }
                                : () {
                                    Navigator.pop(context);
                                  },
                            shape: const CircleBorder(),
                            backgroundColor: const Color(0xFF0F7D40),
                            elevation: 4.0,
                            child: SvgPicture.asset(
                              'assets/storage/images/arrow-left.svg',
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            )),
                      )),
                ],
              ),
            ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
