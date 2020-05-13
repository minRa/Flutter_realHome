
import 'dart:io';
import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';
import 'package:realhome/services/googleAds_service.dart';



class PropertyManageViewModel extends BaseModel {

final AuthenticationService _authenticationService = locator<AuthenticationService>();
final FirestoreService _firestoreService = locator<FirestoreService>();
final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();
final NavigationService _navigationService = 
   locator<NavigationService>();



final DialogService _dialogService = locator<DialogService>();
Future <void> nonUserAddPost() async {
   var dialogResponse = await _dialogService.showConfirmationDialog(
          title: ' Rent House - login required',
          description: 'Would you like to login?',
          confirmationTitle: 'OK',
          cancelTitle: 'CANCEL'        
        );
    
    if(dialogResponse.confirmed) {   
      navigateToLogin();
      
    }
}
  
  bool data = false;
  
  User get currentUser => _authenticationService.currentUser;
  
  List<PostProperty> _userPostProperty;
  List<PostProperty> get userPostProperty => _userPostProperty;
  bool finish;

     Future<void> currentUserPostPropertyList() async {

        _googleAdsService.bottomBanner();
      // setBusy(true); 
       finish = false;      
        notifyListeners();
       try {
           _userPostProperty =
            await _firestoreService.getUserPropertyListFromFirebase(
              _authenticationService.currentUser);
          notifyListeners();

       } catch(e) {
          print(e.toString());
       } 

       finish= true;     
      notifyListeners();  
      // setBusy(false);  
  }


    navigateToDetailView(int index) {
    _navigationService.navigateTo(DetailViewRoute, arguments: _userPostProperty[index]);
    }

     navigateToPostHouseView2(int index) {
    _navigationService.navigateTo(PostHouseViewRoute, arguments: _userPostProperty[index]);
  }

    Future userProfileImageChange(String type) async {
     print(type);
     setBusy(true);
     File image = await getImage();
     if(image != null) {
       await _firestoreService.updateUserImage(currentUser, image, type);
       await _authenticationService.isUserLoggedIn();
       currentUser;
     }
     notifyListeners();
     setBusy(false);  

    }
     


     Future deleteUserPostProperty(int index) async {
       finish = false;
       notifyListeners();
      // var dialogResponse = await _dialogService.showConfirmationDialog(
      //           title: 'Delete Rent House',
      //           description: 'would you like to delete this house  ?',
      //           confirmationTitle: 'OK',
      //           cancelTitle: 'CANCEL'        
      //         );
        
      //   if(dialogResponse.confirmed) {
        //  setBusy(true);   
        
            var result = await _firestoreService.deleteUserPostPropertyToFirebaseDB(currentUser, _userPostProperty[index]);
             await  currentUserPostPropertyList();
             //await currentUserPostPropertyList();
            if(result!=null) {
              await _dialogService.showDialog(
              title: result[0],
              description: result[1],
            );}
          finish = true;
          notifyListeners();

      //    setBusy(false);  
        //} 
    }
 
}