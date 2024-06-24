// src/geotag/controls/elevation_service.dart
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter/foundation.dart';

class ElevationService {
  static const String mapboxAccessToken =
      'pk.eyJ1IjoicXVhbmJ5c29sdXRpb25zIiwiYSI6ImNsdWhrejRwdDJyYnAya3A2NHFqbXlsbHEifQ.WJ5Ng-AO-dTrlkUHD_ebMw';

  static Future<double> getElevationFromMapbox(LatLng point) async {
    final url =
        'https://api.mapbox.com/v4/mapbox.terrain-rgb/${point.longitude},${point.latitude}.pngraw?access_token=$mapboxAccessToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        if (bytes.length >= 3) {
          int r = bytes[0];
          int g = bytes[1];
          int b = bytes[2];
          double height = -10000 + ((r * 256 * 256 + g * 256 + b) * 0.1);
          return height;
        }
      }
    } catch (e) {
      debugPrint('Error fetching elevation data: $e');
    }
    // Return 0 if elevation data couldn't be fetched
    return 0.0;
  }
}
