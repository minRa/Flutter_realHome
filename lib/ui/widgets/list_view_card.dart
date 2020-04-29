import 'package:flutter/material.dart';
import 'package:realhome/models/postProperty.dart';



class ListViewCard extends StatelessWidget {
  final bool onAuth;
  //final int index;
 // final Key key;
 // final Function navigate;
  final Function edit;
  final Function delete;
  final PostProperty userProperty;

  ListViewCard({
    this.onAuth,
    this.edit,
    this.delete,
    this.userProperty, 
   // this.index, this.key, 
    //this.navigate
    });
  @override
  Widget build(BuildContext context) {
    return Card(
    margin: EdgeInsets.only(top:10, bottom:10, left:20, right:20),
    color: Colors.white,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top:10.0,right: 20, left: 20),
                alignment: Alignment.topLeft,
                child: Text(
                  '${userProperty.title}',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.left,
                  maxLines: 5,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.topLeft,
                child: Text(
                  '${userProperty.city} - ${userProperty.price}',
                  style: TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 16),
                  textAlign: TextAlign.left,
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ),
         !onAuth ? SizedBox()
        :Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: IconButton(
            icon:Icon(Icons.edit, size: 24.0,),
            color: Colors.blueGrey,
            onPressed: edit,                   
          )),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: IconButton(
            icon:Icon(Icons.close, size: 24.0,),
            color: Colors.blueGrey,
            onPressed: delete,                   
          )),
      ],
    ),
      );
  }
}
