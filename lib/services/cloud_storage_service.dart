import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:realhome/models/postProperty.dart';
import 'package:uuid/uuid.dart';


class CloudStorageService {

  // Save imageList from library
  List<dynamic> _imageList;
  //image URL String list from Firebase storage.
  List<dynamic> _imageStringList;

    Future<void> arrayImageFiles (Map<String,dynamic> imageData) async{
    List<dynamic> _userImageList = List<dynamic>();
    for (var i = 0; i <9 ; i++) {
      print('image file is ${ imageData['image$i']}');
      if (imageData['image$i'] != null) {
        _userImageList.add(imageData['image$i']);
      }
    }
     _imageList = _userImageList;
     _imageStringList =List<dynamic>.generate(_userImageList.length,(i) => '');
  }
    var message=[];
    int _uploadImagePosition = 0;
    Future uploadPropertyImageToFirebaseStorage(PostProperty po) async {
    try {      
      if (_imageList != null && _imageList.length > 0) {
            return  await _uploadUserImages(_imageList[_uploadImagePosition], 'image$_uploadImagePosition', _uploadImagePosition, po);
        } else {
            return message =[' Post Failed !', 'Something went wrong, please ask owner!'];
        }
    }catch(e) {
       return message=['error', e.toString() ];
    }
  }

  //bool isFinishedUpload = false;
  Future<void> _uploadUserImages(dynamic imageFile,String imageCount, int position, PostProperty po) async {
    try {
      
      // if(imageFile is String) {
      // _imageStringList[position] = imageFile;
      // _uploadImagePosition++;    
      // } else if(imageFile is File) {
      String uuid = Uuid().v1();
      String fileName = 'images/${po.id}/${po.createdAt}/$imageCount - $uuid';//userID+imageCount;
      StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putData(imageFile);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      _imageStringList[position] = downloadUrl;
      _uploadImagePosition++;
   //   }

      if(_uploadImagePosition < _imageList.length)
         await _uploadUserImages(_imageList[_uploadImagePosition], 'image$_uploadImagePosition', _uploadImagePosition, po);
       else {
            _uploadImagePosition =0;
            po.imageUrl = _imageStringList;    
          }   

     } catch(e) {
       return message=['error', e.toString()];
   }
      return po;
  }

  Future<String> uploadUserProfileImage(String userId, File image, String type ) async {
    try {
    
      String fileName = 'userImage/$userId/$type';
      StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(image);

      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
       return downloadUrl;

    } catch (e) {
       return e.toString();
    }         
  }  

  Future deleteImageFileToFireStroage(List<dynamic> imageFileUrls) async {  
  try{ 
      for(var i=0; i<imageFileUrls.length; i++) {
         await imageDatadelete(imageFileUrls[i]);
    }
   
  } catch (e) {
     return e.toString();
  }
}

 Future imageDatadelete(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl)).replaceAll(new RegExp(r'(\?alt).*'), ''); 
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();
 }  
}












