import 'package:flutter/material.dart';
import 'package:realhome/models/postProperty.dart';

List<dynamic> items =[
 Colors.red,
 Colors.blue,
 Colors.green,
 Colors.yellow,
 Colors.orange,
];

class HorizontalList extends StatelessWidget {
  
  final PostProperty post;
  HorizontalList (this.post);
   
  @override
  Widget build(BuildContext context) {
    
    return  Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: 200.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: post.imageUrl.length,
          itemBuilder: (ctx, i) => Container (
          width: 200,
          child: 
           Image.network(post.imageUrl[i], fit: BoxFit.cover)    
        ),    
      )  
    );
  }
}




