import 'package:firebase_admob/firebase_admob.dart';

class GoogleAdsService {


static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices:["A875A3F6C822A0A04C2D99778C1381C3"]// <String>[], // Android emulators are considered test devices
  );


  
  BannerAd _bannerAd;
  BannerAd get bannserAd => _bannerAd;

  InterstitialAd  _interstitialAd;
  InterstitialAd get interstitialAd =>  _interstitialAd;

  BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-7333672372977808/8753848294',
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  InterstitialAd myInterstitialAd = InterstitialAd(
    adUnitId: 'ca-app-pub-7333672372977808/6127684957',
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );


 Future <void> initgoogleAds () async {
     await FirebaseAdMob.instance.initialize(
        appId: 'ca-app-pub-7333672372977808~8123239007'
    );

    _interstitialAd =  myInterstitialAd..load()..show(
      anchorType: AnchorType.bottom,
      anchorOffset: 0.0,
      horizontalCenterOffset: 0.0,);

    _bannerAd = myBanner..load()..show(
      //horizontalCenterOffset: 0.0,
      anchorType: AnchorType.bottom);
 }


    void disposeGoogleAds () {
    _bannerAd.dispose();
     myInterstitialAd.dispose();
  }

 }









