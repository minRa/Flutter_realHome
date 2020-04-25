
import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/postProperty.dart';
// import 'package:realhome/services/cloud_storage_service.dart';
// import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';

class HouseOverviewModel extends BaseModel {
  
  final FirestoreService _firestoreService = locator<FirestoreService>();
  // final DialogService _dialogService = locator<DialogService>();
  // final CloudStorageService _cloudStorageService =
  //     locator<CloudStorageService>();
   final NavigationService _navigationService = 
   locator<NavigationService>();

  bool data = false;
  List<PostProperty> _postProperty;
  List<PostProperty> get postProperty => _postProperty;


    Future<void> listenToPosts() async {
       setBusy(true);
          //await initialGoogleAds ();
        _firestoreService.listenToPostPropertyRealTime().listen((postsData) {
        List<PostProperty> updatedPosts = postsData;
        if (updatedPosts != null && updatedPosts.length > 0) {
           data = true;
          _postProperty = updatedPosts;
          notifyListeners();
        } 
        setBusy(false);
      });
       if(data == false) {
          _postProperty = _firestoreService.allPropertyPagedResults[0];
            notifyListeners();
       }
       data = false;
    }

      navigateToDetailView(int index) {
    _navigationService.navigateTo(
      DetailViewRoute, arguments: _postProperty[index]);
    }


    void requestMoreData() => _firestoreService.requestMoreData();
  }



  // Future deletePost(int index) async {
  //   var dialogResponse = await _dialogService.showConfirmationDialog(
  //     title: 'Are you sure?',
  //     description: 'Do you really want to delete the post?',
  //     confirmationTitle: 'Yes',
  //     cancelTitle: 'No',
  //   );

  //   if (dialogResponse.confirmed) {
  //     var postToDelete = _postProperty[index];
  //     setBusy(true);
  //     await _firestoreService.deletePost(postToDelete.documentId);
  //     // Delete the image after the post is deleted
  //     await _cloudStorageService.deleteImage(postToDelete.imageFileName);
  //     setBusy(false);
  //   }
  // }

    // Future navigateToCreateView() async {
    //   await _navigationService.navigateTo(CreatePostViewRoute);
    // }

    // void editPost(int index) {
    //   _navigationService.navigateTo(CreatePostViewRoute,
    //       arguments: _posts[index]);
    // }



     
   
