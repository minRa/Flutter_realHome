import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:realhome/models/postProperty.dart';

class CloudStorageService {

  // Save imageList from library
  List<File> _imageList;
  //image URL String list from Firebase storage.
  List<String> _imageStringList;

    Future<void> arrayImageFiles (Map<String,dynamic> imageData) async{
    List<File> _userImageList = List<File>();
    for (var i = 0; i <imageData.length ; i++) {
      print('image file is ${ imageData['image$i']}');
      if (imageData['image$i'] != null) {
        _userImageList.add(imageData['image$i']);
      }
    }
     _imageList = _userImageList;
     _imageStringList =List<String>.generate(_userImageList.length,(i) => '');
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
  Future<void> _uploadUserImages(File imageFile,String imageCount, int position, PostProperty po) async {
    try {  

      String userID = po.id;
      String fileName = 'images/$userID/${po.uuid}/$imageCount';//userID+imageCount;
      StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(imageFile);

      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      _imageStringList[position] = downloadUrl;
      _uploadImagePosition++;

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
}



// class CloudStorageResult {
//   final String imageUrl;
//   final String imageFileName;

//   CloudStorageResult({this.imageUrl, this.imageFileName});



//  Future<CloudStorageResult> uploadImage({
//     @required File imageToUpload,
//     @required String title,
//   }) async {
//     var imageFileName =
//         title + DateTime.now().millisecondsSinceEpoch.toString();

//     final StorageReference firebaseStorageRef =
//         FirebaseStorage.instance.ref().child(imageFileName);

//     StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
//     StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

//     var downloadUrl = await storageSnapshot.ref.getDownloadURL();

//     if (uploadTask.isComplete) {
//       var url = downloadUrl.toString();
//       return CloudStorageResult(
//         imageUrl: url,
//         imageFileName: imageFileName,
//       );
//     }

//     return null;
//   }

//   Future deleteImage(String imageFileName) async {
//     final StorageReference firebaseStorageRef =
//         FirebaseStorage.instance.ref().child(imageFileName);

//     try {
//       await firebaseStorageRef.delete();
//       return true;
//     } catch (e) {
//       return e.toString();
//     }
//   }





  // void _arrayImageFiles() {
  //   List<File> _userImageList = List<File>();
  //   for (var i = 0; i < 4; i++) {
  //     print('image file is ${ _userDataMap['image$i']}');
  //     if (_userDataMap['image$i'] != null) {
  //       _userImageList.add(_userDataMap['image$i']);
  //     }
  //   }
  //   _imageList = _userImageList;
  // }

  // Future<void> _signUpToFirebaseAuth() async {
  //   try {
  //     final FirebaseUser firebaseUser = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: _emailTextController.text,
  //         password: _passwordTextController.text
  //     )).user;
  //     _addUserImagesToFirebaseStorage(firebaseUser);
  //   }catch(e) {
  //     showDialogWithText(e.message);
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
//  int _uploadImagePosition = 0;
//   Future<void> _addUserImagesToFirebaseStorage(FirebaseUser firebaseUser) async {
//     try {
//       if (_imageList != null && _imageList.length > 0) {
//         _uploadUserImages(_imageList[_uploadImagePosition], firebaseUser.uid, 'image$_uploadImagePosition', _uploadImagePosition,firebaseUser);
//       }else {
//         _insertDataToLocalAndFirebaseDB(firebaseUser);
//       }
//     }catch(e) {
//       showDialogWithText(e.message);
//       setState(() {
//         isLoading = false;
//       });
//     }

//   }

//   bool isFinishedUpload = false;
//   Future<void> _uploadUserImages(File imageFile, String userID,String imageCount, int position, FirebaseUser firebaseUser) async {
//     try {
//       String fileName = 'images/$userID/$imageCount';//userID+imageCount;
//       StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
//       StorageUploadTask uploadTask = reference.putFile(imageFile);
//       StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
//       storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
//         _imageStringList[position] = downloadUrl;
//         _uploadImagePosition++;
//         if (_uploadImagePosition < _imageList.length) {
//           _uploadUserImages(_imageList[_uploadImagePosition], firebaseUser.uid, 'image$_uploadImagePosition', _uploadImagePosition,firebaseUser);
//         }else {
//           _insertDataToLocalAndFirebaseDB(firebaseUser);
//         }
//       }, onError: (err) {
//         setState(() {
//           showDialogWithText(err);
//           setState(() {
//             isLoading = false;
//           });
//         });
//       });
//     }catch(e) {
//       showDialogWithText(e.message);
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _insertDataToLocalAndFirebaseDB(FirebaseUser firebaseUser) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       if (firebaseUser != null) {
//         // Check is already sign up
//         final QuerySnapshot result =
//         await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
//         final List<DocumentSnapshot> documents = result.documents;
//         if (documents.length == 0) {
//           // Update data to server if new user
//           Firestore.instance.collection('users').document(firebaseUser.uid).setData({
//             'email': _emailTextController.text,
//             'password': _passwordTextController.text,
//             'name': _nameTextController.text,
//             'gender': _userDataMap['gender'],
//             'age': _userDataMap['age'],
//             'image0' : _imageStringList[0],
//             'image1' : _imageStringList[1],
//             'image2' : _imageStringList[2],
//             'image3' : _imageStringList[3],
//             'birth_year': _userDataMap['birth_year'],
//             'birth_month': _userDataMap['birth_month'],
//             'birth_day': _userDataMap['birth_day'],
//             'intro': _introduceTextController.text,
//             'id': firebaseUser.uid,
//             'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
//             'chattingWith': null
//           });

//           // Write data to local
//           currentUser = firebaseUser;
//           await prefs.setString('id', currentUser.uid);
//           await prefs.setString('email', _emailTextController.text);
//           await prefs.setString('password', _passwordTextController.text);
//           await prefs.setString('name', _nameTextController.text);
//           await prefs.setString('gender', _userDataMap['gender']);
//           await prefs.setInt('age', _userDataMap['age']);
//           await prefs.setString('image0', _imageStringList[0]);
//           await prefs.setString('image1', _imageStringList[1]);
//           await prefs.setString('image2', _imageStringList[2]);
//           await prefs.setString('image3', _imageStringList[3]);
//           await prefs.setInt('birth_year', _userDataMap['birth_year']);
//           await prefs.setInt('birth_month', _userDataMap['birth_month']);
//           await prefs.setInt('birth_day', _userDataMap['birth_day']);
//           await prefs.setString('intro',_introduceTextController.text);
//           await prefs.setString('createdAt', DateTime.now().millisecondsSinceEpoch.toString());
//         } else {
//           // Write Firebase data to local
//           await prefs.setString('id', documents[0]['id']);
//           await prefs.setString('email', documents[0]['email']);
//           await prefs.setString('password', documents[0]['password']);
//           await prefs.setString('name', documents[0]['name']);
//           await prefs.setString('gender', documents[0]['gender']);
//           await prefs.setInt('age', documents[0]['age']);
//           await prefs.setString('image0', documents[0]['image0']);
//           await prefs.setString('image1', documents[0]['image1']);
//           await prefs.setString('image2', documents[0]['image2']);
//           await prefs.setString('image3', documents[0]['image3']);
//           await prefs.setInt('birth_year', documents[0]['birth_year']);
//           await prefs.setInt('birth_month', documents[0]['birth_month']);
//           await prefs.setInt('birth_day', documents[0]['birth_day']);
//           await prefs.setString('intro', documents[0]['intro']);
//           await prefs.setString('createdAt', documents[0]['createdAt']);
//         }
//         setState(() {
//           isLoading = false;
//         });
//       } else {
//         showDialogWithText('Sign in fail');
//         setState(() {
//           isLoading = false;
//         });
//       }
//       await prefs.setBool('isLogin', true);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => UserScreen()),
//       );
//     }catch(e) {
//       showDialogWithText(e.message);
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

  // showDialogWithText(String textMessage) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           content: Text(textMessage),
  //         );
  //       }
  //   );
  // }










