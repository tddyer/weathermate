import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

// holds device location data using latitude + longitude
class Location {

  double latitude;
  double longitude;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }

}