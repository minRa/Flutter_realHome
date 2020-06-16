import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


class PickedImages extends StatefulWidget {
  PickedImages({
    this.multiImage,
  });
   final Function multiImage;
  @override
  State<StatefulWidget> createState() => _PickedImages();
}

class _PickedImages extends State<PickedImages>
 with AutomaticKeepAliveClientMixin<PickedImages> {

  
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  
  @override
  void initState() {

    super.initState();
  }

      Widget buildGridView() {
        return GridView.count(
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
            Asset asset = images[index];
            return AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            );
          }),
        );
      }

    Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
        resultList = await MultiImagePicker.pickImages(   
        maxImages: 9,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "upload image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),  
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      widget.multiImage(resultList);
      _error = error;
    });
  }

  @override
  void dispose() {
    images.clear();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              GestureDetector(
                onTap: loadAssets,
                child: Container(
                  child: Card(
                  margin: EdgeInsets.only(top:30, left: 50, right: 50, bottom: 10),
                  child: ListTile(
                  //contentPadding: EdgeInsets.only(right:0.0),
                  //leading: Icon(Icons.photo_library, size: 30,),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library, size: 30,),
                      SizedBox(width: 10,),
                      Text('Select Photo',
                      style: GoogleFonts.mcLaren(fontSize: MediaQuery.of(context).size.width <= 320 ? 20 :25), //TextStyle(fontSize: 26),
                      textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  subtitle: Text('Max : 9',
                  style: GoogleFonts.mcLaren(),
                  textAlign: TextAlign.center,
                  ),
                  ),),
                ),),
                  Expanded(
                    child: buildGridView(),
                  ),

                ],
             );
           }
  @override
  bool get wantKeepAlive => true;
}

