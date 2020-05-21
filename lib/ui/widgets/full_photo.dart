import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

final themeColor = Color(0xfff5a623);
final primaryColor = Color(0xff203152);
final greyColor = Color(0xffaeaeae);
final greyColor2 = Color(0xffE8E8E8);


class FullPhoto extends StatelessWidget {
  final String url;

  FullPhoto({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          'Photo',
           style: GoogleFonts.mcLaren(),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: new FullPhotoScreen(url: url),
    );
  }
}

class FullPhotoScreen extends StatelessWidget {
  final String url;
  FullPhotoScreen( {@required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
          child: PhotoView(
          backgroundDecoration: BoxDecoration(
            color: Colors.white
          ),
          imageProvider: NetworkImage(url,)),
    );
  }
}
