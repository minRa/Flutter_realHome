//import 'dart:math';
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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextEditingController _textController = new TextEditingController();
  
  

    Future<void>  _handleSubmitted(String text, User user) async {
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
          'content':text ,
          'userId':user.id, 
          'date':nowString,
          'fullName':user.fullName,
          'profileImage':user.profileUrl
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
    //String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
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
                  hintText: "Add a your comment.."),
            ),
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text, user)),
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
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('comments').document('${widget.postProperty.documentId}').collection('userComments').snapshots(),
            builder: (context,snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return SafeArea(
                  child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      floating: true,
                      pinned: false,
                      snap: true,
                      flexibleSpace: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                              child: Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap:() => model.navigateToBigImageView(widget.postProperty.imageUrl),
                                  child: Hero(
                                    tag: widget.postProperty.imageUrl[0],
                                    child: Image.network(widget.postProperty.imageUrl[0],
                                    width: size.width,
                                    fit: BoxFit.fill),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    height: 35,
                                    width: 400,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3.0),
                                        color: Colors.black.withOpacity(0.5),//Color(0xff0F0F0F),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.greenAccent.withOpacity(0.2),
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
                                          style: TextStyle(
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
                                                     onTap:() => model.navigateToPostOwnerInfoView(model.owner),                                         child: ClipOval(
                                                     child: SizedBox(
                                                      height: 80,
                                                      width: 80,
                                                      child: model.owner != null?   
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
                                                      ): Icon(Icons.person,
                                                      color: Colors.white,
                                                      size: 80,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              //   Padding(
                                              //     padding: const EdgeInsets.only(left: 8,right: 6, top: 3,bottom: 3),
                                              //     child: Icon(Icons.favorite,
                                              //       size: 24,
                                              //       color: Colors.red,),
                                              //  ),
                                                // Text( '11',
                                                //   style: TextStyle(color: Colors.white),
                                                // ),
                                              ],
                                            ),
                                      )
                                )

                              ],
                            ),
                          ),
                      Container(
                      //margin: EdgeInsets.only(top:0, bottom:5),
                     // child: Text('Google Map')
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("  ${widget.postProperty.title}", style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600
                                  ),),
                                   FlatButton.icon(
                                    icon: Icon(
                                      Icons.location_on,
                                    ),
                                    label: Text('Google map'),
                                    textColor: Theme.of(context).primaryColor,
                                    onPressed: ()=> openMap(
                                      widget.postProperty.address
                                      // postProperty.latitude,
                                      //  postProperty.longitude
                                       ) ,
                                  ),
                                ],
                              ),
                              //SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                   Text("  ${widget.postProperty.city}", style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600
                              ),),
                              Text("\$${widget.postProperty.price} /\ week  ", style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600
                              ),),

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
                      ),                  
                      ],
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
                                      child: Text('Login rquired to comments'),
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
                                      leading: snapshot.data.documents[index-1].data['profileImage'] != null?
                                      ClipOval(
                                        child:SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: Image.network(snapshot.data.documents[index-1].data['profileImage'],
                                          fit: BoxFit.cover,),
                                        ),
                                      ) :
                                      Icon(Icons.account_circle,
                                        size: 40,),

                                        title: Column(
                                          children: <Widget>[
                                            Text(snapshot.data.documents[index-1].data['fullName']),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Text(snapshot.data.documents[index-1].data['content']),
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        ),
                                          subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child:Text(snapshot.data.documents[index-1].data['date']),
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
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10.0),
      //   border: Border.all(color: Colors.black)
      // ),
      child: Padding(
        padding:  EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            asset,
            //Image.asset(asset, height: 40, width: 40 ,),
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
        fit: BoxFit.fill),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SingleChildScrollView(
      child: Container(
      width: double.infinity,
      child: DataTable( 
      
      columnSpacing: 0, 
      dataRowHeight: 35, 
      columns: [
        DataColumn(label: Text('Information', style: TextStyle(fontSize: 20),)),
        DataColumn(label: Row(children: <Widget>[
        Icon(Icons.hotel, size: 20,),
        Text(' ${postProperty.room}  ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),                                       
        Icon(Icons.airline_seat_recline_extra, size: 20,),
        Text(' ${postProperty.toilet}  ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
        Icon(Icons.time_to_leave, size: 20,),
        Text(' ${postProperty.carpark}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),          
        ],),       
         )],
      rows: [
        DataRow(cells: [
        DataCell(Text('Title',style: TextStyle(fontSize: 15),)),
        DataCell(Text(postProperty.title,style: TextStyle(fontSize: 14),)),
        ]),
        DataRow(cells: [
        DataCell(Text('City',style: TextStyle(fontSize: 15),)),
        DataCell(Text(postProperty.city,style: TextStyle(fontSize: 14),)),
        ]),
         DataRow(cells: [
        DataCell(Text('RentType',style: TextStyle(fontSize: 15),)),
        DataCell(Text(postProperty.rentType,style: TextStyle(fontSize: 14),)),
        ]),
        DataRow(cells: [
        DataCell(Text('Address',style: TextStyle(fontSize: 15),)),
        DataCell(Text(postProperty.address,style: TextStyle(fontSize: 14),)),
        ]),
        DataRow(cells: [
        DataCell(Text('Price',style: TextStyle(fontSize: 15),)),
        DataCell(Text(postProperty.price,style: TextStyle(fontSize: 14),)),
        ]),
        DataRow(cells: [
        DataCell(Text('Avaible date',style: TextStyle(fontSize: 15),)),
        DataCell(Text(postProperty.date,style: TextStyle(fontSize: 14),)),
        ]),
        DataRow(cells: [
        DataCell(Text('Name',style: TextStyle(fontSize: 15),)),
        DataCell(Text(postProperty.fullName,style: TextStyle(fontSize: 14),)),
        ]),
        DataRow(cells: [
        DataCell(Text('Email',style: TextStyle(fontSize: 15),)),
        DataCell(Text(postProperty.email,style: TextStyle(fontSize: 14),)),
        ]),
        DataRow(cells: [
        DataCell(Text('messenger',style: TextStyle(fontSize: 15),)),
        DataCell(Text(postProperty.messenger,style: TextStyle(fontSize: 14),)),
        ]),
         DataRow(cells: [
        DataCell(Text('Phone',style: TextStyle(fontSize: 15),)),
        DataCell(Text(postProperty.phone,style: TextStyle(fontSize: 14),)),
        ]),
         DataRow(  
         cells: [
         DataCell(Text('note',style: TextStyle(fontSize: 15),)),
         DataCell(Text(postProperty.message,style: TextStyle(fontSize: 14),)),
        ]),
      ],
      ),
      ),
    ),


            // Text(
            //   title,
            //   style: localTheme.textTheme.display1,
            // ),
            // Text(
            //   explain,
            // ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                  // RaisedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  //       return Second(appBarTitle: title,imageURL: imageURL);
                  //     }));
                  //   },
                  //   child: const Text('Move Next Class'),
                  // )
                ],
              ),
            )
          ],
        )
      ]
  );
}




// class ImformationWidget extends StatelessWidget {
//   const ImformationWidget({
//     Key key,
//     @required PostProperty postProperty,
//   }) : _postProperty = postProperty, super(key: key);

//   final PostProperty _postProperty;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//       width: double.infinity,
//       child: DataTable( 
      
//       columnSpacing: 0, 
//       dataRowHeight: 35, 
//       columns: [
//         DataColumn(label: Text('Information', style: TextStyle(fontSize: 20),)),
//         DataColumn(label: Text('')),
//       ],
//       rows: [
//           DataRow(cells: [
//           DataCell(Text('Title',style: TextStyle(fontSize: 15),)),
//           DataCell(Text(_postProperty.title,style: TextStyle(fontSize: 14),)),
//         ]),
//         DataRow(cells: [
//           DataCell(Text('City',style: TextStyle(fontSize: 15),)),
//           DataCell(Text(_postProperty.city,style: TextStyle(fontSize: 14),)),
//         ]),
//            DataRow(cells: [
//           DataCell(Text('RentType',style: TextStyle(fontSize: 15),)),
//           DataCell(Text(_postProperty.rentType,style: TextStyle(fontSize: 14),)),
//         ]),
//           DataRow(cells: [
//           DataCell(Text('Address',style: TextStyle(fontSize: 15),)),
//           DataCell(Text(_postProperty.address,style: TextStyle(fontSize: 14),)),
//         ]),
//           DataRow(cells: [
//           DataCell(Text('Price',style: TextStyle(fontSize: 15),)),
//           DataCell(Text(_postProperty.price,style: TextStyle(fontSize: 14),)),
//         ]),
//           DataRow(cells: [
//           DataCell(Text('Avaible date',style: TextStyle(fontSize: 15),)),
//           DataCell(Text(_postProperty.date,style: TextStyle(fontSize: 14),)),
//         ]),
//         DataRow(cells: [
//           DataCell(Text('Name',style: TextStyle(fontSize: 15),)),
//           DataCell(Text(_postProperty.fullName,style: TextStyle(fontSize: 14),)),
//         ]),
//         DataRow(cells: [
//           DataCell(Text('Email',style: TextStyle(fontSize: 15),)),
//           DataCell(Text(_postProperty.email,style: TextStyle(fontSize: 14),)),
//         ]),
//         DataRow(cells: [
//           DataCell(Text('messenger',style: TextStyle(fontSize: 15),)),
//           DataCell(Text(_postProperty.messenger,style: TextStyle(fontSize: 14),)),
//         ]),
//            DataRow(cells: [
//           DataCell(Text('Phone',style: TextStyle(fontSize: 15),)),
//           DataCell(Text(_postProperty.phone,style: TextStyle(fontSize: 14),)),
//         ]),
//          DataRow(  
//            cells: [
//            DataCell(Text('note',style: TextStyle(fontSize: 15),)),
//            DataCell(Text(_postProperty.message,style: TextStyle(fontSize: 14),)),
//         ]),
//       ],
//       ),
//       ),
//     );
//   }
// }







      // Scaffold(
      // backgroundColor: Colors.white,
      // appBar: AppBar(
      //   //automaticallyImplyLeading: false,
      //   centerTitle: true,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[       
      //       Hero(
      //         tag: 'logo',
      //         child: Image.asset('assets/images/logo.png',
      //         scale: 4,),
      //       ),
      //       SizedBox(width: 5,),
      //       Text('Rent House Detail'),
      //     ],
      //   ),
      //   actions: <Widget>[
      //     Container(
      //       child: model.currentUser != null?            
      //       IconButton(
      //         icon:Icon(Icons.exit_to_app),
      //         onPressed:model.logout)
      //         : IconButton(
      //         icon:Icon(Icons.person_add),
      //         onPressed: model.navigateToLogin
      //         ) 
      //    )
      //   ],
      // ),
      // drawer:
      // AppDrawer(
      //   currentUser: model.currentUser,
      //   home:model.navigateToHouseOverView,
      //   mebership: model.navigateToMembershipView,
      //   property: model.navigateToPropertyManageView,
      //   logout: model.logout
      // ),
      // body:SingleChildScrollView(
      //         child: Column(
      //           children: <Widget>[
      //            Container(
      //              margin: EdgeInsets.only(top:20, bottom:20),
      //              child: Center(
      //                child: Text('House picture Button Icon',
      //                     style: TextStyle(
      //                       color: Colors.black54,
      //                     ),
      //                ),
      //              ),
      //            ),
      //            Container(                 
      //              width: 100,
      //              height: 100,
      //              child: GestureDetector(
      //                   onTap: () => model.navigateToBigImageView(_postProperty.imageUrl),
      //                   child: Hero(
      //                   tag: _postProperty.imageUrl[0],
      //                   child: Container(    
      //                     child: ClipOval(
      //                       child: Image.network(_postProperty.imageUrl[0], fit: BoxFit.cover,))),
      //                   ),
      //                 ),
      //           ), 
      //          Container(
      //           child: ImformationWidget(postProperty: _postProperty)),
      //            Container(
      //              margin: EdgeInsets.only(top:10, bottom:10),
      //              child: Text('Google Map')
      //              ),
      //             Container(
      //               margin: EdgeInsets.only(bottom:10),
      //               height: 170,
      //               width: double.infinity,
      //               alignment: Alignment.center,
      //               decoration: BoxDecoration(
      //                 border: Border.all(width: 1, color: Colors.grey),
      //               ),
      //                       child: model.preview == null
      //               ? Text(
      //                   'No Location Chosen',
      //                   textAlign: TextAlign.center,
      //                 )
      //               : Image.network(
      //                   model.preview,
      //                   fit: BoxFit.cover,
      //                   width: double.infinity,
      //                 ),
      //             ),                  
      //      ],
      //     ),
      // ),       
      //  )



// Expanded(
//                flex: 2,
//               child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 4,
//               crossAxisSpacing: 1.0,
//               mainAxisSpacing: 1.0,
//               ),
//               itemCount: _postProperty.imageUrl.length,
//               itemBuilder: (ctx, i) => 
//                   GestureDetector(
//                     onTap: () => model.navigateToBigImageView(_postProperty.imageUrl, i),
//                     child: Hero(
//                     tag: _postProperty.imageUrl[i],
//                     child: Container(    
//                       child: ClipOval(child: Image.network(_postProperty.imageUrl[i], fit: BoxFit.cover,))),
//                     ),
//                   )
//                 ),
//               ),    


//  body: Column(
//          children: <Widget>[
//              Expanded(
//                flex: 5,
//               child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 1.0,
//               mainAxisSpacing: 1.0,
//               ),
//               itemCount: _postProperty.imageUrl.length,
//               itemBuilder: (ctx, i) => 
//                   GestureDetector(
//                     onTap: () => model.navigateToBigImageView(_postProperty.imageUrl, i),
//                     child: Hero(
//                     tag: _postProperty.imageUrl[i],
//                     child: Container(       
//                       child: Image.network(_postProperty.imageUrl[i], fit: BoxFit.cover,)),
//                     ),
//                   )
//                 ),
//               ),    
//               Expanded(
//               flex:7 ,
//                 child: Container(
//                     child: ConstrainedBox(
//                     constraints:BoxConstraints.expand(width: MediaQuery.of(context).size.width),
//                     child: DataTable( 
//                     columnSpacing: 0,  
//                     columns: [
//                       DataColumn(label: Text('Information Table')),
//                       DataColumn(label: Text('')),
//                     ],
//                     rows: [
//                         DataRow(cells: [
//                         DataCell(Text('title')),
//                         DataCell(Text(_postProperty.title)),
//                       ]),
//                       DataRow(cells: [
//                         DataCell(Text('City')),
//                         DataCell(Text(_postProperty.city)),
//                       ]),
//                         DataRow(cells: [
//                         DataCell(Text('Address')),
//                         DataCell(Text(_postProperty.address)),
//                       ]),
//                       DataRow(cells: [
//                         DataCell(Text('Name')),
//                         DataCell(Text(_postProperty.fullName)),
//                       ]),
//                       DataRow(cells: [
//                         DataCell(Text('Email')),
//                         DataCell(Text(_postProperty.email)),
//                       ]),
//                       DataRow(cells: [
//                         DataCell(Text(_postProperty.messenger)),
//                         DataCell(Text(_postProperty.messengerId)),
//                       ]),
//                        DataRow(cells: [
//                         DataCell(Text(_postProperty.message)),
//                          DataCell(Text('')),
//                       ]),
//                     ],
//                     ),
//                   ),
//                 ),
//               ),
//              Expanded(
//                 flex: 2,
//                 child: Container(
//                   color: Colors.white,
//                   child: Text('google Ads area'),
//                 ),
//               ),                        
//          ],
//         ),       