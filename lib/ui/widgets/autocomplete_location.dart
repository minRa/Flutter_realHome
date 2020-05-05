import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realhome/models/place.dart';
import 'package:realhome/services/googleMap_service.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

// import 'package:example/services/google_map_service.dart';
// import 'package:example/models/place.dart';

class AutocompleteLocation extends StatefulWidget {
  final ValueChanged<PlaceDetail> save;
  final ValueChanged<String> previewUrl;
  AutocompleteLocation({
    this.previewUrl,
    this.save
    });
  @override
  _AutocompleteLocationState createState() => _AutocompleteLocationState();
}

class _AutocompleteLocationState extends State<AutocompleteLocation> {
  final TextEditingController _searchController = TextEditingController();
  var uuid = Uuid();
  var sessionToken;
  var googleMapServices;
  PlaceDetail placeDetail;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();

  Position position;
  double distance = 0.0;
  String myAddr = '';

  @override
  void initState() {
    super.initState();
    _checkGPSAvailability();
  }

  void _checkGPSAvailability() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
  //  print('i am herer ==========================>$geolocationStatus');

    if (geolocationStatus != GeolocationStatus.granted) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Error ! '),
            content: Text('GPS is unable to acess '),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        },
      ).then((_) => Navigator.pop(context));
    } else {
      await _getGPSLocation();
      myAddr = await GoogleMapServices.getAddrFromLocation(
          position.latitude, position.longitude);
      _setMyLocation();
    }
  }

  Future<void> _getGPSLocation() async {
    position = await Geolocator().getCurrentPosition();
    print('latitude: ${position.latitude}, longitude: ${position.longitude}');
  }

  void _setMyLocation() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('myInitialPostion'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'House location', snippet: myAddr),
      ));
    });
  }

  void _moveCamera() async {
    if (_markers.length > 0) {
      setState(() {
        _markers.clear();
      });
    }

    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(placeDetail.lat, placeDetail.lng),
      ),
    );

    await _getGPSLocation();
    myAddr = await GoogleMapServices.getAddrFromLocation(
        position.latitude, position.longitude);

    distance = await Geolocator().distanceBetween(position.latitude,
        position.longitude, placeDetail.lat, placeDetail.lng);

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(placeDetail.placeId),
          position: LatLng(placeDetail.lat, placeDetail.lng),
          infoWindow: InfoWindow(
            title: placeDetail.name,
            snippet: placeDetail.formattedAddress,
          ),
        ),
      );
    });
  } 

  void _showDialog() {
    bool ok = false;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) { 
        // return object of type Dialog
        return AlertDialog(
          title: new Text("would you like to save House address?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No", style: TextStyle(color: Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed:() {
                Navigator.of(context).pop();    
                ok = true;
 
              }
            ),
          ],
        );}
      ).then((_) => {
        if(ok) {Navigator.of(context).pop()} 
      });
    }



  Widget _showPlaceInfo() {
    if (placeDetail == null) {
      return Container();
    }
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Card(
            child: GestureDetector(
                onTap:() {
                  _showDialog();
                },
                child: ListTile(
                leading:Icon(Icons.home),
                title: Text('${placeDetail.formattedAddress}'),
               // title: Text('House location: $myAddr - ${placeDetail.name}'),
                subtitle: Text('${distance.toStringAsFixed(2)} m'),
              ),
            ),
          ),
          // Card(
          //   child: ListTile(
          //     leading: Icon(Icons.branding_watermark),
          //     title: Text('${placeDetail.name}'),
          //   ),
          // ),
          // Card(
          //   child: ListTile(
          //     leading: Icon(Icons.location_city),
          //     title: Text('${placeDetail.formattedAddress}'),
          //   ),
          // ),
          // Card(
          //   child: ListTile(
          //     leading: Icon(Icons.phone),
          //     title: Text('${placeDetail.formattedPhoneNumber}'),
          //   ),
          // ),
          // Card(
          //   child: ListTile(
          //     leading: Icon(Icons.favorite),
          //     title: Text('${placeDetail.rating}'),
          //   ),
          // ),
          // Card(
          //   child: ListTile(
          //     leading: Icon(Icons.place),
          //     title: Text('${placeDetail.vicinity}'),
          //   ),
          // ),
          // Card(
          //   child: ListTile(
          //     leading: Icon(Icons.web),
          //     title: Text('${placeDetail.website}'),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Search Address',
        //textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 45.0,
                child: Image.asset('assets/images/powered_by_google.png'),
              ),
              TypeAheadField(
                debounceDuration: Duration(milliseconds: 500),
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search places...'),
                ),
                suggestionsCallback: (pattern) async {
                  if (sessionToken == null) {
                    sessionToken = uuid.v4();
                  }

                  googleMapServices =
                      GoogleMapServices(sessionToken: sessionToken);

                  return await googleMapServices.getSuggestions(pattern);
                },
                itemBuilder: (context, suggetion) {
                  return ListTile(
                    title: Text(suggetion.description),
                   // subtitle: Text('${suggetion.placeId}'),
                  );
                },
                onSuggestionSelected: (suggetion) async {  
                    var result = await googleMapServices.getPlaceDetail(
                    suggetion.placeId,
                    sessionToken,);
                  setState(() {
                    placeDetail = result;
                  });
                  widget.save(placeDetail);
                  var preview =  GoogleMapServices.generateLocationPreviewImage(latitude: result.lat, longitude: result.lng);
                  widget.previewUrl(preview);
                  sessionToken = null;
                  _moveCamera();
                },
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 350,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      -36.848461,
                      174.763336,
                    ),
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  markers: _markers,
                ),
              ),
              SizedBox(height: 20),
              _showPlaceInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
