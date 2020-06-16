
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/ui/widgets/list_view_card.dart';
import 'package:realhome/ui/widgets/user_profile.dart';
import 'package:realhome/view_model/property_manage_view_model.dart';



class PropertyManageView extends StatefulWidget {

  @override
  _PropertyManageViewState createState() => _PropertyManageViewState();
}

class _PropertyManageViewState extends State<PropertyManageView> {
  
  final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();
  @override
  void initState() {
   if(!_googleAdsService.onBanner) {
    _googleAdsService.bottomBanner();
    }
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
      Size screenSize = MediaQuery.of(context).size/ 1;
    return ViewModelProvider<PropertyManageViewModel>.withConsumer(
      viewModel: PropertyManageViewModel(),    
      onModelReady: (model) => model.currentUserPostPropertyList(), 
      builder: (context, model, child) =>
       SafeArea(
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
            body:
            model.currentUser != null ?
            model.finish ?
            model.userPostProperty == null
            || model.userPostProperty.length == 0  ?
            Column(
              children: <Widget>[
                Expanded(
                flex: 10,
                child: Container(
                  child: UserProfilePage(
                  onAuth: true,
                  navigate:model.navigateToStartPageView,
                  onLoading: model.onLoading,
                  user: model.currentUser,
                  editImage:()=> model.userProfileImageChange('profile'),
                  editBackground:()=> model.userProfileImageChange('abc'),
                  ),
                ),),
                Expanded(
                  flex: 9,
                  child: Container(
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: Image.asset('assets/images/property.png',
                        fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                         bottom: screenSize.height > 700 ?  130 :
                         screenSize.height > 600 ? 100 : 80,
                         left:screenSize.height > 700 ?  130 :110,
                        child: Text('post your rent house',
                        style: GoogleFonts.mcLaren(),
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ) :
              Column(
              children: <Widget>[  
                  Expanded(
                    flex: 7,
                    child: 
                    UserProfilePage(
                      onAuth:model.currentUser.id != model.userPostProperty[0].id ? false : true ,
                      navigate: model.navigateToStartPageView,
                      user: model.currentUser,
                      onLoading: model.onLoading,
                      editImage:()=> model.userProfileImageChange('profile'),
                      editBackground:()=> model.userProfileImageChange('abc'),
                      )),
                    Expanded(
                    flex: _googleAdsService.onBanner ?
                    screenSize.height > 700 ? 7
                    : screenSize.height > 600 ? 6 : 5 : 7,
                    child: model.userPostProperty.length > 0?
                      ListView.builder(
                      itemCount: model.userPostProperty.length,
                      itemBuilder: (context, index) =>
                          GestureDetector(
                          onTap: ()=> model.navigateToDetailView(index),
                          child:ListViewCard (
                            id: model.userPostProperty[index].id,
                            onAuth: model.currentUser.id != model.userPostProperty[0].id ? false : true,
                            userProperty: model.userPostProperty[index], 
                            edit:()=> model.navigateToPostHouseView2(index),  
                            delete: () => model.deleteUserPostProperty(index),                 
                              ),
                            ),
                          ) :
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Image.asset('assets/images/property.png',
                                fit: BoxFit.cover,
                                ),
                                Text('post your rent house',
                                style: GoogleFonts.mcLaren(),
                                )
                              ],
                            ),
                          )
                        ),
                        _googleAdsService.onBanner?
                          Expanded(
                        flex: 1,
                        child: Container(),)
                        : Container(),               
                    ],) 
                
                  : Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                      Theme.of(context).primaryColor),
                            ),)
                   : SingleChildScrollView(
                     child: Column(
                       children: <Widget>[
                         Stack(
                          children: <Widget>[
                            Container(
                            width: double.infinity,
                           child: Image.asset('assets/images/cover.jpg',
                            fit: BoxFit.cover,
                            scale: 1.5,
                            ),
                         ),
                            Positioned(
                             top: screenSize.height > 700 ?  120 : 100,
                             left: screenSize.width <= 320 ? null :
                              screenSize.width <= 375 ? 30 :
                              screenSize.width <= 414 ? 50 : 80,
                            child: 
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(),
                                Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                image:DecorationImage(
                                image:AssetImage('assets/images/nonuser.png') ,
                                fit: BoxFit.cover,),
                                  borderRadius: BorderRadius.circular(100.0),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 10.0,
                                      ),
                                    ),
                                ),
                               SizedBox(height: 5,),
                                Text(' GUEST',
                                style:GoogleFonts.mcLaren(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.black
                              ),
                              textAlign: TextAlign.center,
                             ),
                              SizedBox(height: 20,),
                              Text(' Post Property Management page ',
                              style: GoogleFonts.mcLaren(fontSize: 18)),
                              Text('only for login user',
                               style: GoogleFonts.mcLaren(fontSize: 18)),
                              ],
                            ),
                         ),],
                         ),
                       ],
                     ),
                  ), 
                floatingActionButton: 
                 model.currentUser != null ?
                 Container(
                  padding: _googleAdsService.onBanner ?
                  screenSize.height > 700 ?
                   EdgeInsets.symmetric(vertical: 60)
                    :screenSize.height > 600 ?
                     EdgeInsets.symmetric(vertical: 40)
                    :EdgeInsets.symmetric(vertical: 10)
                    :EdgeInsets.symmetric(vertical: 0) ,
                     child: FloatingActionButton(
                     child: Icon(Icons.border_color),
                        onPressed: () => model.navigateToPostHouseView()
                  )
                ) : Container() , 
              ),
            ),
         )    
       );  
    }
}
