
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

class PropertyManageViewModel extends BaseModel {

AuthenticationService _authenticationService = locator<AuthenticationService>();
FirestoreService _firestoreService = locator<FirestoreService>();
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


     Future<void> currentUserPostPropertyList() async {
       setBusy(true);       
       try {
           _userPostProperty =
            await _firestoreService.getUserPropertyListFromFirebase(
              _authenticationService.currentUser);
          notifyListeners();

       } catch(e) {
          print(e.toString());
       }        
       setBusy(false);  
  }


    navigateToDetailView(int index) {
    _navigationService.navigateTo(DetailViewRoute, arguments: _userPostProperty[index]);
    }

     navigateToPostHouseView2(int index) {
    _navigationService.navigateTo(PostHouseViewRoute, arguments: _userPostProperty[index]);
  }


    Future userProfileImageChange() async {
     setBusy(true);
     File image = await getImage();
     if(image != null) {
       await _firestoreService.updateUserImage(currentUser, image);
       await _firestoreService.getUser(currentUser.id);
       currentUser;
     }
     notifyListeners();
     setBusy(false);  

    }

     Future deleteUserPostProperty(int index) async {
      var dialogResponse = await _dialogService.showConfirmationDialog(
                title: 'Delete Rent House',
                description: 'would you like to delete this house  ?',
                confirmationTitle: 'OK',
                cancelTitle: 'CANCEL'        
              );
        
        if(dialogResponse.confirmed) {
          setBusy(true);   
            var result = await _firestoreService.deleteUserPostPropertyToFirebaseDB(currentUser, _userPostProperty[index]);
             await  currentUserPostPropertyList();
             //await currentUserPostPropertyList();
            if(result!=null) {
              await _dialogService.showDialog(
              title: result[0],
              description: result[1],
        );}
          notifyListeners();
          setBusy(false);  
        } 
    }
 
}