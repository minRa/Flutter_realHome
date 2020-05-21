import 'package:flutter/material.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realhome/models/place.dart';
import 'package:realhome/services/googleMap_service.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';



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
  LatLng initLocation = LatLng(-36.848461, 174.763336,); //auckland city
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
 
  @override
  void dispose() {
  FocusScope.of(context).unfocus();
  _searchController.dispose();
    super.dispose();
  }


  void _checkGPSAvailability() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
     if (geolocationStatus != GeolocationStatus.granted) {}
      await _getGPSLocation();
      myAddr = await GoogleMapServices.getAddrFromLocation(
          position.latitude, position.longitude);
      _setMyLocation();

    //}
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
          title: new Text("would you like to save House address?",
          style: GoogleFonts.mcLaren(),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No",
               style: GoogleFonts.mcLaren(color: Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
              style: GoogleFonts.mcLaren(),
              ),
              onPressed:() {
                FocusScope.of(context).unfocus();
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
                title: Text('${placeDetail.formattedAddress}',
                 style: GoogleFonts.mcLaren(),
                ),
               // title: Text('House location: $myAddr - ${placeDetail.name}'),
                subtitle: Text('${distance.toStringAsFixed(2)} m far away from you',
                 style: GoogleFonts.mcLaren(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     Size screenSize = MediaQuery.of(context).size/ 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Search Address',
         style: GoogleFonts.mcLaren(),
        //textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15,),
              SizedBox(
                height: 35.0,
                child: Text('Google Map',
                style: GoogleFonts.mcLaren(),
                ) // Image.asset('assets/images/powered_by_google.png'),
              ),
              TypeAheadField(
                debounceDuration: Duration(milliseconds: 500),
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: 'Search house address...',
                      hintStyle: GoogleFonts.mcLaren(),
                      ),
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
                    title: Text(suggetion.description,
                     style: GoogleFonts.mcLaren(),
                    ),
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
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: screenSize.height > 700 ? 340 : 
                 screenSize.height > 620 ? 300 : 250,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: initLocation,
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  markers: _markers,
                ),
              ),
              SizedBox(height: 5),
              _showPlaceInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
