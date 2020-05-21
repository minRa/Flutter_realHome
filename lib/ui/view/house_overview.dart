
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/ui/widgets/creation_aware_list_item.dart';
import 'package:realhome/ui/widgets/dropdown.dart';
import 'package:realhome/ui/widgets/no_list.dart';
import 'package:realhome/ui/widgets/viewList.dart';
import 'package:realhome/view_model/House_overview_model.dart';
const  _adUnitID = "ca-app-pub-7333672372977808/9632212477";

class HouseOverview extends StatefulWidget {
  
  @override
  _HouseOverviewState createState() => _HouseOverviewState();
}

class _HouseOverviewState extends State<HouseOverview> {

  StreamSubscription _subscription;
  final _nativeAdController = NativeAdmobController();
  double _height = 0;

  final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();
  @override
  void initState() {
    if(_googleAdsService.googleAdOnOff) {
     _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    }

  if(!_googleAdsService.onBanner) {
     _googleAdsService.bottomBanner();
    }
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _nativeAdController.dispose();
    super.dispose();
  }


  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = 330;
        });
        break;

      default:
        break;
    }
  }

 

  Widget build(BuildContext context) {
    return ViewModelProvider<HouseOverviewModel>.withConsumer(
      viewModel: HouseOverviewModel(),    
       onModelReady: (model) => model.listenToPosts(), 
       builder: (context, model, child) => 
       Scaffold(
       body:
       model.onLoading ?
        Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
              Theme.of(context).primaryColor
              ),),):
       Container(
         color: Colors.white,
         child: Column(
              children: <Widget>[
              Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      DropDownBox(
                         cities: model.cities,
                          searchCondition: model.updatePostCodition,
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text('Total :',
                                style: GoogleFonts.mcLaren(),
                                ),
                                Text(' ${model.total}',
                                 style: GoogleFonts.mcLaren()
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                  //  Positioned(
                  //    child: model.showMainBanner ?
                  //        Visibility(
                  //          visible: model.show ,
                  //          child: Container(
                  //          height: 80,
                  //          width: double.infinity,
                  //          padding: const EdgeInsets.symmetric(horizontal: 10),
                  //          margin: const EdgeInsets.symmetric(vertical: 15),
                  //          decoration: BoxDecoration(
                  //              boxShadow: [
                  //                BoxShadow(
                  //                    color: Colors.black12,
                  //                    blurRadius: 4,
                  //                    offset: Offset(0, 4))
                  //              ],
                  //              color: Colors.white,
                  //              borderRadius: BorderRadius.circular(10)),
                  //          alignment: Alignment.center,
                  //          child: Text(
                  //            'Welecome to visit realHome app :)',
                  //            style: GoogleFonts.mcLaren(fontSize: 20, fontWeight: FontWeight.bold),
                  //            textAlign: TextAlign.center,
                  //            )),
                  //        ) : Container(),
                  //     )   
                     ],
                   ),
                  SizedBox(height: 10,),
                 Expanded(
                   flex: 11,
                    child: model.total ==0 ?
                     NoList():
                     ListView.builder(
                    itemCount:model.postProperty.length,
                    itemBuilder: (ctx, i) =>
                      CreationAwareListItem(
                    itemCreated: () {
                      if ( i != 0 && i % 7 == 0 )
                        model.requestMoreData();
                    },
                    child:Column(
                      children: <Widget>[
                         i%5 == 0 && i != 0? 
                         Container(
                          height: _height,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: NativeAdmob(
                          // Your ad unit id
                          adUnitID: _adUnitID,
                          controller: _nativeAdController,
                          // Don't show loading widget when in loading state
                          loading: Container(),
                          ),
                        ): Container(),
                        GestureDetector (
                        onTap:() => model.navigateToDetailView(i),
                        child: HorizontalList(model.postProperty[i]) 
                          ),
                      ],
                    )
                    )
                      ),),
                     _googleAdsService.onBanner ?
                  Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    //child: Text('google Ads area'),
                ),
              ) : Container(),                        
            ]),
          )
      //})
     ) 
   );
  }
}

 