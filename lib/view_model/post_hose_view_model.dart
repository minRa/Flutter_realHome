
import 'package:geocoder/geocoder.dart';
import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/place.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/cloud_storage_service.dart';
import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/services/googleMap_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';
import 'package:uuid/uuid.dart';

class PostHouseViewModel extends BaseModel {

  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = 
   locator<NavigationService>();
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  final GoogleMapService _googleMapService = locator<GoogleMapService>();

  String _selectedMessenger = 'Select a Messenger';
  String get selectedMessenger => _selectedMessenger;

  void setdMessenger(dynamic messenger) {
    _selectedMessenger = messenger;
    notifyListeners();
  }

    String _selectedCity = 'Select a City';
    String get selectedCity => _selectedCity;

    void setdCity(dynamic city) {
      _selectedCity = city;
      notifyListeners();
    }

    Map<String, dynamic> _userDataMap = Map<String, dynamic>();
    
    updateUserData(List<dynamic> data) {
       _userDataMap[data[0]] = data[1];   
    }

    setData(Map<String, dynamic> data) {
      _userDataMap = data;
    }
    

    Future<void> postingHouse({ 
      String title,
      String message,
      String price,
      String messenger,
      String address,
      String phone
    }) async {
         setBusy(true);
          await _cloudStorageService.arrayImageFiles(_userDataMap);
          
          PostProperty property = PostProperty(
          id: _authenticationService.currentUser.id,
          email: _authenticationService.currentUser.email,
          fullName: _authenticationService.currentUser.fullName,
          latitude: _place.latitude, 
          longitude: _place.longitude,
          phone: phone,          
          address: address == null ? _place.address : address,
          title:title,
          price: price,
          city: _place.city,
          message: message,
          messenger: selectedMessenger,
          uuid: Uuid().v1(),
          );

        var result = await _firestoreService.postHouseIntoFirebase(property);
        _userDataMap.clear();
         print(' i have return with result => $result');
          
        if(result != null) {
          await _dialogService.showDialog(
          title: result[0],
          description: result[1],
        );}
         
        //  if(_authenticationService.currentUser.uploadCount < 2) 
        //  _authenticationService.currentUser.uploadCount += 1;
        //  print(_authenticationService.currentUser.uploadCount);
       // await _analyticsService.logSignUp();
        setBusy(false);
      _navigationService.navigateTo(PropertyManageViewRoute);  
    
  }
  Place _place;
  List<Place> _items = [];
  List<Place> get items {
    return [..._items];
  }

  // Place findById(String id) {
  //   return _items.firstWhere((place) => place.id == id);
  // }

  Future<void> addPlace(
    Place pickedLocation,
  ) async {
    final address = await _googleMapService.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
       
      var ass = address.split(',');
      var city = ass[1];
       
      final updatedLocation = Place(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: address,
        city: city);
      _place = updatedLocation;
     
     print(_place.address);
    _items.add(updatedLocation); 
    notifyListeners();
    return address;
  }

}