import 'package:flutter/material.dart';

class BigImageView extends StatelessWidget {
  
  final dynamic data;
  BigImageView({this.data});

  @override
  Widget build(BuildContext context) {   
    //  List<String> items;
      //  items.add(data[0][data[1]]);
      //  print(items.length);
      // data[0].removeAt(data[1]);
      // for(var imageUrl in data[0])
      //   items = imageUrl;
    // return ListView.builder(
    //        itemCount: items.length ,
    //        scrollDirection: Axis.horizontal,
    //        itemBuilder: (ctx, i) =>
           return GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Hero(
              tag:data[0][data[1]],
              child: Container(
                width: 64.0,
                height: 64.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image:  DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(data[0][data[1]])
                  )
        )),
      //),
    ),
           );
  }
}