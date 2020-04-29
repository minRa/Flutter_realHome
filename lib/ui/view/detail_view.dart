import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/view_model/detail_view_model.dart';

class DetailView extends StatelessWidget {
  final PostProperty postProperty;
  DetailView(
    this.postProperty,
  );

  @override
  Widget build(BuildContext context) {
 final size = MediaQuery.of(context).size;
    final TextEditingController _textController = new TextEditingController();

    Future<void> _handleSubmitted(String text, User user) async {
      _textController.text = '';
      //int randomNumber = Random().nextInt(10000);
      //var randomID = 'ID${randomNumber}';
      var nowString = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';

      try {
        await Firestore.instance.collection('comments').document('${postProperty.documentId}')
        .collection('userComments').document('$nowString').setData({'content':text ,'userId':user.id, 'date':nowString,'fullName':user.fullName});
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
      onModelReady: (model) => model.googleMapPreview(postProperty) , 
      builder: (context, model, child) => Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('comments').document('${postProperty.documentId}').collection('userComments').snapshots(),
            builder: (context,snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    floating: true,
                    pinned: false,
                    snap: true,
                    flexibleSpace: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                            child: Stack(
                            children: <Widget>[
                              GestureDetector(
                                onTap:() => model.navigateToBigImageView(postProperty.imageUrl),
                                child: Hero(
                                  tag: postProperty.imageUrl[0],
                                  child: Image.network(postProperty.imageUrl[0],
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
                                       builder: (context) => detailDialog(context, postProperty),
                                       ),
                                      child: Center(
                                      child: Text( 'Rent Imformation',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Colors.white,
                                          textBaseline: TextBaseline.ideographic                                     
                                          ), ), ),),)),                             
                                    Positioned(
                                        top: 38,
                                        left: size.width - 70,
                                        child: Container(
                                          height: 28,
                                          width: 64,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.0),
                                              color: Colors.black,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                )
                                              ]
                                          ),
                                      child: Center(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8,right: 6, top: 3,bottom: 3),
                                              child: Icon(Icons.favorite,
                                                size: 24,
                                                color: Colors.red,),
                                            ),
                                            Text( '11',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                    Container(
                    margin: EdgeInsets.only(top:0, bottom:5),
                   // child: Text('Google Map')
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                      margin: EdgeInsets.only(bottom:10),
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                              child: model.preview == null
                      ? Text(
                          'No Location Chosen',
                          textAlign: TextAlign.center,
                        )
                      : Image.network(
                          model.preview,
                          fit: BoxFit.cover,
                          width: double.infinity,
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
                                  postProperty.documentId,
                                  snapshot.data.documents[index-1].data['userId'],
                                  snapshot.data.documents[index-1].data['date'],),
                                    child: ListTile(
                                    leading:
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
              );
            }
        )
      )
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
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
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
        DataColumn(label: Text('')),
      ],
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
          ),
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