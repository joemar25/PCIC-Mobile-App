import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 1. import this file to other file -> import 'package:pcic_mobile_app/utils/app_env.dart';
/// 2. Call the variable using Classname.VARNAME -> Env.VARIABLE_NAME

class Env {
  static String get MAPBOX_DOWNLOADS_TOKEN =>
      dotenv.env['MAPBOX_DOWNLOADS_TOKEN'] ?? '';

  static String get MAPBOX_ACCESS_TOKEN =>
      dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
}
