
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/ui/widgets/list_view_card.dart';
import 'package:realhome/ui/widgets/user_profile.dart';
import 'package:realhome/view_model/post_owner_info_view_model.dart';
//const adUnitId = 'ca-app-pub-7333672372977808/2929937282';


class PostOwnerInfoView extends StatefulWidget {
  final User owner;
  PostOwnerInfoView(this.owner);

  @override
  _PostOwnerInfoViewState createState() => _PostOwnerInfoViewState();
}

class _PostOwnerInfoViewState extends State<PostOwnerInfoView> {

  

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
                 navigate: model.navigateToStartPageView,
                 user: widget.owner,
                 onAuth: false,
                 )),
                Expanded(
                flex: 6,
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
                    child: Container(),),               
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

//   Widget _mainBody(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: Firestore.instance.collection('').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return LinearProgressIndicator();

//         return _propertylistbuild(context, snapshot.data.documents);
//       },
//     );
//   }

//  @override
//   Widget _propertylistbuild(BuildContext context, List<DocumentSnapshot> snapshot) {
//   return ViewModelProvider<PropertyManageViewModel>.withConsumer(
//      viewModel: PropertyManageViewModel(),
//      builder: (context, model, child) =>
//       Expanded(
//       flex: 8,
//       child: ListView.builder(
//           itemCount: model.userPostProperty.length,
//           itemBuilder: (context, index) =>
//             GestureDetector(
//               onTap: ()=> model.navigateToDetailView(index),
//               child:ListViewCard (
//                 onAuth: model.currentUser.id != model.userPostProperty[0].id ? false : true,
//                 userProperty: model.userPostProperty[index], 
//                 edit:()=> model.navigateToPostHouseView2(index),  
//                 delete: () => model.deleteUserPostProperty(index),                 
//                 ),
//               ),
//               )   
//           ),
//       );
//     }





 
// FutureBuilder(
// future: model.currentUserPostPropertyList(),
// builder: (ctx, dataSnapshot) {
//   if(dataSnapshot.connectionState == ConnectionState.waiting){
//     return Center(
//         child: CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation(
//         Theme.of(context).primaryColor),
//         ),);  
//       } else {
//         if (dataSnapshot.error != null) {
//           // ...
//           // Do error handling stuff
//           return Center(
//             child: Text('An error occurred!'),
//           );
//         } else {           
//           return Column(
//           children: <Widget>[  
//                   Expanded(
//                     flex: 4,
//                   child: 
//                   UserProfilePage(
//                     onAuth: model.currentUser.id != model.userPostProperty[0].id ? false : true,
//                     user: model.currentUser,
//                     editImage: model.userProfileImageChange,
//                     ) 
//                   ),
//                   Expanded(
//                     flex: 8,
//                       child: ListView.builder(
//                       itemCount: model.userPostProperty.length,
//                       itemBuilder: (context, index) =>
//                         GestureDetector(
//                           onTap: ()=> model.navigateToDetailView(index),
//                           child:ListViewCard (
//                             onAuth: model.currentUser.id != model.userPostProperty[0].id ? false : true,
//                             userProperty: model.userPostProperty[index], 
//                             edit:()=> model.navigateToPostHouseView2(index),  
//                             delete: () => model.deleteUserPostProperty(index),                 
//                                   ), ),)                  
//                               ),              
//                             ],);    
//                           }
//                         }
//                       }
//                   ), 
//                   floatingActionButton: Container(
//                   padding: EdgeInsets.symmetric(vertical: 100),
//                   child: FloatingActionButton(
//                           child: Icon(Icons.border_color),
//                             onPressed: model.currentUser != null ?
//                             model.navigateToPostHouseView :
//                             model.nonUserAddPost
//                             )
//                         )
//       ),
//     );  
//   }
// }





 

// ReorderableListView(
//   onReorder: (int oldIndex, int newIndex) {
//     setState(
//       () {
//         if (newIndex > oldIndex) {
//           newIndex -= 1;
//         }
//       final PostProperty item = model.userPostProperty.removeAt(oldIndex);
//       model.userPostProperty.insert(newIndex, item);
//     },
//   );}, //_onReorder,
//   scrollDirection: Axis.vertical,       
//   padding: const EdgeInsets.symmetric(vertical: 8.0),               
//   children: List.generate(
//     model.userPostProperty.length,
//   (index) {
//     return GestureDetector(
//       onTap: model.navigateToDetailView(index),
//       child: ListViewCard(
//       index: index,
//       key:ValueKey('$index'),
//       listItems: model.userPostProperty[index],                                      
//       ),
//     );
//     },
//   ),
//  )


