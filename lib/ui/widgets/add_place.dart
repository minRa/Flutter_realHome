
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:realhome/models/place.dart';
import 'package:realhome/services/googleMap_service.dart';
import 'package:realhome/ui/widgets/google_map_view.dart';

class AddPlace extends StatefulWidget {
    final Function addLocation;
   final TextEditingController addressController;
    AddPlace({
      this.addLocation, 
      this.addressController
    });

  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
   String _previewImageUrl;
   Place _pickedLocation;
   String addressDisplay;
   bool visual = false;

   void _showPreview(double lat, double lng) {
    final staticMapImageUrl = GoogleMapService.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });  
  }

  void _onSelectPlace(double lat, double lng) {
    _pickedLocation = Place(latitude: lat, longitude: lng);
     _savePlace();  
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
       print(locData.latitude);
      _showPreview(locData.latitude, locData.longitude);
      _onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) =>GoogleMapView(
              isSelecting: true,
            ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    _onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);

  }

  Future<void> _savePlace() async {
    if (_pickedLocation == null) {
      return;
    }
    var address = await widget.addLocation( _pickedLocation);
    if(address !=null)
     setState(() {
       addressDisplay = address;
     });
   // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),Column(
                        children: <Widget>[
                          Container(
                            height: 170,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                                    child: _previewImageUrl == null
                            ? Text(
                                'No Location Chosen',
                                textAlign: TextAlign.center,
                              )
                            : Image.network(
                                _previewImageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton.icon(
                                    icon: Icon(
                                      Icons.location_on,
                                    ),
                                    label: Text('Current Location'),
                                    textColor: Theme.of(context).primaryColor,
                                    onPressed: _getCurrentUserLocation,
                                  ),
                                  FlatButton.icon(
                                    icon: Icon(
                                      Icons.map,
                                    ),
                                    label: Text('Select on Map'),
                                    textColor: Theme.of(context).primaryColor,
                                    onPressed: _selectOnMap,
                                                ),
                                      ],
                                    ),
                                  Container(
                                    child: addressDisplay != null ?  
                                    Text(
                                      addressDisplay,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20.0
                                      ),
                                     )
                                     : null
                                  )
                                  ],
                                ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Text('If your Google map Address is an incorrect, just Click and Add your Address',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            
                          ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.blueGrey,),
                          onPressed: () {
                            setState(() {
                              visual= !visual;
                            });
                          },
                        ),
                        Divider(),
                          Visibility(
                          visible: visual ,
                          child: SizedBox(
                          width: 360,
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                icon:Icon(Icons.home, color: Colors.blueGrey),
                                labelText: 'Address',
                                hintText: 'Type your Address'
                            ),
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return 'Address is required';
                              }else {
                              return null;
                              }
                            },
                            style: TextStyle(color: Colors.black),
                            controller: widget.addressController,
                        ),
                      ),
                    ),
              SizedBox(height: 10,)
        ],
      ),
    );
  }
}


// class LocationInput extends StatefulWidget {
//   final Function onSelectPlace;

//   LocationInput(this.onSelectPlace);

//   @override
//   _LocationInputState createState() => _LocationInputState();
// }

// class _LocationInputState extends State<LocationInput> {
//   String _previewImageUrl;

//   void _showPreview(double lat, double lng) {
//     final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
//       latitude: lat,
//       longitude: lng,
//     );
//     setState(() {
//       _previewImageUrl = staticMapImageUrl;
//     });
//   }

//   Future<void> _getCurrentUserLocation() async {
//     try {
//       final locData = await Location().getLocation();
//       _showPreview(locData.latitude, locData.longitude);
//       widget.onSelectPlace(locData.latitude, locData.longitude);
//     } catch (error) {
//       return;
//     }
//   }

//   Future<void> _selectOnMap() async {
//     final selectedLocation = await Navigator.of(context).push<LatLng>(
//       MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (ctx) => MapScreen(
//               isSelecting: true,
//             ),
//       ),
//     );
//     if (selectedLocation == null) {
//       return;
//     }
//     _showPreview(selectedLocation.latitude, selectedLocation.longitude);
//     widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Container(
//           height: 170,
//           width: double.infinity,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             border: Border.all(width: 1, color: Colors.grey),
//           ),
//           child: _previewImageUrl == null
//               ? Text(
//                   'No Location Chosen',
//                   textAlign: TextAlign.center,
//                 )
//               : Image.network(
//                   _previewImageUrl,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             FlatButton.icon(
//               icon: Icon(
//                 Icons.location_on,
//               ),
//               label: Text('Current Location'),
//               textColor: Theme.of(context).primaryColor,
//               onPressed: _getCurrentUserLocation,
//             ),
//             FlatButton.icon(
//               icon: Icon(
//                 Icons.map,
//               ),
//               label: Text('Select on Map'),
//               textColor: Theme.of(context).primaryColor,
//               onPressed: _selectOnMap,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
