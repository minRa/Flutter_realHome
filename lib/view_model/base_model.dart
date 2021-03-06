import 'package:realhome/services/remote_config_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
//import 'package:realhome/models/postProperty.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/authentication_service.dart';
//import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/services/navigation_service.dart';


class BaseModel extends ChangeNotifier {


   final NavigationService _navigationService = 
   locator<NavigationService>();

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final GoogleAdsService _googleAdsService =
      locator<GoogleAdsService>();
   
  final RemoteConfigService _remoteConfigService = 
  locator<RemoteConfigService>();

  BannerAd get bannserAd => _googleAdsService.bannserAd;
  InterstitialAd get interstitialAd => _googleAdsService.interstitialAd;
  User get currentUser => _authenticationService.currentUser;
  bool get showMainBanner => _remoteConfigService.showMainBanner;

   

  // Since it'll most likely be used in almost every view we expose it here
  //bool get showMainBanner => _remoteConfigService.showMainBanner;
  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  


   Future initialGoogleAds () => _googleAdsService.initgoogleAds();

 

        void navigateToBigImageView(List<dynamic> items) {
   _navigationService.navigateTo(BigImageViewRoute, arguments: items);
  }

      void navigateToLogin() {
    _navigationService.navigateTo(LoginViewRoute);
  }

      void  navigateToPostHouseView() {
    _navigationService.navigateTo(PostHouseViewRoute);
  }

        void  navigateToStartPageView(int index) {
    _navigationService.navigateTo(StartPageRoute, arguments: index);
  }

      void navigateToSignUp() {
    _navigationService.navigateTo(SignUpViewRoute);
  }
        void navigateToPropertyManageView() {
    _navigationService.navigateTo(PropertyManageViewRoute);
  }
        void navigateToChatListView() {
    _navigationService.navigateTo(ChatRoomListViewRoute);
  }


    Future getImage() async {
    // Get image from gallery.
     File image = await ImagePicker.pickImage(
       source: ImageSource.gallery,
        maxHeight: 400,
       );

      if(image != null) {
         return _cropImage(image);
      }
      return;    
  }

  Future<File> _cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue[800],
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
            title: 'Cropper',
        ));
       
    return croppedFile;
  }
}