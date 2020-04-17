import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:realhome/screens/Detail.dart';

class OverviewListTile extends StatelessWidget {


  final Uint8List image;
  
 OverviewListTile({ this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(Detail.id);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        width: 200,
        child:Image.memory(image, fit: BoxFit.cover,) ,
      ),
    );
  }
}