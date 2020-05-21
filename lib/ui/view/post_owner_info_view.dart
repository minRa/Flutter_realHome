
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/ui/widgets/list_view_card.dart';
import 'package:realhome/ui/widgets/user_profile.dart';
import 'package:realhome/view_model/post_owner_info_view_model.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/locator.dart';

class PostOwnerInfoView extends StatefulWidget {
  final User owner;
  PostOwnerInfoView(this.owner);

  @override
  _PostOwnerInfoViewState createState() => _PostOwnerInfoViewState();
}

class _PostOwnerInfoViewState extends State<PostOwnerInfoView> {

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
    return ViewModelProvider<PostOwnerInfoViewModel>.withConsumer(
      viewModel: PostOwnerInfoViewModel(),    
      onModelReady: (model) => model.currentOwnerPostPropertyList(widget.owner), 
      builder: (context, model, child) =>
        SafeArea(
         child: Scaffold(
          body:
          model.posts != null?
          Column(
          children: <Widget>[  
              Expanded(
               flex: 7,
               child: 
               UserProfilePage(
                 guest: model.currentUser == null? true : false,
                 navigate: model.navigateToStartPageView,
                 user: widget.owner,
                 onLoading: model.onloading,
                 onAuth: false,
                 goToChatRoom: model.navigateToChatView,
                 )),
                Expanded(
                flex: 4,
                child: model.posts != null?
                 ListView.builder(
                  itemCount: model.posts.length,
                  itemBuilder: (context, index) =>
                     GestureDetector(
                      onTap: ()=> model.navigateToDetailView(index),
                      child:ListViewCard (
                        onAuth: false,
                        userProperty: model.posts[index],                 
                         ),
                       ),
                      ) :
                      Container()
                    ),
                     Expanded(
                    flex: 3,
                    child: Container()
                    ,),               
                ],
                ) : Center(
                    child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).primaryColor),
                ),)
             ),
        )    
       );  
    }
}
