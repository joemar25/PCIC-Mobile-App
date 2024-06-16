// src/geotag/controls/_map_service.dart
import 'dart:async';
import 'dart:math';

import 'package:gpx/gpx.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

import '../../theme/_theme.dart';
import '_location_service.dart';

class MapService {
  final MapController mapController = MapController();
  final List<LatLng> routePoints = [];
  double currentZoom = 20.0;
  final List<Marker> markers = [];
  bool _isDisposed = false;
  StreamSubscription<LatLng>? locationSubscription;

  void initLocationService() {
    final locationService = LocationService();
    locationService.requestLocationPermission().then((_) {
      locationSubscription =
          locationService.getLocationStream().listen((location) {
        addMarker(location);
        moveMap(location);
      });
    });
  }

  void addMarker(LatLng point) {
    if (_isDisposed) return;
    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: point,
        child: const Icon(
          Icons.location_on,
          color: mainColor,
          size: 40.0,
        ),
      ),
    );
    routePoints.add(point);
  }

  void addColoredMarker(LatLng point, Color color) {
    if (_isDisposed) return;
    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: point,
        child: const Icon(
          Icons.location_on,
          color: mainColor,
          size: 40.0,
        ),
      ),
    );
  }

  void clearMarkers() {
    if (_isDisposed) return;
    markers.clear();
  }

  void removeLastMarker() {
    if (_isDisposed) return;
    if (markers.isNotEmpty) {
      markers.removeLast();
      routePoints.removeLast();
    }
  }

  void addRoutePoint(LatLng point) {
    if (_isDisposed) return;
    routePoints.add(point);
    moveMap(point);
  }

  void clearRoutePoints() {
    if (_isDisposed) return;
    routePoints.clear();
  }

  void moveMap(LatLng point) {
    if (_isDisposed) return;
    mapController.move(point, currentZoom);
  }

  void zoomMap(double zoom) {
    if (_isDisposed) return;
    currentZoom = zoom;
    mapController.move(mapController.center, zoom);
  }

  double calculateZoomLevel(double totalDistance) {
    double zoomLevel = 18.0 - (totalDistance / 10000.0);
    return zoomLevel.clamp(10.0, 20.0);
  }

  LatLng calculateCenterPoint(List<LatLng> points) {
    double latSum = 0.0;
    double lngSum = 0.0;

    for (var point in points) {
      latSum += point.latitude;
      lngSum += point.longitude;
    }

    double centerLat = latSum / points.length;
    double centerLng = lngSum / points.length;

    return LatLng(centerLat, centerLng);
  }

  Widget buildMap() {
    return MediaQuery(
      data: const MediaQueryData(),
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: const LatLng(13.138769, 123.734005),
          zoom: currentZoom,
          maxZoom: 22.0,
          onPositionChanged: (position, hasGesture) {
            if (_isDisposed) return;
            currentZoom = position.zoom!;
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/quanbysolutions/cluhoxol502q801oi8od2cmvz/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicXVhbmJ5c29sdXRpb25zIiwiYSI6ImNsdWhrejRwdDJyYnAya3A2NHFqbXlsbHEifQ.WJ5Ng-AO-dTrlkUHD_ebMw',
            tileProvider: CancellableNetworkTileProvider(),
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 4.0,
                color: Colors.white,
              ),
            ],
          ),
          MarkerLayer(
            markers: markers,
          ),
          CurrentLocationLayer(
            alignPositionOnUpdate: AlignOnUpdate.always,
            alignDirectionOnUpdate: AlignOnUpdate.never,
            style: LocationMarkerStyle(
              marker: DefaultLocationMarker(
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        secondaryColor, // Set your desired background color here
                    borderRadius: BorderRadius.circular(
                        15), // Set your desired border radius here
                  ),
                  child: const Icon(
                    Icons.location_pin,
                    color: mainColor,
                  ),
                ),
              ),
              showAccuracyCircle: false,
              showHeadingSector: false,
              markerSize: const Size(30, 30),
              markerDirection: MarkerDirection.heading,
            ),
          ),
        ],
      ),
    );
  }

  void dispose() {
    _isDisposed = true;
    locationSubscription?.cancel();
    mapController.dispose();
  }

  double calculateAreaOfPolygon(List<LatLng> points) {
    if (points.length < 3) {
      return 0.0;
    }
    double radius = 6378137.0;
    double area = 0.0;

    for (int i = 0; i < points.length; i++) {
      LatLng p1 = points[i];
      LatLng p2 = points[(i + 1) % points.length];

      double lat1 = p1.latitudeInRad;
      double lon1 = p1.longitudeInRad;
      double lat2 = p2.latitudeInRad;
      double lon2 = p2.longitudeInRad;

      double segmentArea = 2 *
          atan2(
            tan((lon2 - lon1) / 2) * tan((lat1 + lat2) / 2),
            1 + tan(lat1 / 2) * tan(lat2 / 2) * cos(lon1 - lon2),
          );
      area += segmentArea;
    }

    return (area * radius * radius).abs();
  }

  double calculateTotalDistance(List<LatLng> points) {
    double totalDistance = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += const Distance().as(
        LengthUnit.Meter,
        points[i],
        points[i + 1],
      );
    }
    return totalDistance;
  }

  Future<String> readGpxFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Error reading GPX file from URL');
      }
    } catch (e) {
      throw Exception('Error reading GPX file: $e');
    }
  }

  Future<List<LatLng>> parseGpxData(String gpxData) async {
    final gpx = GpxReader().fromString(gpxData);
    if (gpx.trks.isEmpty) {
      throw Exception('Invalid GPX data');
    }

    final track = gpx.trks.first;
    final segment = track.trksegs.first;
    final points = segment.trkpts;

    return points.map((pt) => LatLng(pt.lat!, pt.lon!)).toList();
  }
}
