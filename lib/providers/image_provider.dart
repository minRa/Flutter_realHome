import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class ImageItem {
  
   final Uint8List image;  
   final int id;
   ImageItem({this.id, this.image});

}

class ImageFiles with ChangeNotifier {


   List<ImageItem> _image =[];
   StorageReference storage = FirebaseStorage.instance.ref().child('photos');
   
   Future<void> getImage() async{
     int maxSize = 7*1024*1024;

    for(int i =0; i< 4; i++) {
     storage.child('Capture$i.JPG').getData(maxSize)
     .then((data) {
      _image.add(ImageItem(id: i, image: data));
        notifyListeners();
       
     }).catchError((onError){
       throw(onError);
     });
    }
   }

    List<ImageItem> get images {
    return _image;
  }
}