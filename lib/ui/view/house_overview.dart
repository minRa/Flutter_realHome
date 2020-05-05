
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/ui/widgets/creation_aware_list_item.dart';
import 'package:realhome/ui/widgets/dropdown.dart';
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



  @override
  void initState() {
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
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
       model.postProperty != null ?
       Column(
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
                          Text('Total :'),
                          Text(' ${model.postProperty.length}')
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
               Expanded(
                 flex: 11,
                  child: ListView.builder(
                  itemCount:model.postProperty.length,
                  itemBuilder: (ctx, i) =>
                    CreationAwareListItem(
                  itemCreated: () {
                    if (i % 5 == 0)
                      model.requestMoreData();
                  },
                  child:Column(
                    children: <Widget>[
                       i%3 == 0 && i != 0? 
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
                Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  //child: Text('google Ads area'),
              ),
            ),                        
          ])
          :  Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
              Theme.of(context).primaryColor
              ),),)
      //})
     ) 
   );
  }
}

 //return _buildList(context, posts, model); 

//Widget _buildList(BuildContext context, List<PostProperty> posts, HouseOverviewModel  model) {
 //   return 
   
 //}
 









  //  Column(
      //    children: <Widget>[
      //      Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: <Widget>[
      //           DropDownBox(),
      //           DropDownBox(),
      //           DropDownBox(),
      //           ],),
      //           SizedBox(height: 10,),
      //         Expanded(
      //           flex: 11,
      //           child: model.finish
      //            ? model.postProperty.length > 0 ?
      //            ListView.builder(
      //                  itemCount: model.postProperty.length,
      //                 itemBuilder: (ctx, i) =>
      //                  CreationAwareListItem(
      //                   itemCreated: () {
      //                     if (i % 20 == 0)
      //                       model.requestMoreData();
      //                   },
      //                   child:GestureDetector (
      //                   onTap:() => model.navigateToDetailView(i),
      //                   child: HorizontalList(model.postProperty[i]),
      //                )
      //               )
      //             )
      //             :
      //             Center(
      //             child: CircularProgressIndicator(
      //               valueColor: AlwaysStoppedAnimation(
      //               Theme.of(context).primaryColor
      //               ),),)
      //               :
      //                Container(
      //                  margin: EdgeInsets.only(top:260),
      //                  child: Text(' There is no any rent house data !', 
      //                  textAlign: TextAlign.center,) ,
      //                )),
                     
      //                 Expanded(
      //                 flex: 2,
      //                 child: Container(
      //                   color: Colors.white,
      //                   child: Text('google Ads area'),
      //                 ),
      //               ),                        
      //           ],
      //           ),     



  // Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  //   final record = Record.fromSnapshot(data);

  //   return Dismissible(
  //     key: ValueKey(record.name),
  //     onDismissed: (direction){
  //       _deleteData(record.reference);
  //     },
  //     child: Padding(
  //       key: ValueKey(record.name),
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           border: Border.all(color: Colors.grey),
  //           borderRadius: BorderRadius.circular(5.0),
  //         ),
  //         child: ListTile(
  //           title: Text(record.name),
  //           trailing: Container(child: Text(record.votes.toString())),
  //           onTap: () => record.reference.updateData({'votes': FieldValue.increment(1)}),
  //         ),
  //       ),
  //     ),
  //   );
  // }
















  // backgroundColor: Colors.white,
      // appBar: AppBar(
      //   //automaticallyImplyLeading: false,
      //   //centerTitle: true,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[       
      //       Hero(
      //         tag: 'logo',
      //         child: Image.asset('assets/images/logo.png',
      //         scale: 4,),
      //       ),
      //       SizedBox(width: 5,),
      //       Text('Rent House List'),
      //     ],
      //   ),
      //   actions: <Widget>[
      //     Container(
      //       child: model.currentUser != null?            
      //       IconButton(
      //         icon:Icon(Icons.exit_to_app),
      //         onPressed:model.logout)
      //         : IconButton(
      //         icon:Icon(Icons.person_add),
      //         onPressed: model.navigateToLogin
      //         ) 
      //    )
      //   ],
      // ),
      // drawer:
      // AppDrawer(
      //   currentUser: model.currentUser,
      //   home:model.navigateToHouseOverView,
      //   mebership: model.navigateToMembershipView,
      //   property: model.navigateToPropertyManageView,
      //   logout: model.logout
      // ),

