import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/message.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/dataCenter.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/view_model/chat_room_list_view_model.dart';


class ChatRoomListView extends StatefulWidget {
  @override
  _ChatRoomListViewState createState() => _ChatRoomListViewState();
}

class _ChatRoomListViewState extends State<ChatRoomListView> {

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
                   Container (
                      padding: EdgeInsets.only(top:15),
                      child: Text('Chatting',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mcLaren(fontSize: 20),
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
                        final Message item = model.message.removeAt(oldIndex);
                        final User peer = model.peers.removeAt(oldIndex);
                        model.peers.insert(newIndex, peer);
                        model.message.insert(newIndex, item);
                      },
                    );}, //_onReorder,
                    scrollDirection: Axis.vertical,       
                    padding: const EdgeInsets.symmetric(vertical: 8.0),               
                    children: List.generate(
                    model.message.length,
                    (index) {
                      return
                      StreamBuilder(
                        key:ValueKey('$index'),
                        stream: Firestore.instance.collection(
                          'messages/${model.message[index].docId}/${model.message[index].docId}')
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
                                 ),
                                ),
                              ) :
                              Icon(Icons.account_circle,
                              size: 40,),
                              title: Container(
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                Text('Chat with ${model.peers[index].fullName}',
                                style: GoogleFonts.mcLaren(),
                                ),
                                ],
                                ),
                              ),
                              subtitle: snapshot.data.documents.last.data['idFrom']  == model.user.id ?
                              contentType(
                              context, 
                              snapshot.data.documents.last.data['type'],
                              snapshot.data.documents.last.data['content'],
                              'me',model.message[index].timestamp
                              ) :
                              contentType(
                              context, 
                              snapshot.data.documents.last.data['type'],
                              snapshot.data.documents.last.data['content'],
                              model.peers[index].fullName,
                              model.message[index].timestamp
                              ),
                              trailing: Text(DateFormat('dd MMM')
                              .format(DateTime.fromMillisecondsSinceEpoch(int.parse(model.message[index].timestamp))),
                              style: TextStyle(color:Colors.grey, fontSize: 10, fontStyle: FontStyle.italic),),
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
                  _googleAdsService.onBanner ?
                  Expanded(
                    flex: 2,
                    child:Container(),) :Container()
                ],
               )
            ),
          )
        );
  }
}

Widget contentType(
  BuildContext context, 
  int type,
  String input, 
  String userName,
  String time
  ) {

    String temp = DateFormat('KK:mm a').format(DateTime.fromMillisecondsSinceEpoch(int.parse(time)));    
    String content;
     if(type == 1) {
         content = 'IMAGE';
     }else if(type == 2) {
        content ='Emotiocon';
     } else {
        content = input;
     }    
   return Text('$userName: $content    [$temp]',
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
              Radius.circular(25.0)
                ),
                ),
              child: GestureDetector(
               onTap:withChat,
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
}

