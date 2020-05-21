
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
  final String name;
  final String city;
  final double lat;
  final double lng;

  PlaceDetail({
    this.placeId,
    this.formattedAddress,
    this.city,
    this.name,
    this.lat,
    this.lng,
  });
  

  PlaceDetail.fromJson(Map<String, dynamic> json)
      : this.placeId = json['place_id'],
        this.formattedAddress = json['formatted_address'],
        this.name = json['name'],
        this.city = json['address_components'][3]['long_name'],
        this.lat = json['geometry']['location']['lat'],
        this.lng = json['geometry']['location']['lng'];

  Map<String, dynamic> toMap() {
    return {
      'placeId': this.placeId,
      'formateedAddress': this.formattedAddress,
      'name': this.name,
      'city':this.city,
      'lat': this.lat,
      'lng': this.lng,
    };
  }
}
