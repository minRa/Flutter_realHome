import 'package:flutter/material.dart';
import 'package:realhome/providers/image_provider.dart';

class DetailImage extends StatelessWidget {
  static const id ='/image';

  @override
  Widget build(BuildContext context) {
     ImageItem arge =  ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: GestureDetector(
        child:Center(
          child: Hero(
            tag: 'image_${arge.id}',
            child: Container(
              child: Image.memory(arge.image, 
              fit:BoxFit.cover),
            ),
          )
          ),
           onTap: () {
             Navigator.pop(context);
           },
        ),
      );   
  }
}