
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:realhome/models/place.dart';
import 'package:realhome/services/googleMap_service.dart';
import 'package:realhome/ui/widgets/autocomplete_location.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/services/googleAds_service.dart';

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
final GoogleAdsService _googleAdsService = locator<GoogleAdsService>(); 
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

  // @override
  // void didChangeDependencies() {
  //   if(!_googleAdsService.onBanner){
  //      _googleAdsService.bottomBanner();
  //   }
  //   super.didChangeDependencies();
  // }

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
                                  style: GoogleFonts.mcLaren(),
                                  textAlign: TextAlign.center,
                                )
                              : Image.network(
                                  _previewImageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    FlatButton.icon(
                                      icon: Icon(
                                        Icons.location_on,
                                      ),
                                      label: Text('Current Location',
                                      style: GoogleFonts.mcLaren(fontSize: 13),),
                                      textColor: Theme.of(context).primaryColor,
                                      onPressed: _getCurrentUserLocation,
                                    ),
                                    FlatButton.icon(
                                      icon: Icon(
                                        Icons.map,
                                      ),
                                      label: Text('Select on Map',
                                      style: GoogleFonts.mcLaren(fontSize: 13),
                                      ),
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
                                    ListTile(
                                    leading: Text('Address : ',
                                    style: GoogleFonts.mcLaren(fontSize: 20),
                                    ),
                                    title:_addressDisplay != null ? 
                                    Text(
                                      _addressDisplay,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.mcLaren(
                                      fontSize: 18, 
                                      color: Colors.black54)
                                      ) :
                                       Text(
                                      'Please select your address in google map',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.mcLaren(color: Colors.black54,
                                        fontSize: 18.0),
                                      ),
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

