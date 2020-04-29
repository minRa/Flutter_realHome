import 'dart:io';
import 'package:flutter/material.dart';


class PickedImages extends StatefulWidget {
  PickedImages({
    this.imageUrl,
    this.imageUpload,
    this.cropImage,
    this.remove
  });
  final Function imageUpload;
  final Function remove;
  final Function cropImage;
  final List<dynamic> imageUrl;

  @override
  State<StatefulWidget> createState() => _PickedImages();
}

class _PickedImages extends State<PickedImages>
 with AutomaticKeepAliveClientMixin<PickedImages> {

  List<File> fileImages = List<File>.generate(8,(file) => File(''));
  List<dynamic> imageUrl = List<String>.generate(8,(i) => '');

  bool addPicture1 = false;

  @override
  void initState() {
     if(widget.imageUrl != null) {
        setState(() {
          imageUrl = widget.imageUrl;
        });
     }
    super.initState();
  }

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
                          onTap: () async{
                                File fileImage = await widget.cropImage();
                                widget.imageUpload(fileImage, 0);                       
                               setState(() {   
                               fileImages[0] = fileImage;        
                            });
                          },
                          onLongPress: () async {
                            if(fileImages[0].path != '' || imageUrl[0] !=''){
                                 bool ok =  await widget.remove(0);
                                 if(ok) {
                                  setState((){
                                  fileImages[0]= File('');
                                  imageUrl[0] = '';
                                }); 
                              } 
                            }
                          },
                        child: Container(
                            width: 160,
                            height: 160,
                            child: Card(
                              child:fileImages != null && fileImages.length >= 1 && fileImages[0].path !=''?
                              Image.file(fileImages[0],fit: BoxFit.fill,) :
                              imageUrl != null && imageUrl.length >= 1 && imageUrl[0] !=''?
                                    Image.network(imageUrl[0],fit: BoxFit.fill)
                                  : Icon(Icons.add_photo_alternate,
                              size: 130,color: Colors.grey[700])
                          ),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new GestureDetector(
                          onTap: () async{
                                File fileImage = await widget.cropImage();
                                widget.imageUpload(fileImage, 1);                       
                               setState(() {   
                               fileImages[1] = fileImage;        
                            });
                          },
                          onLongPress: () async {
                            if(fileImages[1].path != '' || imageUrl[1] !=''){
                                 bool ok =  await widget.remove(1);
                                 if(ok) {
                                  setState((){
                                  fileImages[1]= File('');
                                  imageUrl[1] = '';
                                }); 
                              } 
                            }
                          },
                        child: Container(
                            width: 160,
                            height: 160,
                            child: Card(
                              child:fileImages != null && fileImages.length >= 2 && fileImages[1].path !=''?
                              Image.file(fileImages[1],fit: BoxFit.fill,) :
                              imageUrl != null && imageUrl.length >= 1 && imageUrl[1] !=''?
                                    Image.network(imageUrl[1],fit: BoxFit.fill)
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
                          onTap: () async{
                                File fileImage = await widget.cropImage();
                                widget.imageUpload(fileImage, 2);                       
                               setState(() {   
                               fileImages[2] = fileImage;        
                            });
                          },
                          onLongPress: () async {
                            if(fileImages[2].path != '' || imageUrl[2] !=''){
                                 bool ok =  await widget.remove(2);
                                 if(ok) {
                                  setState((){
                                  fileImages[2]= File('');
                                  imageUrl[2] = '';
                                }); 
                              } 
                            }
                          },
                        child: Container(
                            width: 160,
                            height: 160,
                            child: Card(
                              child:fileImages != null && fileImages.length >= 3 && fileImages[2].path !=''?
                              Image.file(fileImages[2],fit: BoxFit.fill,) :
                              imageUrl != null && imageUrl.length >= 1 && imageUrl[2] !=''?
                                    Image.network(imageUrl[2],fit: BoxFit.fill)
                                  : Icon(Icons.add_photo_alternate,
                              size: 130,color: Colors.grey[700])
                          ),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new GestureDetector(
                        onTap: () async{
                                File fileImage = await widget.cropImage();
                                widget.imageUpload(fileImage, 3);                       
                               setState(() {   
                               fileImages[3] = fileImage;        
                            });
                          },
                          onLongPress: () async {
                            if(fileImages[3].path != '' || imageUrl[3] !=''){
                                 bool ok =  await widget.remove(3);
                                 if(ok) {
                                  setState((){
                                  fileImages[3]= File('');
                                  imageUrl[3] = '';
                                }); 
                              } 
                            }
                          },
                        child: Container(
                            width: 160,
                            height: 160,
                            child: Card(
                              child:fileImages != null && fileImages.length >= 4 && fileImages[3].path !=''?
                              Image.file(fileImages[3],fit: BoxFit.fill,) :
                              imageUrl != null && imageUrl.length >= 1 && imageUrl[3] !=''?
                                    Image.network(imageUrl[3],fit: BoxFit.fill)
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
                                onTap: () async{
                                File fileImage = await widget.cropImage();
                                widget.imageUpload(fileImage, 4);                       
                               setState(() {   
                               fileImages[4] = fileImage;        
                            });
                          },
                          onLongPress: () async {
                            if(fileImages[4].path != '' || imageUrl[4] !=''){
                                 bool ok =  await widget.remove(4);
                                 if(ok) {
                                  setState((){
                                  fileImages[4]= File('');
                                  imageUrl[4] = '';
                                }); 
                              } 
                            }
                          },
                        child: Container(
                            width: 160,
                            height: 160,
                            child: Card(
                              child:fileImages != null && fileImages.length >= 5 && fileImages[4].path !=''?
                              Image.file(fileImages[4],fit: BoxFit.fill,) :
                              imageUrl != null && imageUrl.length >= 1 && imageUrl[4] !=''?
                                    Image.network(imageUrl[4],fit: BoxFit.fill)
                                  : Icon(Icons.add_photo_alternate,
                              size: 130,color: Colors.grey[700])
                          ),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                               onTap: () async{
                                File fileImage = await widget.cropImage();
                                widget.imageUpload(fileImage, 5);                       
                               setState(() {   
                               fileImages[5] = fileImage;        
                            });
                          },
                          onLongPress: () async {
                            if(fileImages[5].path != '' || imageUrl[5] !=''){
                                 bool ok =  await widget.remove(5);
                                 if(ok) {
                                  setState((){
                                  fileImages[5]= File('');
                                  imageUrl[5] = '';
                                }); 
                              } 
                            }
                          },
                        child: Container(
                            width: 160,
                            height: 160,
                            child: Card(
                              child:fileImages != null && fileImages.length >= 6 && fileImages[5].path !=''?
                              Image.file(fileImages[5],fit: BoxFit.fill,) :
                              imageUrl != null && imageUrl.length >= 1 && imageUrl[5] !=''?
                                    Image.network(imageUrl[5],fit: BoxFit.fill)
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
                             onTap: () async{
                                File fileImage = await widget.cropImage();
                                widget.imageUpload(fileImage, 6);                       
                               setState(() {   
                               fileImages[6] = fileImage;        
                            });
                          },
                          onLongPress: () async {
                            if(fileImages[6].path != '' || imageUrl[6] !=''){
                                 bool ok =  await widget.remove(6);
                                 if(ok) {
                                  setState((){
                                  fileImages[6]= File('');
                                  imageUrl[6] = '';
                                }); 
                              } 
                            }
                          },
                        child: Container(
                            width: 160,
                            height: 160,
                            child: Card(
                              child:fileImages != null && fileImages.length >= 7 && fileImages[6].path !=''?
                              Image.file(fileImages[6],fit: BoxFit.fill,) :
                              imageUrl != null && imageUrl.length >= 1 && imageUrl[6] !=''?
                                    Image.network(imageUrl[6],fit: BoxFit.fill)
                                  : Icon(Icons.add_photo_alternate,
                              size: 130,color: Colors.grey[700])
                          ),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                            onTap: () async{
                                File fileImage = await widget.cropImage();
                                widget.imageUpload(fileImage, 7);                       
                               setState(() {   
                               fileImages[7] = fileImage;        
                            });
                          },
                          onLongPress: () async {
                            if(fileImages[7].path != '' || imageUrl[7] !=''){
                                 bool ok =  await widget.remove(7);
                                 if(ok) {
                                  setState((){
                                  fileImages[7]= File('');
                                  imageUrl[7] = '';
                                }); 
                              } 
                            }
                          },
                        child: Container(
                            width: 160,
                            height: 160,
                            child: Card(
                              child:fileImages != null && fileImages.length >= 8 && fileImages[7].path !=''?
                              Image.file(fileImages[7],fit: BoxFit.fill,) :
                              imageUrl != null && imageUrl.length >= 1 && imageUrl[7] !=''?
                                    Image.network(imageUrl[7],fit: BoxFit.fill)
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

  // void _saveDataAndPassToParent(String key, dynamic value) {
  //   List<dynamic> addData = List<dynamic>();
  //   addData.add(key);
  //   addData.add(value);
  //   widget.parentAction(addData);
  // }


  

  // Future _getImage() async {
  //   // Get image from gallery.
  //   File image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   _cropImage(image);
  // }

  // Future<Null> _cropImage(File image) async {
  //   File croppedFile = await ImageCropper.cropImage(
  //       sourcePath: image.path,
  //       aspectRatioPresets: Platform.isAndroid
  //           ? [
  //         CropAspectRatioPreset.square,
  //         CropAspectRatioPreset.ratio3x2,
  //         CropAspectRatioPreset.original,
  //         CropAspectRatioPreset.ratio4x3,
  //         CropAspectRatioPreset.ratio16x9
  //       ]
  //           : [
  //         CropAspectRatioPreset.original,
  //         CropAspectRatioPreset.square,
  //         CropAspectRatioPreset.ratio3x2,
  //         CropAspectRatioPreset.ratio4x3,
  //         CropAspectRatioPreset.ratio5x3,
  //         CropAspectRatioPreset.ratio5x4,
  //         CropAspectRatioPreset.ratio7x5,
  //         CropAspectRatioPreset.ratio16x9
  //       ],
  //       androidUiSettings: AndroidUiSettings(
  //           toolbarTitle: 'Cropper',
  //           toolbarColor: Colors.blue[800],
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.original,
  //           lockAspectRatio: false),
  //       iosUiSettings: IOSUiSettings(
  //           title: 'Cropper',
  //       ));

  //   if (croppedFile != null) {
  //     setState(() {
  //       _saveDataAndPassToParent('image$_imagePosition',croppedFile);
  //       _imageList[_imagePosition]= croppedFile;
  //     });
  //   }
  // }

  @override
  bool get wantKeepAlive => true;
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:realhome/locator.dart';
// import 'package:realhome/services/dialog_service.dart';


// class PickedImages extends StatefulWidget {
//   PickedImages(
//     this.imageUrl,
//     this.parentAction
//     );
//   final ValueChanged<List<dynamic>> parentAction;
//   final List<dynamic> imageUrl;

//   @override
//   State<StatefulWidget> createState() => _PickedImages();
// }

// class _PickedImages extends State<PickedImages>
//  with AutomaticKeepAliveClientMixin<PickedImages> {

//   DialogService _dialogService = locator<DialogService>();
//   int _imagePosition = 0; 
//   List<File> _imageList = List<File>.generate(8,(file) => File(''));
//   bool addPicture1 = false;


//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Padding(
//         padding: const EdgeInsets.only(bottom:0.0),
//         child: SingleChildScrollView(
//                   child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                   Align(
//                   alignment: Alignment.topCenter,
//                   child: Text('Select your photos',
//                   style: TextStyle(fontSize: 26),),
//                 ),
//                 Container(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: new GestureDetector(
//                           onTap: () {
//                             _imagePosition = 0;
//                             _getImage();
//                           },
//                           onLongPress: () {
//                             _remove(0);
//                           },
//                           child: Container(
//                             width: 160,
//                             height: 160,
//                             child:Card(
//                               child:(_imageList[0].path == '') && widget.imageUrl.length >= 1 && widget.imageUrl[0] !=null ?
//                                     Image.network(widget.imageUrl[0],fit: BoxFit.fill)
//                                   : (_imageList[0].path != '')
//                                   ? Image.file(_imageList[0],fit: BoxFit.fill,)
//                                   : Icon(Icons.add_photo_alternate,
//                               size: 130,color: Colors.grey[700])
//                           ),),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: new GestureDetector(
//                           onTap: () {
//                           _imagePosition =1;
//                             _getImage();
//                           },
//                            onLongPress: () {
//                              _remove(1);
//                           },
//                           child: Container(
//                             width: 160,
//                             height: 160,
//                             child:Card(
//                                 child:(_imageList[1].path == '') && widget.imageUrl.length >= 2 && widget.imageUrl[1] !=null ?
//                                     Image.network(widget.imageUrl[1],fit: BoxFit.fill)
//                                      :(_imageList[1].path != '')
//                                     ? Image.file(_imageList[1],fit: BoxFit.fill,)
//                                     : Icon(Icons.add_photo_alternate,
//                                     size: 130,color: Colors.grey[700])
//                             ),),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: new GestureDetector(
//                         onTap: () {
//                          _imagePosition =2;
//                           _getImage();
//                         },
//                          onLongPress: () {
//                            _remove(2);
//                           },
//                         child: Container(
//                           width: 160,
//                           height: 160,
//                           child:Card(
//                             child:(_imageList[2].path == '') && widget.imageUrl.length >= 3 && widget.imageUrl[2] !=null ?
//                                   Image.network(widget.imageUrl[2],fit: BoxFit.fill)
//                                 : (_imageList[2].path != '')
//                                 ? Image.file(_imageList[2],fit: BoxFit.fill,)
//                                 : Icon(Icons.add_photo_alternate,
//                                 size: 130,color: Colors.grey[700])
//                           ),),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: new GestureDetector(
//                         onTap: () {
//                         _imagePosition =3;
//                           _getImage();
//                         },
//                          onLongPress: () {
//                             _remove(3);
//                           },
//                         child: Container(
//                           width: 160,
//                           height: 160,
//                           child:Card(
//                             child: (_imageList[3].path == '') && widget.imageUrl.length >= 4 && widget.imageUrl[3] !=null ?
//                                    Image.network(widget.imageUrl[3],fit: BoxFit.fill)
//                                  :(_imageList[3].path != '')
//                                 ? Image.file(_imageList[3],fit: BoxFit.fill,)
//                                 : Icon(Icons.add_photo_alternate,
//                                 size: 130,color: Colors.grey[700])
//                           ),),
//                       ),
//                     ),
//                   ],
//                 ),

//                 Container(
//                 padding: EdgeInsets.only(right: 300),
//                 child: IconButton(
//                   icon: addPicture1? Icon(Icons.minimize) : Icon(Icons.add_circle_outline),                 
//                   onPressed: () {
//                     setState(() {
//                       addPicture1 = !addPicture1;
//                         //if(addePicture2) addPicture2 = !addPicture2;
//                       });
//                     },
//                   ),
//                 ),

//                 Visibility(
//                 visible: addPicture1 ,
//                   child: Column(
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: new GestureDetector(
//                               onTap: () {     
//                                 _imagePosition =4;              
//                                 _getImage();
//                               },
//                                onLongPress: () {
//                                _remove(4);
//                                 },
//                               child: Container(
//                                 width: 160,
//                                 height: 160,
//                                 child:Card(
//                                   child:(_imageList[4].path == '') && widget.imageUrl.length >= 5 &&  widget.imageUrl[4] !=null ?
//                                       Image.network(widget.imageUrl[4],fit: BoxFit.fill)
//                                       :(_imageList[4].path != '')
//                                       ? Image.file(_imageList[4],fit: BoxFit.fill,)
//                                       : Icon(Icons.add_photo_alternate,
//                                       size: 130,color: Colors.grey[700])
//                                 ),),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: new GestureDetector(
//                               onTap: () {
//                               _imagePosition =5;
//                                 _getImage();
//                               },
//                                onLongPress: () {
//                                   _remove(5);
//                                 },
//                               child: Container(
//                                 width: 160,
//                                 height: 160,
//                                 child:Card(
//                                   child:(_imageList[5].path == '') && widget.imageUrl.length >= 6 && widget.imageUrl[5] !=null ?
//                                          Image.network(widget.imageUrl[5],fit: BoxFit.fill)
//                                       :(_imageList[5].path != '')
//                                       ? Image.file(_imageList[5],fit: BoxFit.fill,)
//                                       : Icon(Icons.add_photo_alternate,
//                                       size: 130,color: Colors.grey[700])
//                                 ),),
//                             ),
//                           ),
//                         ],
//                       ),

//                        Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: new GestureDetector(
//                               onTap: () {    
//                                 _imagePosition =6;               
//                                 _getImage();
//                               },
//                                onLongPress: () {
//                                _remove(6);
//                                 },
//                               child: Container(
//                                 width: 160,
//                                 height: 160,
//                                 child:Card(
//                                   child:(_imageList[6].path == '') && widget.imageUrl.length >= 7 && widget.imageUrl[6] !=null ?
//                                        Image.network(widget.imageUrl[6],fit: BoxFit.fill)
//                                       :(_imageList[6].path != '')
//                                       ? Image.file(_imageList[6],fit: BoxFit.fill,)
//                                       : Icon(Icons.add_photo_alternate,
//                                       size: 130,color: Colors.grey[700])
//                                 ),),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: new GestureDetector(
//                               onTap: () {
//                                _imagePosition =7;
//                                 _getImage();
//                               },
//                                onLongPress: () {
//                                   _remove(7);
//                                 },
//                               child: Container(
//                                 width: 160,
//                                 height: 160,
//                                 child:Card(
//                                   child:(_imageList[7].path == '') && widget.imageUrl.length >= 8 && widget.imageUrl[7] !=null ?
//                                     Image.network(widget.imageUrl[7],fit: BoxFit.fill)
//                                       :(_imageList[7].path != '')
//                                       ? Image.file(_imageList[7],fit: BoxFit.fill,)
//                                       : Icon(Icons.add_photo_alternate,
//                                       size: 130,color: Colors.grey[700])
//                                 ),),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),               
//             ],
//           ),
//         ),
//     );
//   }

//   void _saveDataAndPassToParent(String key, dynamic value) {
//     List<dynamic> addData = List<dynamic>();
//     addData.add(key);
//     addData.add(value);
//     widget.parentAction(addData);
//   }


//     Future<void> _remove(int poistion) async {

//       var dialogResponse = await _dialogService.showConfirmationDialog(
//           title: 'Remove Image',
//           description: 'would you like to Remove this image ?',
//           confirmationTitle: 'OK',
//           cancelTitle: 'CANCEL'        
//         );
    
//     if(dialogResponse.confirmed) {
//       List<dynamic> addData = List<dynamic>();
//         addData.add("remove");
//         addData.add("image$poistion");
//         widget.parentAction(addData);
//         setState(() {
//             _imageList.removeAt(poistion);
//         });     
//     }       
//   }


//   Future _getImage() async {
//     // Get image from gallery.
//     File image = await ImagePicker.pickImage(source: ImageSource.gallery);
//     _cropImage(image);
//   }

//   Future<Null> _cropImage(File image) async {
//     File croppedFile = await ImageCropper.cropImage(
//         sourcePath: image.path,
//         aspectRatioPresets: Platform.isAndroid
//             ? [
//           CropAspectRatioPreset.square,
//           CropAspectRatioPreset.ratio3x2,
//           CropAspectRatioPreset.original,
//           CropAspectRatioPreset.ratio4x3,
//           CropAspectRatioPreset.ratio16x9
//         ]
//             : [
//           CropAspectRatioPreset.original,
//           CropAspectRatioPreset.square,
//           CropAspectRatioPreset.ratio3x2,
//           CropAspectRatioPreset.ratio4x3,
//           CropAspectRatioPreset.ratio5x3,
//           CropAspectRatioPreset.ratio5x4,
//           CropAspectRatioPreset.ratio7x5,
//           CropAspectRatioPreset.ratio16x9
//         ],
//         androidUiSettings: AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: Colors.blue[800],
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false),
//         iosUiSettings: IOSUiSettings(
//             title: 'Cropper',
//         ));

//     if (croppedFile != null) {
//       setState(() {
//         _saveDataAndPassToParent('image$_imagePosition',croppedFile);
//         _imageList[_imagePosition]= croppedFile;
//       });
//     }
//   }

//   @override
//   bool get wantKeepAlive => true;
// }