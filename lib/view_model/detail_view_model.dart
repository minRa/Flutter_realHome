import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/services/googleMap_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';
import 'package:realhome/services/googleAds_service.dart';


class DetailViewModel extends BaseModel {
     final NavigationService _navigationService = 
   locator<NavigationService>();
 
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  String _preview;
  String get preview => _preview;
   final FirestoreService _firestoreService = locator<FirestoreService>();
    final DialogService _dialogService = locator<DialogService>();

final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();

  User _owner;
  User get owner =>_owner;

 Future<void> getStartCurrentDetail(PostProperty postProperty) async {

      var users =    await _firestoreService.getUserList();
      await _googleAdsService.disposeGoogleAds();

    //   await  _firestoreService.getUserList().then((data) {
    //     _owner = data.singleWhere((id) => id.id == postProperty.id);
    // });
     _owner = await users.singleWhere((id) => id.id == postProperty.id);
   // _owner = poster.profileUrl;
       notifyListeners();
    await  googleMapPreview(postProperty);
 }


         void navigateToPostOwnerInfoView(User  user) {
   _navigationService.navigateTo(PostOwnerInfoViewRoute, arguments: user);
  }



  

   Future googleMapPreview(PostProperty postProperty) async  {  
    _preview = GoogleMapServices.generateLocationPreviewImage(
      latitude: postProperty.latitude,
      longitude: postProperty.longitude  
    );
  }



  User _user ;

   getUser() {
    _user =   _authenticationService.currentUser;
    return  _user;
  }
  
  void commmentsDelete(String docId, String userId, String date) async {
       getUser();
      if(_user != null && _user.id == userId) {

        var dialogResponse = await _dialogService.showConfirmationDialog(
                title: 'Delete your comments',
                description: 'would you like to delete this comments  ?',
                confirmationTitle: 'OK',
                cancelTitle: 'CANCEL'        
              );
        
        if(dialogResponse.confirmed) {   
             await _firestoreService.commentDelete(docId, date);
        } 
      }
  }
}