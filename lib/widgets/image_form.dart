import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:realhome/providers/image_provider.dart';
import 'package:realhome/screens/detail_Image.dart';

class ImageForm extends StatelessWidget {

  final Uint8List image;
  final int id;
  ImageForm({this.id, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          child: Hero(
            tag: 'image_$id',
            child: Image.memory(image, fit:BoxFit.cover)),
             onTap: () {
            Navigator.of(context).pushNamed(DetailImage.id, arguments: ImageItem(id: id, image: image));
          },   
    );
  }
}