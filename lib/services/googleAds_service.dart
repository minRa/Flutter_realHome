import 'package:firebase_admob/firebase_admob.dart';
const appId ='ca-app-pub-7333672372977808~8123239007';

class GoogleAdsService {

static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices:["A875A3F6C822A0A04C2D99778C1381C3"]// <String>[], // Android emulators are considered test devices
  );

  bool _onBanner = false;
  bool get onBanner => _onBanner;
  
  BannerAd _bannerAd;
  BannerAd get bannserAd => _bannerAd;

  InterstitialAd  _interstitialAd;
  InterstitialAd get interstitialAd =>  _interstitialAd;
  
  bool _googleAdOnOff = true;
  bool get googleAdOnOff => _googleAdOnOff;

   updateGoogleAdOnOff(bool onOff) {
       _googleAdOnOff = onOff;
   }

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

  bool _ban = false;
  bool get ban =>_ban;
  googleAdBan() {
    _ban = true;
  }


  Future<void> bottomBanner() async {
           
      if(!_googleAdOnOff || _ban) {
        _ban= false;
        return;
        }
      if(_onBanner) return; 
      await FirebaseAdMob.instance.initialize(
      appId: appId);

       _bannerAd = BannerAd(
         adUnitId: 'ca-app-pub-7333672372977808/8753848294',
         size: AdSize.smartBanner,
        // targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
           if (event == MobileAdEvent.loaded) {
        }});
        

    

        _bannerAd..load().then((loaded) async {
         if(loaded &&
          _googleAdOnOff && 
          !_onBanner && 
          !_ban
          ) {
           _bannerAd.show();
           _onBanner = true;
          } else {
            await _bannerAd.dispose();
            _bannerAd = null;
          }
       });  
 }




 Future <void> initgoogleAds () async {
     await FirebaseAdMob.instance.initialize(
        appId: appId
    );
 }


  Future<void> disposeGoogleAds() async {
    if(_onBanner) {
      _onBanner = false;
      await _bannerAd?.dispose();
      _bannerAd = null;
    }
  }
 }









