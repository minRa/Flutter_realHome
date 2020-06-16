import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/dataCenter.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';
import 'package:realhome/services/remote_config_service.dart';

class InitialViewModel extends BaseModel {

   final AuthenticationService _authenticationService =
        locator<AuthenticationService>();
    final NavigationService _navigationService = locator<NavigationService>();
    final DataCenter _dataCenter = locator<DataCenter>();


   final RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();

  Future handleStartUpLogic() async {
    await _remoteConfigService.initialise();
    
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    
     print(hasLoggedInUser);
    if (hasLoggedInUser) {

       _dataCenter.oldUserData = _authenticationService.currentUser;

      _navigationService.navigateTo(StartPageRoute);
    } else {
      _navigationService.navigateTo(LoginViewRoute);
    }
   }
}