import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realhome/models/place.dart';

class GoogleMapView extends StatefulWidget {
 final Place initialLocation;
  final bool isSelecting;

  GoogleMapView({
    this.initialLocation =
        const Place(latitude: 37.422, longitude: -122.084),
    this.isSelecting = false,
  });

  @override
  _GoogleMapViewState createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  LatLng _pickedLocation;



  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Click your place in Google map'),
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (_pickedLocation == null && widget.isSelecting)
            ? null
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(
                        widget.initialLocation.latitude,
                        widget.initialLocation.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
