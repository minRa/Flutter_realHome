import 'package:flutter/material.dart';
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
        title: new Text(
          'FULL PHOTO',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: new FullPhotoScreen(url: url),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;

  FullPhotoScreen({Key key, @required this.url}) : super(key: key);

  @override
  State createState() => new FullPhotoScreenState(url: url);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;

  FullPhotoScreenState({Key key, @required this.url});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: PhotoView(imageProvider: NetworkImage(url)));
  }
}
