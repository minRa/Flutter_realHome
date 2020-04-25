import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/services/navigation_service.dart';


class BaseModel extends ChangeNotifier {
   final DialogService _dialogService = locator<DialogService>();

   final NavigationService _navigationService = 
   locator<NavigationService>();

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final GoogleAdsService _googleAdsService =
      locator<GoogleAdsService>();
   

  BannerAd get bannserAd => _googleAdsService.bannserAd;
  InterstitialAd get interstitialAd => _googleAdsService.interstitialAd;
  User get currentUser => _authenticationService.currentUser;

  // Since it'll most likely be used in almost every view we expose it here
  //bool get showMainBanner => _remoteConfigService.showMainBanner;
  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

   Future initialGoogleAds () => _googleAdsService.initgoogleAds();

  Future <void> logout () async {
   var dialogResponse = await _dialogService.showConfirmationDialog(
          title: 'Log-Out',
          description: 'would you like to logout now ?',
          confirmationTitle: 'OK',
          cancelTitle: 'CANCEL'        
        );
    
    if(dialogResponse.confirmed) {
      await _authenticationService.logOut();
      notifyListeners();
      navigateToHouseOverView();
    } 
  } 

        void navigateToBigImageView(List<dynamic> items, int index) {
   _navigationService.navigateTo(BigImageViewRoute, arguments: [items, index]);
  }
      void navigateToHouseOverView() {
   _navigationService.navigateTo(HouseOverviewRoute);
  }
      void navigateToLogin() {
    _navigationService.navigateTo(LoginViewRoute);
  }

        void navigateToPostHouseView() {
    _navigationService.navigateTo(PostHouseViewRoute);
  }
      void navigateToSignUp() {
    _navigationService.navigateTo(SignUpViewRoute);
  }
        void navigateToPropertyManageView() {
    _navigationService.navigateTo(PropertyManageViewRoute);
  }
        void navigateToMembershipView() {
    _navigationService.navigateTo(MembershipViewRoute);
  }

}