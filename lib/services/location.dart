import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class Location {

  double latitude;
  double longitude;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
      print(position);
    } catch (e) {
      print(e);
    }
  }

}