import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/ui/widgets/app_drawer.dart';
import 'package:realhome/view_model/property_manage_view_model.dart';


class PropertyManageView extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return ViewModelProvider<PropertyManageViewModel>.withConsumer(
      viewModel: PropertyManageViewModel(),    
      //onModelReady: (model) => model.initialGoogleAds() , 
      builder: (context, model, child) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Post rent House'),
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
           Expanded(
              flex: 2,
              child: Center(
                child:Text(' information')
              )), 
              Expanded(
                flex: 12,
                child: Container(
                  color: Colors.blueAccent,
                ),
                ), 
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: Text('google Ads area'),
                ),
              ),                        
         ],
        ),  
        floatingActionButton: Container(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: FloatingActionButton(
                  child: Icon(Icons.border_color),
                    onPressed: model.currentUser != null ?
                    model.navigateToPostHouseView :
                    model.nonUserAddPost
          ),       
        ) ,     
       )
    );
  }
}


 