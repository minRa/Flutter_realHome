
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/ui/widgets/app_drawer.dart';
import 'package:realhome/ui/widgets/list_view_card.dart';
import 'package:realhome/ui/widgets/user_profile.dart';
import 'package:realhome/view_model/property_manage_view_model.dart';


class PropertyManageView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PropertyManageViewModel>.withConsumer(
      viewModel: PropertyManageViewModel(),    
      onModelReady: (model) => model.currentUserPostPropertyList(), 
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
      body:
      model.userPostProperty !=null //|| model.busy == true
      ?
      Column(
      children: <Widget>[  
            Expanded(
              flex: 4,
             child: 
             UserProfilePage(
               onAuth: model.currentUser.id != model.userPostProperty[0].id ? false : true,
               user: model.currentUser,
               editImage: model.userProfileImageChange,
               )),
              Expanded(
              flex: 8,
              child: ListView.builder(
                itemCount: model.userPostProperty.length,
                itemBuilder: (context, index) =>
                   GestureDetector(
                    onTap: ()=> model.navigateToDetailView(index),
                    child:ListViewCard (
                      onAuth: model.currentUser.id != model.userPostProperty[0].id ? false : true,
                      userProperty: model.userPostProperty[index], 
                      edit:()=> model.navigateToPostHouseView2(index),  
                      delete: () => model.deleteUserPostProperty(index),                 
                       ),
                     ),
                    )   
                ),              
              ],
            ) : Center(
                  child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).primaryColor),
                        ),), 
            floatingActionButton: Container(
              padding: EdgeInsets.symmetric(vertical: 100),
              child: FloatingActionButton(
                      child: Icon(Icons.add),
                          onPressed: model.currentUser != null ?
                         () =>model.navigateToPostHouseView(): 
                         () =>model.nonUserAddPost
                        ),       
                      ) , 
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


