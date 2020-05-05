
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
import 'package:realhome/services/googleAds_service.dart';
const adUnitId = 'ca-app-pub-7333672372977808/3709801953';



class PostHouseViewModel extends BaseModel {

  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = 
   locator<NavigationService>();
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  final GoogleMapServices _googleMapServices = locator<GoogleMapServices>();
     final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();
  
    
    String _date;
     updateDate(String date) {
       _date = date;
    }

    String _rentType ='Single';
     updateRentType(String rentType) {
       _rentType = rentType;
    }

    int _room = 1;
    updateRoom(int room) {
      _room = room;
     print(_room);
    }
   
      int _carpark = 0;
    updateCarpark(int carpark) {
      _carpark = carpark;
          print(_carpark);
     
    }

       int _toilet = 1;
    updateToilet(int toilet) {
      _toilet = toilet;
          print(_toilet);
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
          toilet: _toilet,
          room: _room,
          carpark: _carpark,
          phone: phone,  
          title:title,
          price: price,
          message: message,
          messenger: messenger,
         latitude: _placeDetail.lat, 
         longitude:_placeDetail.lng,
          rentType:_rentType,
          date:_date,              
         address:_placeDetail.formattedAddress,        
         city:_placeDetail.city,
          createdAt:DateTime.now().millisecondsSinceEpoch.toString(),
          );
          _postProperty = property;
        } else {
            if(_toilet!=1) _postProperty.toilet = _toilet;
            if(_room != 1) _postProperty.room = _room;
            if(_carpark!=0) _postProperty.carpark=_carpark;
            if(title!= null) _postProperty.title = title;
            if(phone!= null) _postProperty.phone = phone;
            if(price!= null) _postProperty.price = price;
            if(message!= null) _postProperty.message = message;
            if(messenger!= null) _postProperty.messenger = messenger;
            if(_rentType!= 'Single') _postProperty.rentType = _rentType;
            if(_date!= null) _postProperty.date = _date;
              
            if(_placeDetail != null) {
              _postProperty.latitude  = _placeDetail.lat;
              _postProperty.longitude = _placeDetail.lng;
              _postProperty.city = _placeDetail.city;
             _postProperty.address = _placeDetail.formattedAddress;
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
  
  PlaceDetail _placeDetail;
 // PlaceDetail get placeDetail => _placeDetail;
   updatePlaceDetail(PlaceDetail place) {
     _placeDetail = place;
     //notifyListeners();
     print(_placeDetail);
   }


  // Place findById(String id) {
  //   return _items.firstWhere((place) => place.id == id);
  // }


  Future<void> addPlace(double lat, double lng) async {
    final address = await _googleMapServices.getPlaceAddress(lat, lng);   
      final updatedLocation = PlaceDetail(
        lat: lat,
        lng: lng,
        formattedAddress: address,
        city: address.split(', ')[1]);
     _placeDetail = updatedLocation;
    print(_placeDetail);
    return address;
  }
  

  PostProperty get getPostPropertyData => _postProperty;

    void getGoogleAdService() async {
      await _googleAdsService.bottomBanner(adUnitId);
    }

  void getPostProperty(PostProperty postProperty) async {
      
        await _googleAdsService.bottomBanner(adUnitId);

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
    if(_images[index] != "") {
     _cloudStorageService.imageDatadelete(_images[index]);
    }
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