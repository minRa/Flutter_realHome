//import 'package:firebase_admob/firebase_admob.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:realhome/view_model/setting_view_model.dart';
//const adUnitId = 'ca-app-pub-7333672372977808/7613866872';
// import 'package:datingappmain/commons/constData.dart';
// import 'package:datingappmain/commons/userProfile.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/services/googleAds_service.dart';


class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Settings();
}

class _Settings extends State<Settings> {
  double _animatedHeight = 0;
  final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();
 //bool status = true;
 @override
  void initState() {
      if(!_googleAdsService.onBanner) {
        _googleAdsService.bottomBanner();
      }
    super.initState();
  }


   void googleAdOff(bool onOff) {
    if(!onOff) {
     _googleAdsService.disposeGoogleAds();
    }
  } 

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SettingsViewModel>.withConsumer(
      viewModel: SettingsViewModel(), 
      onModelReady: (model) => model.currentUser,
      builder: (context, model, child) =>  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,10,0,0),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: model.currentUser.profileUrl !=null?
                   Image.network(model.currentUser.profileUrl,
                    height: 100,
                    fit: BoxFit.cover,
                     loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null ? 
                                loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    width: 70) :
                    Image.asset('assets/images/avata.png',
                    height: 80,
                    fit: BoxFit.cover,
                    width: 60,
                    
                    ),
              ),
              title: Text('${model.currentUser.fullName } (${model.currentUser.email})',
              textAlign: TextAlign.center,
              style: GoogleFonts.mcLaren(fontSize: 20),) //TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => UserProfile(myProfileName,'Male','I legitimately like romantic comedies. I grew up with three sisters and too man females and aunts. I was outnumbered. Plus, they have great dialogue and plot structure. ',myProfileImage,true)),
              //   );
              // },
              // trailing: IconButton(
              //   icon: Icon(Icons.edit),
              //   onPressed: model.userProfileImageChange,
              // ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,10,0,0),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Icon(Icons.settings, size: 34,color: Colors.greenAccent[900],),
              ),
              title: Text('Setting',
              style: GoogleFonts.mcLaren(fontSize: 20),),    //TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              onTap: () {
                setState(() {
                  _animatedHeight!=0.0?_animatedHeight=0.0:_animatedHeight=100.0;
                });
              },
            ),
          ),
          new AnimatedContainer(duration: const Duration(milliseconds: 120),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28.0,10,10,10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  //Icon(Icons.wc,size: 26,),
                  Text("Google AD",
                  style:GoogleFonts.mcLaren(fontWeight: FontWeight.bold,fontSize: 18),), 
                   CustomSwitch(
                    activeColor: Colors.blueGrey,
                    value: _googleAdsService.googleAdOnOff,
                    onChanged: (value)
                     {
                       print("VALUE : $value");
                       setState(() {
                         _googleAdsService.updateGoogleAdOnOff(value);
                         googleAdOff(value);
                       // status = value;
                      });
                      // _googleAdsService.updateGoogleAdOnOff(value);
                      // googleAdOff(value);
                      // setState(() {
                      //   status = value;
                      //   googleAdOff(value);
                      // });
                    },
                  ),
                  // SizedBox(height: 12.0,),
                  // Text('Value : $status', style: TextStyle(
                  //   color: Colors.black,
                  //   fontSize: 20.0
                  // ),)
                      // TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  // Checkbox(
                  // value: _manValue,
                  // onChanged: (bool newValue) {
                  //     setState(() {
                  //       _manValue = newValue;
                  //     });
                  //   },
                  // ),
                  // GestureDetector(
                  //     child: Text("Man",style: TextStyle(fontSize: 18)),
                  //     onTap: () {
                  //       setState(() {
                  //         _manValue = !_manValue;
                  //       });
                  //     },),
                  // Padding(
                  //   padding: const EdgeInsets.only(left:12.0),
                  //   child: Checkbox(
                  //     value: _womanValue,
                  //     onChanged: (bool newValue) {
                  //       setState(() {
                  //         _womanValue = newValue;
                  //       });
                  //     },
                  //   ),
                  // ),
                  // GestureDetector(child: Text("Woman",style: TextStyle(fontSize: 18)),
                  //   onTap: () {
                  //     setState(() {
                  //       _womanValue = !_womanValue;
                  //     });
                  //   },),
                ],
              ),
            ),
            height: _animatedHeight,
            width: 100.0,
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,10,0,0),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Icon(Icons.lock_open, size: 40,color: Colors.greenAccent[900]),
              ),
              title: Text('Sign Out',
              style: GoogleFonts.mcLaren(fontSize: 20),), //TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              onTap: () {
                _showDialog(model.logout);
              },
            ),
          ),
        ],
      ),)
    );
  }

  void _showDialog(Function logout) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Do you want to log out?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No", style: TextStyle(color: Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed:() {
                Navigator.of(context).pop();  
                logout();   
            
              }
            ),
          ],
        );
      },
    );
  }
}