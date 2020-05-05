import 'package:firebase_admob/firebase_admob.dart';


class GoogleAdsService {
static const appId ='ca-app-pub-7333672372977808~8123239007';

static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices:["A875A3F6C822A0A04C2D99778C1381C3"]// <String>[], // Android emulators are considered test devices
  );

  bool _onBanner = false;
  
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


  //const nativeAdUnitID = "ca-app-pub-7333672372977808/9632212477";

  


  Future<void> bottomBanner(String adUnitId) async {
       
      if(_onBanner) return; 
      await FirebaseAdMob.instance.initialize(
      appId: appId);

       _bannerAd = BannerAd(
         adUnitId: adUnitId,
         size: AdSize.smartBanner,
        // targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
        },
     ); //..load()..show();

      _bannerAd..load()..show();
      
      _onBanner = true;

 }




 Future <void> initgoogleAds () async {
     await FirebaseAdMob.instance.initialize(
        appId: appId
    );

    // _interstitialAd =  myInterstitialAd..load()..show(
    //   anchorType: AnchorType.bottom,
    //   anchorOffset: 0.0,
    //   horizontalCenterOffset: 0.0,);

    //_bannerAd = myBanner..load()..show(
      //horizontalCenterOffset: 0.0,
     // anchorType: AnchorType.bottom);
 }


    Future<void> disposeGoogleAds() async {
     await _bannerAd?.dispose();
      _bannerAd =null;
      _onBanner = false;
     //myInterstitialAd.dispose();
  }

 }









