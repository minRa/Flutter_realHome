import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/services/dialog_service.dart';


class PickedImages extends StatefulWidget {
  PickedImages(this.parentAction);
  final ValueChanged<List<dynamic>> parentAction;

  @override
  State<StatefulWidget> createState() => _PickedImages();
}

class _PickedImages extends State<PickedImages>
 with AutomaticKeepAliveClientMixin<PickedImages> {

  DialogService _dialogService = locator<DialogService>();
  int _imagePosition = 0; 
  List<File> _imageList = List<File>.generate(8,(file) => File(''));
  bool addPicture1 = false;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
        padding: const EdgeInsets.only(bottom:0.0),
        child: SingleChildScrollView(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                  Align(
                  alignment: Alignment.topCenter,
                  child: Text('Select your photos',
                  style: TextStyle(fontSize: 26),),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new GestureDetector(
                          onTap: () {
                            _imagePosition = 0;
                            _getImage();
                          },
                          onLongPress: () {
                            _remove(0);
                          },
                          child: Container(
                            width: 160,
                            height: 160,
                            child:Card(
                              child: (_imageList[0].path != '')
                                  ? Image.file(_imageList[0],fit: BoxFit.fill,)
                                  : Icon(Icons.add_photo_alternate,
                              size: 130,color: Colors.grey[700])
                          ),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new GestureDetector(
                          onTap: () {
                          _imagePosition =1;
                            _getImage();
                          },
                           onLongPress: () {
                             _remove(1);
                          },
                          child: Container(
                            width: 160,
                            height: 160,
                            child:Card(
                                child: (_imageList[1].path != '')
                                    ? Image.file(_imageList[1],fit: BoxFit.fill,)
                                    : Icon(Icons.add_photo_alternate,
                                    size: 130,color: Colors.grey[700])
                            ),),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new GestureDetector(
                        onTap: () {
                         _imagePosition =2;
                          _getImage();
                        },
                         onLongPress: () {
                           _remove(2);
                          },
                        child: Container(
                          width: 160,
                          height: 160,
                          child:Card(
                            child: (_imageList[2].path != '')
                                ? Image.file(_imageList[2],fit: BoxFit.fill,)
                                : Icon(Icons.add_photo_alternate,
                                size: 130,color: Colors.grey[700])
                          ),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new GestureDetector(
                        onTap: () {
                        _imagePosition =3;
                          _getImage();
                        },
                         onLongPress: () {
                            _remove(3);
                          },
                        child: Container(
                          width: 160,
                          height: 160,
                          child:Card(
                            child: (_imageList[3].path != '')
                                ? Image.file(_imageList[3],fit: BoxFit.fill,)
                                : Icon(Icons.add_photo_alternate,
                                size: 130,color: Colors.grey[700])
                          ),),
                      ),
                    ),
                  ],
                ),

                Container(
                padding: EdgeInsets.only(right: 300),
                child: IconButton(
                  icon: addPicture1? Icon(Icons.minimize) : Icon(Icons.add_circle_outline),                 
                  onPressed: () {
                    setState(() {
                      addPicture1 = !addPicture1;
                        //if(addePicture2) addPicture2 = !addPicture2;
                      });
                    },
                  ),
                ),

                Visibility(
                visible: addPicture1 ,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {     
                                _imagePosition =4;              
                                _getImage();
                              },
                               onLongPress: () {
                               _remove(4);
                                },
                              child: Container(
                                width: 160,
                                height: 160,
                                child:Card(
                                  child: (_imageList[4].path != '')
                                      ? Image.file(_imageList[4],fit: BoxFit.fill,)
                                      : Icon(Icons.add_photo_alternate,
                                      size: 130,color: Colors.grey[700])
                                ),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {
                              _imagePosition =5;
                                _getImage();
                              },
                               onLongPress: () {
                                  _remove(5);
                                },
                              child: Container(
                                width: 160,
                                height: 160,
                                child:Card(
                                  child: (_imageList[5].path != '')
                                      ? Image.file(_imageList[5],fit: BoxFit.fill,)
                                      : Icon(Icons.add_photo_alternate,
                                      size: 130,color: Colors.grey[700])
                                ),),
                            ),
                          ),
                        ],
                      ),

                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {    
                                _imagePosition =6;               
                                _getImage();
                              },
                               onLongPress: () {
                               _remove(6);
                                },
                              child: Container(
                                width: 160,
                                height: 160,
                                child:Card(
                                  child: (_imageList[6].path != '')
                                      ? Image.file(_imageList[6],fit: BoxFit.fill,)
                                      : Icon(Icons.add_photo_alternate,
                                      size: 130,color: Colors.grey[700])
                                ),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {
                               _imagePosition =7;
                                _getImage();
                              },
                               onLongPress: () {
                                  _remove(7);
                                },
                              child: Container(
                                width: 160,
                                height: 160,
                                child:Card(
                                  child: (_imageList[7].path != '')
                                      ? Image.file(_imageList[7],fit: BoxFit.fill,)
                                      : Icon(Icons.add_photo_alternate,
                                      size: 130,color: Colors.grey[700])
                                ),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),               
            ],
          ),
        ),
    );
  }

  void _saveDataAndPassToParent(String key, dynamic value) {
    List<dynamic> addData = List<dynamic>();
    addData.add(key);
    addData.add(value);
    widget.parentAction(addData);
  }


    Future<void> _remove(int poistion) async {

      var dialogResponse = await _dialogService.showConfirmationDialog(
          title: 'Remove Image',
          description: 'would you like to Remove this image ?',
          confirmationTitle: 'OK',
          cancelTitle: 'CANCEL'        
        );
    
    if(dialogResponse.confirmed) {
      List<dynamic> addData = List<dynamic>();
        addData.add("remove");
        addData.add("image$poistion");
        widget.parentAction(addData);
        setState(() {
            _imageList.removeAt(poistion);
        });     
    }       
  }


  Future _getImage() async {
    // Get image from gallery.
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _cropImage(image);
  }

  Future<Null> _cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue[800],
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
            title: 'Cropper',
        ));

    if (croppedFile != null) {
      setState(() {
        _saveDataAndPassToParent('image$_imagePosition',croppedFile);
        _imageList[_imagePosition]= croppedFile;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}