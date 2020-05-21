import 'package:flutter/material.dart';
import 'package:realhome/constants/route_names.dart';
import 'package:realhome/services/AnalyticsService.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../locator.dart';
import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  Future login({
    @required String email,
    @required String password,
    @required bool rememberMe
  }) async {
      
    _googleAdsService.disposeGoogleAds();
     SharedPreferences prefs = await  SharedPreferences.getInstance();
    setBusy(true);
    if(rememberMe) {
      
        prefs.setString('email',email );
        prefs.setString('password', password);
        prefs.setBool('rememberMe', rememberMe );
     
        print(prefs.getString('email'));
        print(prefs.getString('password'));
        print(prefs.getBool('rememberMe'));
      
    } else {
      prefs.setBool('rememberMe', rememberMe );
      // prefs.remove('rememberMe');
       prefs.remove('email');
       prefs.remove('password');  
    }
    
    await _authenticationService.logOut();
    
    var result = await _authenticationService.loginWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);
    print(result);
    loginlogg(result);
    
  }

    Future loginWithGoogle () async {
          setBusy(true);
          var result =  await _authenticationService.googleSignUp();
          setBusy(false);
          loginlogg(result);

    }

    Future loginWithFacebook () async {
        setBusy(true);
        var result =   await _authenticationService.signUpWithFacebook();
        setBusy(false);
        loginlogg(result);

  }

  Future<void> loginlogg (var result) async {   
    if (result is bool) {
      if (result) {
         await _analyticsService.logLogin();
        _navigationService.navigateTo(StartPageRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else if(result == 'Given String is empty or null' ) {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: 'you didn\'t enter Email or password',
      );
    }else if(result =='The password is invalid or the user does not have a password.') {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: 'Login credentials do not match. a user doesn\'t exist or please enter valid Email & password',
      );
    } else if(result == null) {
       await _dialogService.showDialog(
        title: 'Login Failure',
        description: 'User not found...',
      );
    } else {
       await _dialogService.showDialog(
        title: 'Login Failure',
        description: result,
      );
    }

  //  print(result);
  }




  Future<void> nonUserEnter () async {
        await _authenticationService.logOut();
            navigateToStartPageView(0);                     
    } 
}
