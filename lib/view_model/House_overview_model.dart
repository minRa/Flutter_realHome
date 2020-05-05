
import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';
import 'package:realhome/services/googleAds_service.dart';
const adUnitId = 'ca-app-pub-7333672372977808/8753848294';

class HouseOverviewModel extends BaseModel {
  
  final FirestoreService _firestoreService = locator<FirestoreService>();
   final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();
   final NavigationService _navigationService = 
   locator<NavigationService>();
 

  bool data;
  List<PostProperty> _postProperty;
  List<PostProperty> get postProperty => _postProperty;
  // List<User> _userList;
  // List<User> get userList => _userList;

  List<String> _cities;
  List<String> get cities => _cities;
  bool finish;
  updateCity(String city) {
      var post =_postProperty.singleWhere((c) => c.city == city);
       print(post);


  }
   
   

  Future<void> listenToPosts() async {  
        
        await _googleAdsService.bottomBanner(adUnitId);   
         data = false;
        await getCities();     
        _firestoreService.listenToPostPropertyRealTime().listen((postsData) {
        List<PostProperty> updatedPosts = postsData;
        if (updatedPosts != null && updatedPosts.length > 0) {
          _postProperty = updatedPosts; 
          notifyListeners();
        //  data = true;
          }});
      
        if(data == false) {
            _postProperty =  _firestoreService.allPropertyPagedResults[0]; 
            notifyListeners();
        } 
        setBusy(false);
        // notifyListeners();
  }
  

   Future<void> getCities() async {
          print('i am GOGING ====================>!!!!!!!!!!!!!!!');

        List<PostProperty> posts = await  _firestoreService.getPropertyListFromFirebase('All City', 'All Type');
        _cities = List<String>.generate(posts.length + 1, (i)=>'');
        if(posts.length > 0) {    
          _cities[0] ='All City';
          for(var i =0; i<posts.length; i++) {
          if(_cities.contains(posts[i].city)) continue;
          _cities[i+ 1] = posts[i].city;
        } 
        for(var i=0; i< _cities.length; i++){
            if(_cities.contains(''))
             _cities.remove('');
        } 

        notifyListeners();   
      }
   }
    

    Future<void> updatePostCodition(String city, String type) async{
       _postProperty = await _firestoreService.getPropertyListFromFirebase(city, type);
        notifyListeners();
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



     
   
