import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'controls/countdown_timer.dart';

import '../ppir_form/_pcic_form.dart';
import 'controls/_map_service.dart';
import 'controls/_location_service.dart';
import 'components/_bottomsheet.dart';
import '../theme/_theme.dart';
import '../../utils/app/_show_flash_message.dart';
import '../tasks/controllers/task_manager.dart';
import 'controls/gpx_service.dart';

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
  final GpxService _gpxService = GpxService();
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

  bool saveOnline = true;

  int countdown = 0;
  Timer? _countdownTimer;

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
    _countdownTimer?.cancel();
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

          // Perform reverse geocoding to get the address
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            setState(() {
              address =
                  '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
              debugPrint('Address: $address'); // Log the address for debugging
            });
          }

          if (addMarker) {
            _mapService.addMarker(position);
          }
        }
      });
    }
  }

  void _startCountdown() {
    setState(() {
      countdown = 5;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 1) {
          countdown--;
        } else {
          timer.cancel();
          countdown = 0;
          _startRouting();
        }
      });
    });
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
        List<LatLng> routePoints = _mapService.routePoints;

        // Close the route loop
        _closeRouteLoop(routePoints);

        var gpx = _gpxService.createGpxFromRoutePoints(routePoints);
        var gpxString = _gpxService.convertGpxToString(gpx);

        await _gpxService.saveGpxFile(gpxString, widget.task, saveOnline);

        if (routePoints.isNotEmpty) {
          await widget.task.updateLastCoordinates(
              LatLng(routePoints.last.latitude, routePoints.last.longitude));
        }

        // Calculate and update the area and distance
        await _calculateAndUpdateTask(routePoints);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              isRoutingStarted = false;
              _mapService.clearMarkers();
              isLoading = false;
            });

            _mapService.dispose();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PPIRFormPage(
                  task: widget.task,
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
            debugPrint('Exception caught: $e');

            showFlashMessage(context, 'Error', 'Error Saving File',
                'Something went wrong! Please try again.');
            Navigator.pop(context);
          }
        });
      }
    }
  }

  Future<void> _calculateAndUpdateTask(List<LatLng> routePoints) async {
    if (routePoints.isNotEmpty) {
      final mapService = MapService();
      final distance = mapService.calculateTotalDistance(routePoints);
      double area = mapService.calculateAreaOfPolygon(routePoints);
      double areaInHectares = area / 10000;

      final taskData = {
        'trackTotalarea': areaInHectares.toString(),
        'trackTotaldistance': distance.toString()
      };

      await widget.task.updateTaskData(taskData);
    }
  }

  void _closeRouteLoop(List<LatLng> routePoints) {
    if (routePoints.isNotEmpty) {
      final initialPoint = routePoints.first;
      final closingPoint = routePoints.last;

      if (!_isCloseEnough(initialPoint, closingPoint)) {
        // Add the initial point to the end to close the loop
        routePoints.add(initialPoint);
      }
    }
  }

  bool _isCloseEnough(LatLng point1, LatLng point2) {
    const double threshold = 10.0;
    final distance = const Distance().as(LengthUnit.Meter, point1, point2);
    return distance <= threshold;
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
    _startCountdown();
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
                        onPressed: () => _getCurrentLocation(addMarker: false),
                        shape: const CircleBorder(),
                        backgroundColor: const Color(0xFF0F7D40),
                        elevation: 4.0,
                        child: SvgPicture.asset(
                          'assets/storage/images/position.svg',
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
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
                    ),
                  ),
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
          if (countdown > 0) CountdownTimer(countdown: countdown),
        ],
      ),
    );
  }
}
