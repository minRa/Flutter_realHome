
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:realhome/models/place.dart';
import 'package:realhome/services/googleMap_service.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
//import 'package:realhome/models/place.dart';
//import 'package:realhome/services/googleMap_service.dart';
import 'package:realhome/ui/widgets/autocomplete_location.dart';
//import 'package:realhome/ui/widgets/custom_button.dart';
//import 'package:realhome/ui/widgets/google_map_view.dart';

class AddPlace extends StatefulWidget {

    final ValueChanged<PlaceDetail> save;
    final TextEditingController address;
    final Function addLocation;
    AddPlace({
      this.addLocation,
      this.address,
      this.save, 
    });

  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
   String _previewImageUrl;
   String _addressDisplay;
 @override
  void initState() {
     if(widget.address.text !=''){
       _addressDisplay = widget.address.text;
     }
    super.initState();
  }

   void _showPreview(double lat, double lng) {
    final staticMapImageUrl = GoogleMapServices.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });  
  }

  void _onSelectPlace(double lat, double lng)  async{  
     String addressDisplay = await widget.addLocation(lat, lng);
     setState(() {
       _addressDisplay = addressDisplay;
         widget.address.text =   addressDisplay;
     });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude, locData.longitude);
      _onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  void updatePrivewImageUrl(String url) {
    setState(() {
      _previewImageUrl = url;
    });
  }

  void updatePlaceDetail(PlaceDetail placeDetail) {
     setState(() {
        _addressDisplay = placeDetail.formattedAddress;
         widget.address.text = _addressDisplay;
         widget.save(placeDetail);
     });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,),
                          Column(
                          children: <Widget>[
                            Container(
                              height: 170,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                               // border: Border.all(width: 1, color: Colors.grey),
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
                                      onPressed: () {
                                           Navigator.of(context).push(
                                           MaterialPageRoute(builder: (context) {
                                          return AutocompleteLocation(
                                            previewUrl:updatePrivewImageUrl ,
                                            save: updatePlaceDetail,
                                          );
                                            }),); 
                                           }
                                         ),
                                        ],
                                      ),
                                    SizedBox(height: 30,),  
                                    // Card(
                                    // child: 
                                    ListTile(
                                    leading: Text('Address : ',
                                    style: TextStyle(
                                      fontSize: 20
                                    ),
                                    ),
                                    title:_addressDisplay != null ? 
                                    Text(
                                      _addressDisplay,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18.0
                                      ),) :
                                       Text(
                                      'Please select your address in google map',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18.0
                                      ),),
                                   ),
                                 // ),              
                                 ],
                              ),

          ],
        ),),),)],),
      )
    );
  }
}

//  String _previewImageUrl;
  //  Place _pickedLocation;
  //  String addressDisplay;
  //  bool visual = false;

  //  void _showPreview(double lat, double lng) {
  //   final staticMapImageUrl = GoogleMapService.generateLocationPreviewImage(
  //     latitude: lat,
  //     longitude: lng,
  //   );
  //   setState(() {
  //     _previewImageUrl = staticMapImageUrl;
  //   });  
  // }

  // void _onSelectPlace(double lat, double lng) {
  //   _pickedLocation = Place(latitude: lat, longitude: lng);
  //    _savePlace();  
  // }

  // Future<void> _getCurrentUserLocation() async {
  //   try {
  //     final locData = await Location().getLocation();
  //     _showPreview(locData.latitude, locData.longitude);
  //     _onSelectPlace(locData.latitude, locData.longitude);
  //   } catch (error) {
  //     return;
  //   }
  // }

  // Future<void> _selectOnMap() async {

  //   final selectedLocation = await Navigator.of(context).push<LatLng>(
  //     MaterialPageRoute(
  //       fullscreenDialog: true,
  //       builder: (ctx) =>GoogleMapView(
  //             isSelecting: true,
  //           ),
  //     ),
  //   );
  //   if (selectedLocation == null) {
  //     return;
  //   }
  //   _showPreview(selectedLocation.latitude, selectedLocation.longitude);
  //   _onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);

  // }

  // Future<void> _savePlace() async {
  //   if (_pickedLocation == null) {
  //     return;
  //   }
  //   var address = await widget.addLocation( _pickedLocation);
  //   if(address !=null)
  //    setState(() {
  //      addressDisplay = address;
  //    });
  //  // Navigator.of(context).pop();
  // }

// Column(
// children: <Widget>[
//   Container(
//     height: 170,
//     width: double.infinity,
//     alignment: Alignment.center,
//     decoration: BoxDecoration(
//       border: Border.all(width: 1, color: Colors.grey),
//     ),
//             child: _previewImageUrl == null
//     ? Text(
//         'No Location Chosen',
//         textAlign: TextAlign.center,
//       )
//     : Image.network(
//         _previewImageUrl,
//         fit: BoxFit.cover,
//         width: double.infinity,
//       ),
//     ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           FlatButton.icon(
//             icon: Icon(
//               Icons.location_on,
//             ),
//             label: Text('Current Location'),
//             textColor: Theme.of(context).primaryColor,
//             onPressed: _getCurrentUserLocation,
//           ),
//           FlatButton.icon(
//             icon: Icon(
//               Icons.map,
//             ),
//             label: Text('Select on Map'),
//             textColor: Theme.of(context).primaryColor,
//             onPressed: _selectOnMap,
//                         ),
//               ],
//             ),
//           Container(
//             child: addressDisplay != null ?  
//             Text(
//               addressDisplay,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.black54,
//                 fontSize: 20.0
//               ),
//               )
//               : null
//           )
//           ],
//         ),

// // class LocationInput extends StatefulWidget {
// //   final Function onSelectPlace;

// //   LocationInput(this.onSelectPlace);

// //   @override
// //   _LocationInputState createState() => _LocationInputState();
// // }

// // class _LocationInputState extends State<LocationInput> {
// //   String _previewImageUrl;

// //   void _showPreview(double lat, double lng) {
// //     final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
// //       latitude: lat,
// //       longitude: lng,
// //     );
// //     setState(() {
// //       _previewImageUrl = staticMapImageUrl;
// //     });
// //   }

// //   Future<void> _getCurrentUserLocation() async {
// //     try {
// //       final locData = await Location().getLocation();
// //       _showPreview(locData.latitude, locData.longitude);
// //       widget.onSelectPlace(locData.latitude, locData.longitude);
// //     } catch (error) {
// //       return;
// //     }
// //   }

// //   Future<void> _selectOnMap() async {
// //     final selectedLocation = await Navigator.of(context).push<LatLng>(
// //       MaterialPageRoute(
// //         fullscreenDialog: true,
// //         builder: (ctx) => MapScreen(
// //               isSelecting: true,
// //             ),
// //       ),
// //     );
// //     if (selectedLocation == null) {
// //       return;
// //     }
// //     _showPreview(selectedLocation.latitude, selectedLocation.longitude);
// //     widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: <Widget>[
// //         Container(
// //           height: 170,
// //           width: double.infinity,
// //           alignment: Alignment.center,
// //           decoration: BoxDecoration(
// //             border: Border.all(width: 1, color: Colors.grey),
// //           ),
// //           child: _previewImageUrl == null
// //               ? Text(
// //                   'No Location Chosen',
// //                   textAlign: TextAlign.center,
// //                 )
// //               : Image.network(
// //                   _previewImageUrl,
// //                   fit: BoxFit.cover,
// //                   width: double.infinity,
// //                 ),
// //         ),
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             FlatButton.icon(
// //               icon: Icon(
// //                 Icons.location_on,
// //               ),
// //               label: Text('Current Location'),
// //               textColor: Theme.of(context).primaryColor,
// //               onPressed: _getCurrentUserLocation,
// //             ),
// //             FlatButton.icon(
// //               icon: Icon(
// //                 Icons.map,
// //               ),
// //               label: Text('Select on Map'),
// //               textColor: Theme.of(context).primaryColor,
// //               onPressed: _selectOnMap,
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// // }
