// map_service.dart
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:math' as math;

class MapService {
  final MapController mapController = MapController();
  final List<LatLng> routePoints = [];
  double currentZoom = 20.0;
  final List<Marker> markers = [];
  CurrentLocationLayer? currentLocationLayer;

  void addMarker(LatLng point) {
    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: point,
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40.0,
        ),
      ),
    );
    routePoints.add(point);
  }

  void addColoredMarker(LatLng point, Color color) {
    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: point,
        child: const Icon(
          Icons.location_on,
          color: Colors.green,
          size: 40.0,
        ),
      ),
    );
  }

  void clearMarkers() {
    markers.clear();
  }

  void removeLastMarker() {
    if (markers.isNotEmpty) {
      markers.removeLast();
      routePoints.removeLast();
    }
  }

  void addRoutePoint(LatLng point) {
    routePoints.add(point);
    moveMap(point);
  }

  void clearRoutePoints() {
    routePoints.clear();
  }

  void moveMap(LatLng point) {
    mapController.move(point, currentZoom);
  }

  void zoomMap(double zoom) {
    currentZoom = zoom;
    mapController.move(mapController.center, zoom);
  }

  Future<Uint8List?> captureMapScreenshot() async {
    final ScreenshotController screenshotController = ScreenshotController();

    // Calculate the bounds of the route points
    if (routePoints.isNotEmpty) {
      double minLat = routePoints.last.latitude;
      double maxLat = routePoints.first.latitude;
      double minLng = routePoints.last.longitude;
      double maxLng = routePoints.first.longitude;

      for (final point in routePoints) {
        minLat = math.min(minLat, point.latitude);
        maxLat = math.max(maxLat, point.latitude);
        minLng = math.min(minLng, point.longitude);
        maxLng = math.max(maxLng, point.longitude);
      }

      final bounds = LatLngBounds(
        LatLng(minLat, minLng),
        LatLng(maxLat, maxLng),
      );

      // Center the map to fit the route bounds
      mapController.fitBounds(bounds);

      // Delay the screenshot capture to allow the map to animate and render
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    final mapWidget = buildMap();
    final containerWidget = Container(
      child: mapWidget,
    );

    return await screenshotController.captureFromWidget(containerWidget);
  }

  Widget buildMap() {
    return MediaQuery(
      data: const MediaQueryData(),
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: const LatLng(13.138769, 123.734005),
          initialZoom: currentZoom,
          maxZoom: 22.0,
          onPositionChanged: (position, hasGesture) {
            currentZoom = position.zoom!;
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                // 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                'https://api.mapbox.com/styles/v1/quanbysolutions/cluhoxol502q801oi8od2cmvz/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicXVhbmJ5c29sdXRpb25zIiwiYSI6ImNsdWhrejRwdDJyYnAya3A2NHFqbXlsbHEifQ.WJ5Ng-AO-dTrlkUHD_ebMw',
            tileProvider: CancellableNetworkTileProvider(),
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
          MarkerLayer(
            markers: markers,
          ),
          CurrentLocationLayer(
            alignPositionOnUpdate: AlignOnUpdate.always,
            alignDirectionOnUpdate: AlignOnUpdate.never,
            style: const LocationMarkerStyle(
              marker: DefaultLocationMarker(
                child: Icon(
                  Icons.person_pin_circle_outlined,
                  color: Colors.white,
                ),
              ),
              markerSize: Size(40, 40),
              markerDirection: MarkerDirection.heading,
            ),
          ),
        ],
      ),
    );
  }

  void dispose() {
    mapController.dispose();
    // currentLocationLayer?.dispose();
  }

  // calculation
  double calculateAreaOfPolygon(List<LatLng> points) {
    if (points.length < 3) {
      return 0.0; // Not a polygon
    }
    double radius = 6378137.0; // Earth's radius in meters
    double area = 0.0;

    for (int i = 0; i < points.length; i++) {
      LatLng p1 = points[i];
      LatLng p2 = points[(i + 1) % points.length]; // Wrap around at the end

      double lat1 = p1.latitudeInRad;
      double lon1 = p1.longitudeInRad;
      double lat2 = p2.latitudeInRad;
      double lon2 = p2.longitudeInRad;

      // Calculate segment area (using spherical excess formula)
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
}
