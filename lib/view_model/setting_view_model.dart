//import 'dart:io';

import 'package:realhome/locator.dart';
//import 'package:realhome/models/user.dart';
import 'package:realhome/services/authentication_service.dart';
//import 'package:realhome/services/firestore_service.dart';
//import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/view_model/base_model.dart';


class SettingsViewModel extends BaseModel {

   //final DialogService _dialogService = locator<DialogService>();
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  //final FirestoreService _firestoreService = locator<FirestoreService>();

  
  

   
  //  User _user;
  //  User get user => _user;

  //  void getCurrentUser() {
  //      _user = _authenticationService.currentUser;
  //  }

    // User get currentUser => _authenticationService.currentUser;

    // Future userProfileImageChange() async {
    //  setBusy(true);
    //  File image = await getImage();
    //  if(image != null) {
    //    await _firestoreService.updateUserImage(currentUser, image);
    //    await _authenticationService.isUserLoggedIn();
    //    currentUser;
    //  }
    //  notifyListeners();
    //  setBusy(false);  

    // }

 Future <void> logout() async {
      await _authenticationService.logOut();
    //  navigateToStartPageView();
         navigateToLogin();
    } 
   

}