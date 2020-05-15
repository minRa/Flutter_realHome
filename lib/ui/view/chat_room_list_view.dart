import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/message.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/view_model/chat_room_list_view_model.dart';


class ChatRoomListView extends StatefulWidget {
  @override
  _ChatRoomListViewState createState() => _ChatRoomListViewState();
}

class _ChatRoomListViewState extends State<ChatRoomListView> {

  // final _serchTextController = TextEditingController();
  // bool onSearch = false;
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
    return ViewModelProvider<ChatRoomListModel>.withConsumer(
      viewModel: ChatRoomListModel(), 
      onModelReady: (model) => model.getAllUserIformation(),
      builder: (context, model, child) => SafeArea(
          child: Scaffold(
          body: 
          Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Container(
                color: Colors.white,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   Container(
                     padding: EdgeInsets.only(top:15),
                     child: Image.asset('assets/images/logo2.png',
                      scale:12,
                      fit: BoxFit.cover,),
                   ),
                   Container (
                      padding: EdgeInsets.only(top:15),
                      child: Text(' Chatting',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mcLaren(fontSize: 20),
                      // style: TextStyle(
                      //   fontSize: 20
                      // ),
                    ),),
                    SizedBox(width: 35,
                    )
                ],
              ),
                ),
              Container(height: 10,
              color: Colors.white,
              ),
              Expanded(
                flex: 10,
                child: model.loading ? 
                Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).primaryColor
                  ),),)
                 : 
                 model.currentUser == null?
                 Container(
                   padding: EdgeInsets.only(top:50),
                  color: Colors.white,
                   child: Column(
                     children: <Widget>[
                       Container(
                         child: Image.asset('assets/images/guest.png',
                         fit: BoxFit.cover,
                         )
                       ),
                       Text('only for login user',
                       style: GoogleFonts.mcLaren(fontSize: 18),
                       textAlign: TextAlign.center,),
                     ],
                   ),)
                 :model.message != null && model.message.length > 0?
                   ReorderableListView(
                     onReorder: (int oldIndex, int newIndex) {
                      setState(
                        () {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                        final List<Message> item = model.message.removeAt(oldIndex);
                        model.message.insert(newIndex, item);
                      },
                    );}, //_onReorder,
                    scrollDirection: Axis.vertical,       
                    padding: const EdgeInsets.symmetric(vertical: 8.0),               
                    children: List.generate(
                    model.message.length,
                    (index) {
                      return
                      // child: ListView.builder(
                      // itemCount: model.message.length,
                      // itemBuilder: (ctx, index) => 
                      StreamBuilder(
                        key:ValueKey('$index'),
                        stream: Firestore.instance.collection(
                          'messages/${model.user.chattings[index]}/${model.user.chattings[index]}')
                          .snapshots(),
                        builder: (context, snapshot) {
                          if(!snapshot.hasData) return Container();
                          return ListTile(
                            onTap:()=> model.chatWith(index),
                            leading: model.peers[index].profileUrl != null?
                            ClipOval(
                              child:SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.network(model.peers[index].profileUrl,
                                fit: BoxFit.cover,),
                                ),
                              ) :
                              Icon(Icons.account_circle,
                              size: 40,),
                              title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                              Text('Chat with ${model.peers[index].fullName}',
                              style: GoogleFonts.mcLaren(),
                              ),
                              Text(DateFormat('dd MMM kk:mm')
                              .format(DateTime.fromMillisecondsSinceEpoch(int.parse(model.message[index].last.timestamp))),
                              style: TextStyle(color:Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),)
                              ],
                              ),
                              subtitle: snapshot.data.documents.last.data['idFrom']  == model.user.id ?
                              contentType(
                              context, 
                              snapshot.data.documents.last.data['type'],
                              snapshot.data.documents.last.data['content'],
                             // model.message[index].last.type,
                              //model.message[index].last.content,
                              'me') :
                              contentType(
                              context, 
                              snapshot.data.documents.last.data['type'],
                              snapshot.data.documents.last.data['content'],
                              model.peers[index].fullName) 
                            // Text('me: ${model.message[i].last.content}') :
                            // Text('${model.peers[i].fullName}: ${model.message[i].last.content}'),
                            //trailing:Icon(Icons.exit_to_app) ,
                          );
                        }
                      );
                    },
                    ),
                  ) : Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top:20) ,
                      child: Column(
                        children: <Widget>[
                           Container(
                         child: Image.asset('assets/images/notchat.png',
                         fit: BoxFit.cover,
                         )
                       ),
                      Text('There is no Chat list',
                     style: GoogleFonts.mcLaren(fontSize: 18),
                     textAlign: TextAlign.center,),
                        ],
                      ),),
              ),
                  Expanded(
                    flex: 2,
                    child:Container(),)
                ],
               )
            ),
          )
        );
  }
}

Widget contentType(BuildContext context, int type, String input, String userName,) {
       
      String content;
     if(type == 1) {
         content = 'IMAGE';
     }else if(type == 2) {
        content ='Emotiocon';
     } else {
        content = input;
     }    
   return Text('$userName: $content',
   style: GoogleFonts.mcLaren(),
   );
}



Widget usersDialog(BuildContext context, List<User> users, Function withChat) {
  //ThemeData localTheme = Theme.of(context);
  return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top:10),
          child: Text('Chat with',
          style: TextStyle(
            fontSize: 20
          ),
          textAlign: TextAlign.center,),
        ),
        SingleChildScrollView(
         child: Container(
          height: 600,
          width: 200,
          child: 
          ListView.builder(
            itemCount: users.length,
            itemBuilder: (ctx, i) =>  Container(
           // margin: const EdgeInsets.fromLTRB(14.0,10,14,10),
           // padding: const EdgeInsets.fromLTRB(5,5,5,5),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey[400]),
              borderRadius: BorderRadius.all(
              Radius.circular(25.0)
                ),
                ),
              child: GestureDetector(
               onTap:withChat,
              //() async{
              // withChat;
              // Navigator.of(context).pop();
              // } ,
              child: Container(
              margin:EdgeInsets.only(top:15, bottom: 10) ,
              child: ListTile(
                leading: SizedBox(
                height: 50,
                width: 50,
                child: users[i].profileUrl == null? 
                Icon(Icons.person,
                color: Colors.black,
                size: 50,
                ):  
                Image.network(users[i].profileUrl,
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
                )
              ),
              title: Container(
                child: Text('${users[i].fullName}',
                style: TextStyle(
                fontSize: 20
                  ),
                ),
              ),
              subtitle: Container(
                  child: Text('${users[i].email}',
                  style: TextStyle(
                  fontSize: 15
                  ),
                  ),
              ),
            )
         ),
        ),),),),),
      ]);


  //   Container(
//   padding: EdgeInsets.only(top:10),
//   child: 
//   Row(
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: <Widget>[
//     Visibility(
//     visible: onSearch,
//     child: SizedBox(
//     height: 35,
//     width: 200,
//     child: TextFormField(
//     decoration: InputDecoration(      
//     contentPadding: const EdgeInsets.only(top:10, left: 6),               
//     focusedBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
//     ),
//     enabledBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.white, width: 1.0),
//     ),
//     labelStyle: TextStyle(
//       color: Colors.blueGrey
//     ),
// // icon:Icon(Icons.credit_card, color: Colors.blueGrey),
//     labelText: 'Search',
//     hintText: 'Search person'
//     ),
//     //  validator: (String value) {
//     //       if (value.trim().isEmpty) {
//     //         return 'price is required';
//     //       }else {
//     //         return null;
//     //         }
//     //       },
//     style: TextStyle(color: Colors.black),
//     controller: _serchTextController,
//           ),
//         ),
//       ),     
//       IconButton(
//         icon:Icon(Icons.search),
//         onPressed: (){
//          setState(() {
//           onSearch = !onSearch;
//          });
//         },
//       ),
//       IconButton(
//         icon: Icon(Icons.person_add,),
//         onPressed: () {
//              showDialog(
//              context: context,
//              builder: (context) => usersDialog(context, model.users, model.chatWith));
//           } 
//       )
//     ],),
// ),

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


      // children: [
      //   

    //      SingleChildScrollView(
    //           child:
    // ListView.builder(
    //           itemCount: users.length,
    //           itemBuilder: (ctx, i) =>  Container(

    //         // margin: const EdgeInsets.fromLTRB(14.0,10,14,10),
    //         // padding: const EdgeInsets.fromLTRB(5,5,5,5),
    //           decoration: BoxDecoration(
    //           // border: Border.all(color: Colors.grey[400]),
    //             borderRadius: BorderRadius.all(
    //             Radius.circular(25.0)
    //               ),
    //               ),
    //             child: GestureDetector(
    //             onTap:() async{
    //             withChat;
    //             Navigator.of(context).pop();
    //             } ,
    //             child: Container(
    //             margin:EdgeInsets.only(top:15, bottom: 10) ,
    //             child: ListTile(
    //               leading: SizedBox(
    //               height: 50,
    //               width: 50,
    //               child: users[i].profileUrl == null? 
    //               Icon(Icons.person,
    //               color: Colors.white,
    //               size: 50,
    //               ):  
    //               Image.network(users[i].profileUrl,
    //               fit: BoxFit.cover,
    //               loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
    //               if (loadingProgress == null) return child;
    //                 return Center(
    //                   child: CircularProgressIndicator(
    //                   value: loadingProgress.expectedTotalBytes != null ? 
    //                         loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
    //                         : null,
    //                   ),
    //                 );
    //               },
    //               )
    //             ),
    //             title: Container(
    //               child: Text('${users[i].fullName}',
    //               style: TextStyle(
    //               fontSize: 20
    //                ),
    //               ),
    //             ),
    //             subtitle: Container(
    //                child: Text('${users[i].email}',
    //                style: TextStyle(
    //                 fontSize: 15
    //                ),
    //                ),
    //             ),
    //           )
    //         ),
    //   ),
    // ),
    //       ),
    //     ),
 // ]);
}




  // children: <Widget>[
  //             Expanded(
  //                flex: 5,
  //                 child: Row(
  //                   children: <Widget>[
  //                     Container(
  //                     height: 100,
  //                     width: 100,
  //                     child: ClipOval( 
  //                     child:Align(
  //                     heightFactor: 0.7,
  //                     widthFactor: 0.5,
  //                     child: model.currentUser.profileUrl == null? 
  //                       Icon(Icons.person,
  //                     color: Colors.blueGrey,
  //                     size: 60,
  //                     ):  
  //                     Image.network(model.currentUser.profileUrl,
  //                     fit: BoxFit.cover,
  //                     loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
  //                     if (loadingProgress == null) return child;
  //                       return Center(
  //                         child: CircularProgressIndicator(
  //                         value: loadingProgress.expectedTotalBytes != null ? 
  //                               loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
  //                               : null,
  //                               ),
  //                             );
  //                           },
  //                         )
  //                       ), 
  //                     ),
  //                 ),
  //                ],
  //                 ),

  //                 // ListTile(
  //                 // leading: 
  //                 // title:_buildFullName(model.currentUser.fullName),
  //                 // subtitle: _buildGetInTouch(context, model.currentUser.email),
  //               // ),