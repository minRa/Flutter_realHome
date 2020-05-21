

import 'package:realhome/locator.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/view_model/base_model.dart';


class SettingsViewModel extends BaseModel {
final AuthenticationService _authenticationService = locator<AuthenticationService>();
final FirestoreService _firestoreService = locator<FirestoreService>();
final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();

 Future <void> logout() async {
      await _firestoreService.deleteMessagePushToken(_authenticationService.currentUser.id);
      await _authenticationService.logOut();
      if(_googleAdsService.onBanner) {
        await  _googleAdsService.disposeGoogleAds();
      }
         navigateToLogin();
    } 

}