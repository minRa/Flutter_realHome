
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/ui/widgets/app_drawer.dart';
import 'package:realhome/ui/widgets/creation_aware_list_item.dart';
import 'package:realhome/ui/widgets/dropdown.dart';
import 'package:realhome/ui/widgets/viewList.dart';
import 'package:realhome/view_model/House_overview_model.dart';


class HouseOverview extends StatelessWidget {
  Widget build(BuildContext context) {
    return ViewModelProvider<HouseOverviewModel>.withConsumer(
      viewModel: HouseOverviewModel(),    
      onModelReady: (model) => model.listenToPosts(), 
      builder: (context, model, child) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        //centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[       
            Hero(
              tag: 'logo',
              child: Image.asset('assets/images/logo.png',
              scale: 4,),
            ),
            SizedBox(width: 5,),
            Text('Rent House List'),
          ],
        ),
        actions: <Widget>[
          Container(
            child: model.currentUser != null?            
            IconButton(
              icon:Icon(Icons.exit_to_app),
              onPressed:model.logout)
              : IconButton(
              icon:Icon(Icons.person_add),
              onPressed: model.navigateToLogin
              ) 
         )
        ],
      ),
      drawer:
      AppDrawer(
        currentUser: model.currentUser,
        home:model.navigateToHouseOverView,
        mebership: model.navigateToMembershipView,
        property: model.navigateToPropertyManageView,
        logout: model.logout
      ),
      body: Column(
         children: <Widget>[
           Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                DropDownBox(),
                DropDownBox(),
                DropDownBox(),
                ],),
                SizedBox(height: 10,),
              Expanded(
                flex: 11,
                child: model.postProperty != null
                 ? ListView.builder(
                       itemCount: model.postProperty.length,
                      itemBuilder: (ctx, i) =>
                       CreationAwareListItem(
                        itemCreated: () {
                          if (i % 20 == 0)
                            model.requestMoreData();
                        },
                        child:GestureDetector (
                        onTap:() => model.navigateToDetailView(i),
                        child: HorizontalList(model.postProperty[i]),
                     )
                    )
                  ):
                  Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).primaryColor
                    ),),),),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: Text('google Ads area'),
                ),
              ),                        
         ],
        ),     
       )
    );
  }
}


