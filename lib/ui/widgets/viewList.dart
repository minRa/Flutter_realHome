import 'package:flutter/material.dart';

List<dynamic> items =[
 Colors.red,
 Colors.blue,
 Colors.green,
 Colors.yellow,
 Colors.orange,
];

class VerticalList extends StatelessWidget {

   final Function onTap;
   VerticalList({this.onTap});
   @override
    Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, i) => HorizontalList(onTap: onTap,),
      itemCount: 5,
   );
  }
}


class HorizontalList extends StatelessWidget {
  
  final Function onTap;
  HorizontalList ({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: 200.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (ctx, i) => Container (
          width: 200,
          color: items[i],
          )    
        ),
      ),
    );
  }
}




