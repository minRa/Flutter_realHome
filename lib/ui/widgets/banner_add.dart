import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class BannerADD extends StatefulWidget {
  @override
  _BannerADDState createState() => _BannerADDState();
}

class _BannerADDState extends State<BannerADD> {
 static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

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

  BannerAd _bannerAd;

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(
        appId: 'ca-app-pub-7333672372977808~8123239007'
    );
    _bannerAd = myBanner..load()..show(anchorType: AnchorType.bottom);
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    myInterstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Show InterstitialAd',
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
              ),
              onPressed: (){
                myInterstitialAd
                  ..load()
                  ..show(
                    anchorType: AnchorType.bottom,
                    anchorOffset: 0.0,
                    horizontalCenterOffset: 0.0,
                  );
              },
            ),
          ],
        ),
      );
  }
}



