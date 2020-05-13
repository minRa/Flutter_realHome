
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

//import 'package:realhome/ui/widgets/app_drawer.dart';
import 'package:realhome/ui/widgets/list_view_card.dart';
import 'package:realhome/ui/widgets/user_profile.dart';
import 'package:realhome/view_model/property_manage_view_model.dart';
//const adUnitId= 'ca-app-pub-7333672372977808/7997010253';


class PropertyManageView extends StatefulWidget {

  @override
  _PropertyManageViewState createState() => _PropertyManageViewState();
}

class _PropertyManageViewState extends State<PropertyManageView> {
 

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PropertyManageViewModel>.withConsumer(
      viewModel: PropertyManageViewModel(),    
      onModelReady: (model) => model.currentUserPostPropertyList(), 
      builder: (context, model, child) =>
       SafeArea(
          child: Scaffold(
          body:
          model.currentUser != null ?
          model.finish ?
          model.userPostProperty == null
          || model.userPostProperty.length == 0  ?
          UserProfilePage(
              onAuth: true,
              navigate:model.navigateToStartPageView,
              user: model.currentUser,
              editImage:()=> model.userProfileImageChange('profile'),
              editBackground:()=> model.userProfileImageChange('abc'),
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
                    editImage:()=> model.userProfileImageChange('profile'),
                    editBackground:()=> model.userProfileImageChange('abc'),
                    )),
                  Expanded(
                  flex: 4,
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
                        Container()
                      ),
                        Expanded(
                      flex: 3,
                      child: Container(),),               
                  ],) 
              
                : Center(
                    child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).primaryColor),
                          ),)
                 : Container(
                   child: Column(
                     children: <Widget>[
                       Stack(
                         //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                        //  height:,
                          width: double.infinity,
                         child: Image.asset('assets/images/cover.jpg',
                          fit: BoxFit.cover,
                          scale: 1.5,
                          ),
                       ),
                      // SizedBox(height: screenSize.height / 3.0),
                       Positioned(
                          top: 120,
                          left: 70,
                          child: 
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                              image:DecorationImage(
                              image:AssetImage('assets/images/avata.png') ,
                              fit: BoxFit.cover,),
                                borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 10.0,
                                    ),
                                  ),
                              ),
                             SizedBox(height: 5,),
                              Text('GUEST',
                              style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.black
                            ),
                            textAlign: TextAlign.center,
                           ),
                            SizedBox(height: 20,),
                            Text('Post Property Management page',
                            style: TextStyle(
                              fontSize: 18
                            ),),
                            Text('This service rquired to login',
                             style: TextStyle(
                              fontSize: 18
                            ),),
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
                padding: EdgeInsets.symmetric(vertical: 100),
                child: FloatingActionButton(
                        child: Icon(Icons.border_color),
                            onPressed: () => model.navigateToPostHouseView()
                            )
                        ) : Container() , 
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


