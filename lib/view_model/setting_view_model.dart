

import 'package:realhome/locator.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/view_model/base_model.dart';


class SettingsViewModel extends BaseModel {
final AuthenticationService _authenticationService = locator<AuthenticationService>();

 Future <void> logout() async {
      await _authenticationService.logOut();
    //  navigateToStartPageView();
         navigateToLogin();
    } 

}