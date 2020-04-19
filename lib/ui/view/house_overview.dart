
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/ui/widgets/app_drawer.dart';
import 'package:realhome/ui/widgets/banner_add.dart';
import 'package:realhome/ui/widgets/dropdown.dart';
import 'package:realhome/ui/widgets/viewList.dart';
import 'package:realhome/view_model/House_overview_model.dart';


class HouseOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HouseOverviewModel>.withConsumer(
      viewModel: HouseOverviewModel(),    
      // onModelReady: (model) => model.listenToUser() , 
      builder: (context, model, child) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Rent House List'),
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
      drawer: AppDrawer(),
      body: Column(
         children: <Widget>[
           Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                DropDownBox(),
                DropDownBox(),
                DropDownBox(),],),
                SizedBox(height: 10,),
              // Expanded(child: VerticalList(onTap: model.navigateToDetailView )),
              BannerADD()
         ],
        ),
         floatingActionButton: FloatingActionButton(
         child: Icon(Icons.border_color),
         onPressed: model.currentUser != null ?
         model.navigateToPostHouseView :
         model.nonUserAddPost
       ),       
       )
    );
  }
}