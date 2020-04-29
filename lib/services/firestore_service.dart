import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/cloud_storage_service.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
   final CloudStorageService _cloudStorageService = locator<CloudStorageService>();

  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  // final CollectionReference _postsCollectionReference =
  //     Firestore.instance.collection('posts');

  final CollectionReference _postPropertyCollectionReference =
  Firestore.instance.collection('PostProperties');

    final CollectionReference _commentsCollectionReference =
  Firestore.instance.collection('comments');
  
  
  // final StreamController<List<Post>> _postsController =
  //     StreamController<List<Post>>.broadcast();

  final StreamController<List<PostProperty>> _postPropertyController =
      StreamController<List<PostProperty>>.broadcast();

  List<List<PostProperty>> _allPropertyPagedResults = List<List<PostProperty>>();
  List<List<PostProperty>> get allPropertyPagedResults => _allPropertyPagedResults;
  static const int PostPropertyLimit = 5;


  // #6: Create a list that will keep the paged results
  //List<List<Post>> _allPagedResults = List<List<Post>>();

  //static const int PostsLimit = 20;

  DocumentSnapshot _lastDocument;
  bool _hasMorePosts = true;

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      // Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      return User.fromData(userData.data); // userData.data != null ? User.fromData(userData.data): null;
    } catch (e) {
      // Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  } 

  var message =[];
  Future postHouseIntoFirebase(PostProperty po) async { 
        final QuerySnapshot result =
      await _postPropertyCollectionReference.where('id', isEqualTo: po.id).getDocuments();
      if(result.documents.length >= 2 && po.documentId == null) {
          return message =[' Post Failed !', 'Sorry, you can\'t post more than 3 at this time'];           
      }  
      var post = await _cloudStorageService.uploadPropertyImageToFirebaseStorage(po); 

       if(po.documentId != null){
          return await _updateDataToFirebaseDB(post);
     } else {
           return await _insertDataToFirebaseDB(post);
    }   
  }

 Future commentDelete(String docId, String date) async {
   await _commentsCollectionReference.document(docId)
          .collection('userComments')
          .document(date).delete();
   }
 
  // Future uploadImageData(File image, int index, User user) async {
  //     String imageStringUrl = await _cloudStorageService.uploadPostPropertyImage(user, index, image);
  //     if(imageStringUrl != null) {
  //       return imageStringUrl;
  //     }else {
  //       print('error ocurred !');
  //       return null;
  //     }     
  // }

  Future imageDataDelete(String imageUrl, String documentId) async {  
         await _postPropertyCollectionReference.document(documentId)
          .updateData({
             'imageUrl':FieldValue.arrayRemove([imageUrl]) 
          });       
  }


  
  Future<void> _updateDataToFirebaseDB(PostProperty post) async {
    try {     
     // SharedPreferences prefs = await SharedPreferences.getInstance(); 
      if (post.id != null) {
          // Update data to server if new user
          await _postPropertyCollectionReference.document(post.documentId)
          .updateData(post.toMap());   
         }
       }catch (e) {
         return message=['Error', e.toString()] ;
     }
      return message=['Update completed successfully', 'Your rent house updated in List :)'];
  }
   



  Future<void> _insertDataToFirebaseDB(PostProperty post) async {
    try {     
           print('i am doing Insert !!!!!!!!!!!!!!!!!!!!!!!!!');
     // SharedPreferences prefs = await SharedPreferences.getInstance(); 
      if (post.id != null) {
          // Update data to server if new user
          await _postPropertyCollectionReference.add(post.toMap());
          await _usersCollectionReference.document(post.id).updateData({
          });        
         }
       }catch (e) {
         return message=['Error', e.toString()] ;
     }
      return message=['Post completed successfully', 'Your rent house posted in List :)'];
  }


  Future updateUserImage(User user, File image) async{      
   QuerySnapshot userResult =  await _usersCollectionReference.where('id',isEqualTo: user.id).getDocuments();
     if(userResult.documents.length > 0) {
        String imageUrl = await _cloudStorageService.uploadUserProfileImage(user.id, image);
      if(imageUrl != null) {
            await _usersCollectionReference.document(user.id).updateData({
             'profileUrl': imageUrl
        });
      }     
     } else {
       return null;
     }
  }
  
  Future deleteUserPostPropertyToFirebaseDB(User user, PostProperty property) async {    
       QuerySnapshot userPostProperty = await _postPropertyCollectionReference.where('id',isEqualTo: user.id).getDocuments();
       if(userPostProperty.documents.length != 0) {
             await _postPropertyCollectionReference.document(property.documentId).delete()
             .catchError((err) =>{
     
             });
              _cloudStorageService.deleteImageFileToFireStroage(property.imageUrl)
             .catchError((err) => {
        });
       } else {
          return message=['Warning', 'your rent house is already deleted!']; 
       }
       return message=['Deleted successfully', 'Your rent house deleted in Rent House List :)'];
}
  



  Stream listenToPostPropertyRealTime() {
    // Register the handler for when the posts data changes
    _requestPostProperty();
    return _postPropertyController.stream;
  }

  // #1: Move the request posts into it's own function
  void _requestPostProperty() {
    // #2: split the query from the actual subscription
    var pagePostsQuery = _postPropertyCollectionReference
        .orderBy('createdAt')
        // #3: Limit the amount of results
        .limit(PostPropertyLimit);


    // #5: If we have a document start the query after it
    if (_lastDocument != null) {
      pagePostsQuery = pagePostsQuery.startAfterDocument(_lastDocument);
    }

    if (!_hasMorePosts) return;
    // #7: Get and store the page index that the results belong to

    var currentRequestIndex = _allPropertyPagedResults.length;

  
    pagePostsQuery.snapshots().listen((postsSnapshot) {
      if (postsSnapshot.documents.isNotEmpty) {
        var posts = postsSnapshot.documents
            .map((snapshot) => PostProperty.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.title != null)
            .toList();

        // #8: Check if the page exists or not
        var pageExists = currentRequestIndex < _allPropertyPagedResults.length;
    
        // #9: If the page exists update the posts for that page
        if (pageExists) {
          _allPropertyPagedResults[currentRequestIndex] = posts;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allPropertyPagedResults.add(posts);
        }

        // #11: Concatenate the full list to be shown
        var allPosts = _allPropertyPagedResults.fold<List<PostProperty>>(List<PostProperty>(),
            (initialValue, pageItems) => initialValue..addAll(pageItems));
  
        // #12: Broadcase all posts
        _postPropertyController.add(allPosts);
         
        // #13: Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allPropertyPagedResults.length - 1) {
          _lastDocument = postsSnapshot.documents.last;
        }
        // #14: Determine if there's more posts to request
        _hasMorePosts = posts.length == PostPropertyLimit;
      }
    });
  }



Future getUserPropertyListFromFirebase(User user) async {
  try {
    var postPropertyDocumentSnapshot =
            await _postPropertyCollectionReference
        //   .where('id', isEqualTo: user.id)
            .orderBy('createdAt')
            .getDocuments();        
        if (postPropertyDocumentSnapshot.documents.isNotEmpty) {

          return postPropertyDocumentSnapshot.documents
              .map((snapshot) => PostProperty.fromMap(snapshot.data, snapshot.documentID))
              .where((mappedItem) => mappedItem.id == user.id)
              .toList();
        }
      } catch (e) {
        // Find or create a way to repeat error handling without so much repeated code
        if (e is PlatformException) {
          return e.message;
        }
        return e.toString();
      }
}

   void requestMoreData() => _requestPostProperty();
}


//////////////////////////////////////////////////////////////////

  // Future addPost(Post post) async {
  //   try {
  //     await _postsCollectionReference.add(post.toMap());
  //   } catch (e) {
  //     // Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }

  //     return e.toString();
  //   }
  // }

  // Future getPostsOnceOff() async {
  //   try {
  //     var postDocumentSnapshot =
  //         await _postsCollectionReference.limit(PostsLimit).getDocuments();
  //     if (postDocumentSnapshot.documents.isNotEmpty) {
  //       return postDocumentSnapshot.documents
  //           .map((snapshot) => Post.fromMap(snapshot.data, snapshot.documentID))
  //           .where((mappedItem) => mappedItem.title != null)
  //           .toList();
  //     }
  //   } catch (e) {
  //     // Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }

  //     return e.toString();
  //   }
  // }

  // Stream listenToPostsRealTime() {
  //   // Register the handler for when the posts data changes
  //   _requestPosts();
  //   return _postsController.stream;
  // }

  // // #1: Move the request posts into it's own function
  // void _requestPosts() {
  //   // #2: split the query from the actual subscription
  //   var pagePostsQuery = _postsCollectionReference
  //       .orderBy('title')
  //       // #3: Limit the amount of results
  //       .limit(PostsLimit);

  //   // #5: If we have a document start the query after it
  //   if (_lastDocument != null) {
  //     pagePostsQuery = pagePostsQuery.startAfterDocument(_lastDocument);
  //   }

  //   if (!_hasMorePosts) return;

  //   // #7: Get and store the page index that the results belong to
  //   var currentRequestIndex = _allPagedResults.length;

  //   pagePostsQuery.snapshots().listen((postsSnapshot) {
  //     if (postsSnapshot.documents.isNotEmpty) {
  //       var posts = postsSnapshot.documents
  //           .map((snapshot) => Post.fromMap(snapshot.data, snapshot.documentID))
  //           .where((mappedItem) => mappedItem.title != null)
  //           .toList();

  //       // #8: Check if the page exists or not
  //       var pageExists = currentRequestIndex < _allPagedResults.length;

  //       // #9: If the page exists update the posts for that page
  //       if (pageExists) {
  //         _allPagedResults[currentRequestIndex] = posts;
  //       }
  //       // #10: If the page doesn't exist add the page data
  //       else {
  //         _allPagedResults.add(posts);
  //       }

  //       // #11: Concatenate the full list to be shown
  //       var allPosts = _allPagedResults.fold<List<Post>>(List<Post>(),
  //           (initialValue, pageItems) => initialValue..addAll(pageItems));

  //       // #12: Broadcase all posts
  //       _postsController.add(allPosts);

  //       // #13: Save the last document from the results only if it's the current last page
  //       if (currentRequestIndex == _allPagedResults.length - 1) {
  //         _lastDocument = postsSnapshot.documents.last;
  //       }

  //       // #14: Determine if there's more posts to request
  //       _hasMorePosts = posts.length == PostsLimit;
  //     }
  //   });
  // }

  // Future deletePost(String documentId) async {
  //   await _postsCollectionReference.document(documentId).delete();
  // }

  // Future updatePost(Post post) async {
  //   try {
  //     await _postsCollectionReference
  //         .document(post.documentId)
  //         .updateData(post.toMap());
  //   } catch (e) {
  //     // TODO: Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }

  //     return e.toString();
  //   }
  // }

  // void requestMoreData() => _requestPosts();

