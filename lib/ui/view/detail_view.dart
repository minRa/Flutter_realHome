import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/ui/widgets/app_drawer.dart';
import 'package:realhome/view_model/detail_view_model.dart';

class DetailView extends StatelessWidget {

  final PostProperty _postProperty;
  DetailView(this._postProperty);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<DetailViewModel>.withConsumer(
      viewModel: DetailViewModel(),    
      //onModelReady: (model) => model.initialGoogleAds() , 
      builder: (context, model, child) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Rent House Detail'),
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
      body: Column(
         children: <Widget>[
             Expanded(
               flex: 2,
              child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 1.0,
              ),
              itemCount: _postProperty.imageUrl.length,
              itemBuilder: (ctx, i) => 
                  GestureDetector(
                    onTap: () => model.navigateToBigImageView(_postProperty.imageUrl, i),
                    child: Hero(
                    tag: _postProperty.imageUrl[i],
                    child: Container(    
                      child: Image.network(_postProperty.imageUrl[i], fit: BoxFit.cover,)),
                    ),
                  )
                ),
              ),    
              Expanded(
              flex:12 ,
              child: ImformationWidget(postProperty: _postProperty)),
               Expanded(
                flex: 3,
                child: Container(
                  color: Colors.white,
                  child: Text('google Ads area'),
                ),
              ),                        
         ],
        ),       
       )
    );
  }
}

class ImformationWidget extends StatelessWidget {
  const ImformationWidget({
    Key key,
    @required PostProperty postProperty,
  }) : _postProperty = postProperty, super(key: key);

  final PostProperty _postProperty;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
      width: double.infinity,
      child: DataTable( 
      columnSpacing: 0, 
      dataRowHeight: 30, 
      columns: [
        DataColumn(label: Text('Information Table')),
        DataColumn(label: Text('')),
      ],
      rows: [
          DataRow(cells: [
          DataCell(Text('title')),
          DataCell(Text(_postProperty.title)),
        ]),
        DataRow(cells: [
          DataCell(Text('City')),
          DataCell(Text(_postProperty.city)),
        ]),
          DataRow(cells: [
          DataCell(Text('Address')),
          DataCell(Text(_postProperty.address)),
        ]),
          DataRow(cells: [
          DataCell(Text('Price')),
          DataCell(Text(_postProperty.price)),
        ]),
        DataRow(cells: [
          DataCell(Text('Name')),
          DataCell(Text(_postProperty.fullName)),
        ]),
        DataRow(cells: [
          DataCell(Text('Email')),
          DataCell(Text(_postProperty.email)),
        ]),
        DataRow(cells: [
          DataCell(Text('messenger')),
          DataCell(Text(_postProperty.messenger)),
        ]),
           DataRow(cells: [
          DataCell(Text('Phone')),
          DataCell(Text(_postProperty.phone)),
        ]),
         DataRow(cells: [
          DataCell(Text(_postProperty.message)),
           DataCell(Text('')),
        ]),
      ],
      ),
  ),
    );
  }
}




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