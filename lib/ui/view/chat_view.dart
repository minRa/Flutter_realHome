import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_chat_demo/const.dart';
//import 'package:flutter_chat_demo/fullPhoto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/ui/widgets/full_photo.dart';
import 'package:realhome/view_model/chat_room_list_view_model.dart';
import 'dart:ui';



class ChatView extends StatelessWidget {
  final List<User> peerUser;
  ChatView( this.peerUser);

       


  final DialogService _dialogService = locator<DialogService>();
  void goOutOfChat(BuildContext context, ChatRoomListModel model,  User user, User peer, String groupChatId) async { 
  
        var dialogResponse = await _dialogService.showConfirmationDialog(
                title: 'go out of a chat',
                description: 'do you wanna quit a chat with ${peer.fullName} ?',
                confirmationTitle: 'OK',
                cancelTitle: 'CANCEL'        
              );
            if(dialogResponse.confirmed) {

              // if(peer.chattings.contains('$groupChatId-${user.id}') ||
              //  peer.chattings.contains('$groupChatId-${peer.id}')) {
              //    await Firestore.instance
              //   .collection('messages/$groupChatId/$groupChatId')
              //   .getDocuments().then((snapshot) {
              //     for (DocumentSnapshot doc in snapshot.documents) {
              //       doc.reference.delete();
              //       }
              //   });             
              // } else {
                if(!user.chattings.contains('$groupChatId-${peer.id}') 
                 || !user.chattings.contains('$groupChatId-${user.id}' )){
                 int i =0;
                 List<dynamic> userChat = List<dynamic>.generate(user.chattings.length, (index) => '');
                 await Future.forEach(user.chattings, (element){
                        if(element == groupChatId) {
                          userChat[i] = '$groupChatId-${peer.id}';
                         }else {
                          userChat[i] = element;
                         }
                          i++;
                      });
                 Firestore.instance.collection('users').document(user.id).updateData({'chattings': userChat});          
                // user.chattings.remove(groupChatId);
           //  }
            }
            model.navigateToStartPageView(2);
             // model.na
         //    Navigator.pop(context);   
        } 
      }
  
  @override
  Widget build(BuildContext context) {
    var groupChatId;
    if (peerUser[0].id.hashCode <= peerUser[1].id.hashCode) {
          groupChatId = '${peerUser[0].id}-${peerUser[1].id}';
      } else {
        groupChatId = '${peerUser[1].id}-${peerUser[0].id}';
        }

    return  ViewModelProvider<ChatRoomListModel>.withConsumer(
      viewModel: ChatRoomListModel(), 
     // onModelReady: (model) => model.getAllUserIformation(),
      builder: (context, model, child) =>
      new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          title: new Text(
            'CHAT',
            style: GoogleFonts.mcLaren(),
           // style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed:() => goOutOfChat(
                context,
                 model,
                 peerUser[0],
                 peerUser[1], 
                 groupChatId),
            )
          ],
        ),
        body: new ChatScreen(
          user: peerUser[0],
          peer: peerUser[1],
          groupChatId:groupChatId
        ),)
      );
  }
}




class ChatScreen extends StatefulWidget {
 final User user;
 final User peer;
 final String groupChatId;

  ChatScreen({Key key, 
  @required this.user, 
  @required this.peer,
  @required this.groupChatId


  }) : super(key: key);

  @override
  State createState() => new ChatScreenState(user: user, peer:peer, groupChatId:groupChatId);

}

class ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver
 {
  ChatScreenState({
    Key key, 
  @required this.user, 
  @required this.peer,
  @required this.groupChatId

  });

  User user;
  //String userAvatar;

  User peer;
  //String peerAvatar;
  //String id;

  var listMessage;
  String groupChatId;
  //SharedPreferences prefs;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();
  @override
  void initState() {
    _googleAdsService.disposeGoogleAds();
    super.initState();
    focusNode.addListener(onFocusChange);
    //groupChatId = '';
    isLoading = false;
    isShowSticker = false;
    imageUrl = '';
    readLocal();
   WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:
        print('paused state');
          Firestore.instance.collection('users').document(user.id).updateData({'chattingWith': null});
        break;
      case AppLifecycleState.resumed:
        print('resumed state');
       Firestore.instance.collection('users').document(user.id).updateData({'chattingWith':peer.id });
        break;
      case AppLifecycleState.inactive:
        print('inactive state');
         Firestore.instance.collection('users').document(user.id).updateData({'chattingWith': null});
        break;
      case AppLifecycleState.detached:
        print('detached state');
        
           Firestore.instance.collection('users').document(user.id).updateData({'chattingWith': null});
        break;
    }
  }



  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    textEditingController.dispose();
    listScrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }
  

  readLocal() async {
   /// prefs = await SharedPreferences.getInstance();
    //id = prefs.getString('id') ?? '';
    
    // if (user.id.hashCode <= peer.id.hashCode) {
    //   groupChatId = '${user.id}-${peer.id}';
    // } else {
    //   groupChatId = '${peer.id}-${user.id}';
    // }

  if(user.chattings == null ||!user.chattings.contains(groupChatId)) {
    List<dynamic> userChat;
    if(!user.chattings.contains('$groupChatId-${peer.id}')) {
       userChat = List<dynamic>.generate(user.chattings.length + 1, (index) => ''); //user.chattings;
      //userChat = user.chattings;
      if(user.chattings == null) {
        userChat[0] = groupChatId;
      } else {
         int i = 0;
        await Future.forEach(user.chattings, (element){
           userChat[i] = element;
           i++;
        });
        userChat[user.chattings.length] =groupChatId;
      }
    }else {
      userChat = List<dynamic>.generate(user.chattings.length, (index) => '');
        int i = 0;
       await Future.forEach(user.chattings, (element){
           if(element =='$groupChatId-${peer.id}') {
              userChat[i] = groupChatId;
           }else {
               userChat[i] = element;
           }
           i++;
       });
    }
    //  print(userChat);
 Firestore.instance.collection('users').document(user.id).updateData({'chattings': userChat});
  }
if(!peer.chattings.contains('$groupChatId-${user.id}')){ 
  if( !peer.chattings.contains(groupChatId)) {
   List<dynamic> peerChat =List<dynamic>.generate(peer.chattings.length +1, (index) => '');
    //peerChat = peer.chattings;
      if(peer.chattings == null) {
         peerChat[0]=groupChatId;
       } else {
         int i = 0;
        await Future.forEach(peer.chattings, (element){
           peerChat[i] = element;
           i++;
        });
         peerChat[peer.chattings.length] = groupChatId;
       }  
      Firestore.instance.collection('users').document(peer.id).updateData({'chattings': peerChat});
    }
  }

     

     Firestore.instance.collection('users').document(user.id).updateData({'chattingWith': peer.id});
    //setState(() {});
    // Future.delayed(const Duration(milliseconds: 500), () {
    //    Firestore.instance.collection('users').document(id).updateData({'chattingWith': null});
    // });
    //groupChatId = '';
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {

    String fileName = 'message/$groupChatId/${DateTime.now().millisecondsSinceEpoch.toString()}';
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = sticker

    if (content.trim() != '') {
      textEditingController.clear();

    if(peer.chattings.contains('$groupChatId-${user.id}')) {
      List<dynamic> peerChat =List<dynamic>.generate(peer.chattings.length, (index) => '');
        //peerChat = peer.chattings;
          if(peer.chattings == null) {
            peerChat[0]=groupChatId;
          } else {
            int i = 0;
            await Future.forEach(peer.chattings, (element){
              if(element =='$groupChatId-${user.id}') {
                peerChat[i] = groupChatId;
              }else {
                peerChat[i] = element;
              }
              i++;
            });
          }  
          Firestore.instance.collection('users').document(peer.id).updateData({'chattings': peerChat});
        }

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': user.id,
            'idTo': peer.id,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });

      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == user.id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == 0
              // Text
              ? Container(
                  child: Text(
                    document['content'],
                    textAlign: TextAlign.end,
                    style: TextStyle(color: primaryColor),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: greyColor2, borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                )
              : document['type'] == 1
                  // Image
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: greyColor2,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'images/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                    )
                  // Sticker
                  : Container(
                      child: new Image.asset(
                        'assets/images/${document['content']}.gif',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                    ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: peer.profileUrl == null ?
                          'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50'
                          :peer.profileUrl, 
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),

                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                document['type'] == 0
                    ? Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document['type'] == 1
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: greyColor2,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Material(
                                    child: Image.asset(
                                      'images/img_not_available.jpeg',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : Container(
                            child: new Image.asset(
                              'assets/images/${document['content']}.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                          ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm')
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['timestamp']))),
                      style: TextStyle(color: greyColor, fontSize: 12.0, fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] == user.id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] != user.id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Firestore.instance.collection('users').document(user.id).updateData({'chattingWith': null});
      //  Navigator.push(context,
      //   MaterialPageRoute(builder: (context) => ChatRoomListView()));
      //                        // },

      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Sticker
              (isShowSticker ? buildSticker() : Container()),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: new Image.asset(
                  'assets/images/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: new Image.asset(
                  'assets/images/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: new Image.asset(
                  'assets/images/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: new Image.asset(
                  'assets/images/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: new Image.asset(
                  'assets/images/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: new Image.asset(
                  'assets/images/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: new Image.asset(
                  'assets/images/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: new Image.asset(
                  'assets/images/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: new Image.asset(
                  'assets/images/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: greyColor2, width: 0.5)), color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator()//valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.photo_library),
                onPressed: getImage,
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.insert_emoticon),
                onPressed: getSticker,
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color:Colors.blueGrey, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: greyColor2, width: 0.5)), color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
