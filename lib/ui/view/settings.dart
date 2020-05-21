//import 'package:firebase_admob/firebase_admob.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:realhome/view_model/setting_view_model.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/services/googleAds_service.dart';


class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Settings();
}

class _Settings extends State<Settings> {
  double _animatedHeight = 0;
  final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();

  @override
  void initState() {
   if(!_googleAdsService.onBanner) {
     _googleAdsService.bottomBanner();
    }
    super.initState();
  }

   void googleAdOff(bool onOff) async {
    if(!onOff) {
      await _googleAdsService.disposeGoogleAds();
    }
  } 

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SettingsViewModel>.withConsumer(
      viewModel: SettingsViewModel(), 
      onModelReady: (model) => model.currentUser,
      builder: (context, model, child) =>  SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,10,0,0),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child:
                   model.currentUser != null?
                   model.currentUser.profileUrl !=null?
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
                      Image.asset('assets/images/avata2.png',
                      height: 80,
                      fit: BoxFit.cover,
                      width: 60,  
                      ) :
                       Image.asset('assets/images/avata2.png',
                      height: 80,
                      fit: BoxFit.cover,
                      width: 60,  
                      )
                      ,
                   ),
                  title: model.currentUser == null?
                  Text('Guest', style: GoogleFonts.mcLaren(fontSize: 20), textAlign: TextAlign.center, ) :
                  Text('${model.currentUser.fullName } (${model.currentUser.email})',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mcLaren(fontSize: 20),) //TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              ),
            ),
            SizedBox(height: 10,),
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
                        });
                      },
                    ),
                  ],
                ),
              ),
              height: _animatedHeight,
              width: 100.0,
            ),
             SizedBox(height: 10,),
              model.currentUser == null ?
             Padding(
              padding: const EdgeInsets.fromLTRB(0,10,0,0),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Icon(Icons.person, size: 40,color: Colors.greenAccent[900]),
                ),
                title: Text('Login',
                style: GoogleFonts.mcLaren(fontSize: 20),), 
                onTap: () => model.navigateToLogin()
              ),
            )
           :
            Padding(
              padding: const EdgeInsets.fromLTRB(0,10,0,0),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Icon(Icons.lock_open, size: 40,color: Colors.greenAccent[900]),
                ),
                title: Text('Sign Out',
                style: GoogleFonts.mcLaren(fontSize: 20),), 
                onTap: () {
                  _showDialog(model.logout);
                },
              ),
            ),
            Container(
              child: Image.asset('assets/images/settings2.png',
              fit: BoxFit.cover,
              ),
            )
          ],
        ),
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
          title: Text("Log-out ?",
          style: GoogleFonts.mcLaren(),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
             FlatButton(
              child:  Text("No", style: GoogleFonts.mcLaren(color: Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
             FlatButton(
              child:  Text("Yes",
              style: GoogleFonts.mcLaren(),
              ),
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