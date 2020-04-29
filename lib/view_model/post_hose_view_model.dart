
import 'dart:io';
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



class PostHouseViewModel extends BaseModel {

  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = 
   locator<NavigationService>();
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  final GoogleMapService _googleMapService = locator<GoogleMapService>();
    
    String _date;
     updateDate(String date) {
       _date = date;
    }

    String _rentType ='Single';
     updateRentType(String rentType) {
       _rentType = rentType;
    }
   
    PostProperty _postProperty;
    Map<String, dynamic> _userDataMap = Map<String, dynamic>();
    


    Future postingHouse({ 
      String title,
      String message,
      String price,
      String messenger,
     // String address,
      String phone
    }) async {
       try {

        print('what is happen ========================================================================');
         setBusy(true);
          await _cloudStorageService.arrayImageFiles(_userDataMap);
          if(_postProperty == null) {
          PostProperty property = PostProperty(
          id: _authenticationService.currentUser.id,
          email:_authenticationService.currentUser.email,
          fullName: _authenticationService.currentUser.fullName,
          phone: phone,  
          title:title,
          price: price,
          message: message,
          messenger: messenger,
          latitude: _place.latitude, 
          longitude:_place.longitude,
          rentType:_rentType,
          date:_date,              
          address:_place.address,        
          city:_place.city,
          createdAt:DateTime.now().millisecondsSinceEpoch.toString(),
          );
          _postProperty = property;
        } else {
             print(' i am editting !!!!!!!!!!!!!!!!!!!!!!11');
            if(title!= null) _postProperty.title = title;
            if(phone!= null) _postProperty.phone = phone;
            if(price!= null) _postProperty.price = price;
            if(message!= null) _postProperty.message = message;
            if(messenger!= null) _postProperty.messenger = messenger;
            if(_rentType!= 'Single') _postProperty.rentType = _rentType;
            if(_date!= null) _postProperty.date = _date;
              
            if(_place != null) {
              _postProperty.latitude  = _place.latitude;
              _postProperty.longitude = _place.longitude;
              _postProperty.city = _place.city;
              _postProperty.address = _place.address;
            }
        }

        var result = await _firestoreService.postHouseIntoFirebase(_postProperty);
        _userDataMap.clear();
         print(' i have return with result => $result');
        
        // var result=['aaaaa', 'aaaaa'];
          
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
     

       } catch (e) {
          print('i am error ===============================>${e.toString()}');
       }
        _navigationService.navigateTo(PropertyManageViewRoute);      
  }
  
  Place _place;
  // List<Place> _items = [];
  // List<Place> get items {
  //   return [..._items];
  // }

  // Place findById(String id) {
  //   return _items.firstWhere((place) => place.id == id);
  // }

  Future<void> addPlace(
    Place pickedLocation,
  ) async {

    final address = await _googleMapService.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);   
      final updatedLocation = Place(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: address,
        city: address.split(', ')[1]);
      _place = updatedLocation;
    //  print(_place.latitude);
    //   print(_place.longitude);
    //  print(_place.address);
    //   print(_place.city);
    //_items.add(updatedLocation); 
    notifyListeners();
    return address;
  }
  

  //PostProperty get getPostPropertyData => _postProperty;

  void getPostProperty(PostProperty postProperty) {
         _postProperty = postProperty;
         for(var i =0; i < postProperty.imageUrl.length; i++ ) {
           _userDataMap['image$i'] = postProperty.imageUrl[i];
           _images[i] =postProperty.imageUrl[i];
         }
          notifyListeners();
         print(_userDataMap['image0']);
         print(_postProperty.latitude);
         print(_postProperty.documentId);
        // _images = _postProperty.imageUrl;
  }

  List<String> _images = List<String>.generate(8,(i) => '');
  List<String> get images =>_images;

  //String uuid = Uuid().v1(); 
  Future uploadImage(File image, int index) async {
    setBusy(true);
    // String imageUrl;
     _cloudStorageService.imageDatadelete(_images[index]);
     if(image != null) {
      _userDataMap['image$index'] =image;
    
       //String uid = postProperty.uuid == null? uuid : _postProperty.uuid;
      //  imageUrl =  await _firestoreService.uploadImageData(image, index, _authenticationService.currentUser); 
      // _images[index] =(imageUrl);     
       // print('i added it !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! {$imageUrl}');
        notifyListeners();
     }
     setBusy(false); 
  }

   Future<File> cropImage () async {
     File image = await getImage();

     return image;
   }
      

    Future<bool> remove(int index) async {
      bool ok = false;
      var dialogResponse = await _dialogService.showConfirmationDialog(
          title: 'Remove Image',
          description: 'would you like to Remove this image ?',
          confirmationTitle: 'OK',
          cancelTitle: 'CANCEL'        
        );
    
    if(dialogResponse.confirmed) {
        ok = true;
         await _cloudStorageService.imageDatadelete(_images[index]);
         if(_postProperty != null)
      //   await _firestoreService.imageDataDelete(_images[index], _postProperty.documentId);
       // print( 'i will remove !!!!!!!!!!!!!!!!!= ====> ${_images[index]}');
         _userDataMap.remove('image$index');
         _images[index] ='';
           print('${_userDataMap.length}');
         print('${_images.length}');
       // print('I AM having data =============>!!!!!${_images.length}');
       // print(_images);
        notifyListeners();
    }   
     return ok;
  }
  

}