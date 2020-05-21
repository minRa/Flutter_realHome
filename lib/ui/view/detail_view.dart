
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/view_model/detail_view_model.dart';



class DetailView extends StatefulWidget {
  final PostProperty postProperty;
  DetailView(
    this.postProperty,
  );

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();

  @override
  void initState() {
    _googleAdsService.disposeGoogleAds();
    super.initState();
  }

  @override
  void dispose() {
    _googleAdsService.bottomBanner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextEditingController _textController = new TextEditingController();
    
  
    Future<void>  _handleSubmitted(String text, User user) async {
      if(text =='') return;
      FocusScope.of(context).unfocus();
      _textController.text = '';
      //int randomNumber = Random().nextInt(10000);
      //var randomID = 'ID${randomNumber}';
      var nowString = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';

      try {
        await Firestore.instance.collection('comments')
        .document('${widget.postProperty.documentId}')
        .collection('userComments')
        .document('$nowString')
        .setData({
          'idTo':widget.postProperty.id,
          'docId':widget.postProperty.documentId,
          'content':text ,
          'userId':user.id, 
          'date':nowString,
          'fullName':user.fullName,
          'profileImage':user.profileUrl,
          'createdAt':DateTime.now().millisecondsSinceEpoch.toString(),
          });
      }catch(e){
        print(e.message);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(e.message),
              );
            }
        );
      }
    }
    


    Future<void> openMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }


 Widget _buildTextComposer(User user) {
  return new IconTheme(                                            //new
    data: new IconThemeData(color: Theme.of(context).accentColor), //new
    child: new Container(                                     //modified
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[            
          new Flexible(
            child: new TextField(
              controller: _textController,
              //onSubmitted: _handleSubmitted,
              decoration: new InputDecoration.collapsed(
                  hintText: " Type your comment...",
                  hintStyle: GoogleFonts.mcLaren()
                  ),
            ),
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () {
                   if(_textController.text.trim()!=''){
                  _handleSubmitted(_textController.text, user);
                 }
              }
            ),
          ),
        ],
      ),
    ),                                                             //new
  );
}
  

    return ViewModelProvider<DetailViewModel>.withConsumer(
      viewModel: DetailViewModel(),    
      onModelReady: (model) => model.getStartCurrentDetail(widget.postProperty) , 
      builder: (context, model, child) => Scaffold(
        //resizeToAvoidBottomPadding: false,
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('comments/${widget.postProperty.documentId}/userComments')
            .orderBy('createdAt').snapshots(),
            builder: (context,snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return SafeArea(
                  child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      floating: true,
                      pinned: false,
                      snap: true,
                      flexibleSpace: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Stack(
                            children: <Widget>[
                              GestureDetector(
                                onTap:() => model.navigateToBigImageView(widget.postProperty.imageUrl),
                                child: Hero(
                                  tag: widget.postProperty.imageUrl[0],
                                  child: Image.network(widget.postProperty.imageUrl[0],
                                  height:300,
                                  width: size.width,
                                  fit: BoxFit.fill,
                                  loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                     height:300,
                                    width: size.width,
                                    child: Center(
                                     child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null ? 
                                    loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                      : null,
                                    ),
                                ),
                                  );
                              },
                            )
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  height: 35,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: Colors.black.withOpacity(0.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.greenAccent.withOpacity(0.1),
                                        )
                                      ]
                                     ),
                                  child: GestureDetector(
                                      onTap:() => showDialog(
                                        context: context,
                                       builder: (context) => detailDialog(context, widget.postProperty),
                                       ),
                                      child: Center(
                                      child: Text( 'Rent Imformation',
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.mcLaren(
                                          color: Colors.white,
                                          textBaseline: TextBaseline.ideographic                                     
                                          ), ), ),),)),    

                                    Positioned(
                                        top: 28,
                                        left: size.width - 100,
                                        child: Center(
                                          child: Column(
                                            children: <Widget>[
                                              GestureDetector(
                                                   onTap: model.currentUser == null || widget.postProperty.id != model.currentUser.id ?
                                                   () => model.navigateToPostOwnerInfoView(model.owner) :
                                                   () => model.navigateToPropertyManageView(),                                         child: ClipOval(
                                                   child: SizedBox(
                                                    height: 80,
                                                    width: 80,
                                                    child: model.onloading ?
                                                    Center(child: CircularProgressIndicator(),):
                                                    model.owner.profileUrl == null? 
                                                     Image.asset('assets/images/avata2.png',
                                                     fit: BoxFit.cover,
                                                    ):  
                                                    Image.network(model.owner.profileUrl,
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
                                                ),
                                              ),
                                            ],
                                          ),
                                    )
                              )

                            ],
                              ),
                        Container(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("  ${widget.postProperty.title}", 
                                  style: 
                                  GoogleFonts.mcLaren(fontSize: 20,
                                   fontWeight: FontWeight.w600,
                                   color: Colors.black
                                   ),
                                  ),
                                   FlatButton.icon(
                                    icon: Icon(
                                      Icons.location_on,
                                    ),
                                    label: Text('Google map',
                                    style: GoogleFonts.mcLaren(),
                                    ),
                                    textColor: Theme.of(context).primaryColor,
                                    onPressed: ()=> openMap(
                                      widget.postProperty.address
                                       ) ,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                   Text("  ${widget.postProperty.city}", 
                                   style: GoogleFonts.mcLaren(fontSize: 15,
                                   fontWeight: FontWeight.w600,
                                   color: Colors.grey
                                   ),
                               ),
                              Text("\$ ${widget.postProperty.price} /\ per week  ",
                               style: GoogleFonts.mcLaren(fontSize: 15,
                                   fontWeight: FontWeight.w600,
                                   color: Colors.grey
                                   ),                    
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  _facilityCard(Icon(Icons.wifi), "Wifi"),
                                  _facilityCard(Icon(Icons.hotel), "Room ${widget.postProperty.room}"),
                                  _facilityCard(Icon(Icons.airline_seat_legroom_reduced), "Toilet ${widget.postProperty.toilet}"),
                                  _facilityCard(Icon(Icons.directions_car), "CarPark ${widget.postProperty.carpark}"),
                                ],
                              ), 
                            ],
                          ),
                        ),                  
                        ],
                     ),
                      ),
                      expandedHeight: 480,
                      backgroundColor: Colors.white,
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          if (index == 0) {
                             var user = model.getUser();
                             if(user == null) {
                               return Container (
                                child: Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: <Widget>[
                                   Icon(Icons.person), 
                                   FlatButton(
                                     textColor: Colors.black,
                                     child: Text('Login rquired to comments',
                                     style: GoogleFonts.mcLaren()
                                     ),
                                     onPressed:() => model.navigateToLogin(),
                                   )
                                ],),);
                             }else {
                               return _buildTextComposer(user);
                             }
                          }else {
                            return Column(
                            children: <Widget>[
                              Divider(),
                                GestureDetector(
                                  onLongPress: () => model.commmentsDelete(
                                  widget.postProperty.documentId,
                                  snapshot.data.documents[index-1].data['userId'],
                                  snapshot.data.documents[index-1].data['date'],),
                                    child: ListTile(
                                    leading: 
                                    Column(
                                      children: <Widget>[
                                        ClipOval(
                                          child:SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: snapshot.data.documents[index-1].data['profileImage'] is String?
                                          FadeInImage(
                                            image: NetworkImage(snapshot.data.documents[index-1].data['profileImage'],),
                                            placeholder: AssetImage('assets/images/avata.png'))          
                                          :Image.asset('assets/images/avata.png',
                                            fit: BoxFit.cover,),
                                          ),
                                        ),
                                         Text(snapshot.data.documents[index-1].data['fullName'],
                                          style: GoogleFonts.mcLaren(fontSize:10),
                                          ),
                                      ],
                                     ),
                                      title: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(snapshot.data.documents[index-1].data['content'],
                                            style: GoogleFonts.mcLaren()
                                            ),
                                          ),
                                        ],
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      ),
                                        subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child:Text(
                                        DateFormat('dd MMM kk:mm')
                                            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data.documents[index-1].data['createdAt']))),
                                        style: TextStyle(color:Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                                        ),
                                       )
                                  ),
                             ),
                            ],
                              );
                          }
                        },
                        childCount: (snapshot.data.documents.length+1),
                      ),
                    ),
                  ],
                ),
              );
            }
        )
      )
    );
  }

  _facilityCard(Icon asset, String name) {
    return Container(
      child: Padding(
        padding:  EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            asset,
            SizedBox(height: 5,),
            Text(name, style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600
            ),)
          ],
        ),
      ),
    );
  }
}


Widget detailDialog(BuildContext context, PostProperty postProperty) {
  //ThemeData localTheme = Theme.of(context);

  return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: [
        Hero(
        tag: postProperty.imageUrl[0],
        child: Image.network(
        postProperty.imageUrl[0],
        height: 300,
        fit: BoxFit.fill,),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
      SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                SizedBox(width: 5,),
                Container(
                  width: 120,
                  child: Text('Information     ',style: GoogleFonts.mcLaren(fontSize: 20),)),
                Container(
                 width: 155,


                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  SizedBox(width: 10,),
                  Icon(Icons.hotel, size: 20,),
                  Text('   ${postProperty.room}   ',style: GoogleFonts.mcLaren(fontWeight: FontWeight.bold,fontSize: 15),),                                       
                  Icon(Icons.airline_seat_legroom_reduced, size: 18,),
                  Text('   ${postProperty.toilet}   ',style: GoogleFonts.mcLaren(fontWeight: FontWeight.bold,fontSize: 15),),
                  Icon(Icons.time_to_leave, size: 18,),
                  Text('   ${postProperty.carpark}',style: GoogleFonts.mcLaren(fontWeight: FontWeight.bold,fontSize: 15),),          
                  ],),       
                )
              ],
            ),
          ),       
          Information('Title', postProperty.title),
          Information('City', postProperty.city),
          Information('Rent type', postProperty.rentType),
          Information('Address', postProperty.address),
          Information('Price', postProperty.price),
          Information('Available date', postProperty.date),
          Information('Name', postProperty.fullName),
          Information('Email', postProperty.email),
          Information('Messenger', postProperty.messenger),
          Information('Phone', postProperty.phone),
          Information('Note', postProperty.message),
        ],
      ),
   ),

            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK',
                    style: GoogleFonts.mcLaren(),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ]
  );
}

class Information extends StatelessWidget {
   final String title;
   final String content;
   Information(this.title, this.content);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Divider(),
          Row(
            children: <Widget>[
              SizedBox(width: 10,),
              Container(
                width: 100,
                child: Text('$title    ',style: GoogleFonts.mcLaren(fontSize: 15),)),
              Container(
              width: 165,
              child: title =='Price' ?
               Text('\$ $content /\ per week ',style: GoogleFonts.mcLaren(fontSize: 14),)
              :Text(content,style: GoogleFonts.mcLaren(fontSize: 14),)
              )
            ],
          ),
        ],
      ),
    );
  }
}


