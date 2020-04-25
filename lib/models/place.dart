import 'package:flutter/foundation.dart';

class Place {
  final double latitude;
  final double longitude;
  final String address;
  final String city;

  const Place({
    @required this.latitude,
    @required this.longitude,
    this.city,
    this.address,
  });
}

