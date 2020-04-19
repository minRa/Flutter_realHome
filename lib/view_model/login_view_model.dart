import 'package:flutter/material.dart';
import 'package:realhome/constants/route_names.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';

import '../locator.dart';
import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
 // final AnalyticsService _analyticsService = locator<AnalyticsService>();

  Future login({
    @required String email,
    @required String password,
  }) async {
    setBusy(true);

    var result = await _authenticationService.loginWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);
    print(result);
    if (result is bool) {
      if (result) {
       // await _analyticsService.logLogin();
        _navigationService.navigateTo(HouseOverviewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: result,
      );
    }
  }

  Future<void> nonUserEnter () async {

    var dialogResponse = await _dialogService.showConfirmationDialog(
          title: 'Gust',
          description: 'Guest is only allowed to check rent house list',
          confirmationTitle: 'OK',
          cancelTitle: 'CANCEL'        
        );

     if(dialogResponse.confirmed) {
        await _authenticationService.logOut();
            notifyListeners();
            navigateToHouseOverView();                   
       }     
    } 
}
