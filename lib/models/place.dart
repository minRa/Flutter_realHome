// import 'package:flutter/foundation.dart';

// class Place {
//   final double latitude;
//   final double longitude;
//   final String address;
//   final String city;

//   const Place({
//     @required this.latitude,
//     @required this.longitude,
//     this.city,
//     this.address,
//   });
// }




class Place {
  final String description;
  final String placeId;

  Place({this.description, this.placeId});

  Place.fromJson(Map<String, dynamic> json)
      : this.description = json['description'],
        this.placeId = json['place_id'];

  Map<String, dynamic> toMap() {
    return {
      'description': this.description,
      'placeId': this.placeId,
    };
  }
}

class PlaceDetail {
  final String placeId;
  final String formattedAddress;
 // final String formattedPhoneNumber;
  final String name;
  final String city;
  //final double rating;
  //final String vicinity;
 // final String website;
  final double lat;
  final double lng;

  PlaceDetail({
    this.placeId,
    this.formattedAddress,
    this.city,
    //this.formattedPhoneNumber,
    this.name,
   // this.rating,
   // this.vicinity,
   // this.website = '',
    this.lat,
    this.lng,
  });
  

  PlaceDetail.fromJson(Map<String, dynamic> json)
      : this.placeId = json['place_id'],
        this.formattedAddress = json['formatted_address'],
        //this.formattedPhoneNumber = json['formatted_phone_number'],
        this.name = json['name'],
        this.city = json['address_components'][3]['long_name'],
        //this.rating = json['rating'].toDouble(),
      //  this.vicinity = json['vicinity'],
       // this.website = json['website'] ?? '',
        this.lat = json['geometry']['location']['lat'],
        this.lng = json['geometry']['location']['lng'];

  Map<String, dynamic> toMap() {
    return {
      'placeId': this.placeId,
      'formateedAddress': this.formattedAddress,
   //   'formateedPhoneNumber': this.formattedPhoneNumber,
      'name': this.name,
      'city':this.city,
    //  'rating': this.rating,
   //   'vicinity': this.vicinity,
     // 'website': this.website,
      'lat': this.lat,
      'lng': this.lng,
    };
  }
}
