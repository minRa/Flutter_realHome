
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:realhome/models/place.dart';
import 'package:realhome/services/secret.dart';




class GoogleMapServices {
  final String sessionToken;

  GoogleMapServices({this.sessionToken});


  static String generateLocationPreviewImage({double latitude, double longitude,}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

    Future<String> getPlaceAddress(double lat, double lng) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }

  Future<List> getSuggestions(String query) async {
    
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
   // final String baseUrl2 ="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places"
    String type = 'address';//'sublocality'; //'locality' ;  //'establishment';
    String url =
        '$baseUrl?input=$query&key=$GOOGLE_API_KEY&type=$type&language=en&components=country:nz&sessiontoken=$sessionToken';

    print('Autocomplete(sessionToken): $sessionToken');

    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final predictions = responseData['predictions'];

    List<Place> suggestions = [];

    for (int i = 0; i < predictions.length; i++) {
      final place = Place.fromJson(predictions[i]);
      suggestions.add(place);
    }

    return suggestions;
  }

  Future<PlaceDetail> getPlaceDetail(String placeId, String token) async {
   // print('i am herer');
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    String url =
        '$baseUrl?key=$GOOGLE_API_KEY&place_id=$placeId&language=en&sessiontoken=$token';

    print('Place Detail(sessionToken): $sessionToken');
    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final result = responseData['result'];
    print('i am erer =====================================>$result');

    final PlaceDetail placeDetail = PlaceDetail.fromJson(result);
    print(placeDetail.toMap());

    return placeDetail;
  }

  static Future<String> getAddrFromLocation(double lat, double lng) async {
    final String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
    String url = '$baseUrl?latlng=$lat,$lng&key=$GOOGLE_API_KEY&language=en';

    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final formattedAddr = responseData['results'][0]['formatted_address'];
    print(formattedAddr);

    return formattedAddr;
  }

  static String getStaticMap(double latitude, double longitude) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }
}
