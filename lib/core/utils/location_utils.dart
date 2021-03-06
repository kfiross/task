import 'package:geolocation/geolocation.dart';

class LocationUtils{
  static Future<LocationResult> getCurrentLocation() async {
    final GeolocationResult result = await Geolocation.isLocationOperational();
    if(result.isSuccessful) {
      LocationResult result = await Geolocation.lastKnownLocation();
      return result;
      // location permission is granted (or was already granted before making the request)
    }
      // else, location permission is not granted
      // user might have denied, but it's also possible that location service is not enabled, restricted, and user never saw the permission request dialog. Check the result.error.type for details.
      return null;
  }
}