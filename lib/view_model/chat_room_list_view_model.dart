 import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/message.dart';
 import 'package:realhome/models/user.dart';
 import 'package:realhome/services/authentication_service.dart';
// import 'package:realhome/services/dialog_service.dart';
 import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/services/navigation_service.dart';
// import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';


class ChatRoomListModel extends BaseModel {

   final NavigationService _navigationService = 
   locator<NavigationService>();
 
   final AuthenticationService _authenticationService = locator<AuthenticationService>();
//   String _preview;
//   String get preview => _preview;
    final FirestoreService _firestoreService = locator<FirestoreService>();
//     final DialogService _dialogService = locator<DialogService>();

    List<List<Message>> _message;
    List<List<Message>> get message => _message;
    bool _loading = false;
    bool get loading => _loading ;
    List<User> _users;
    List<User> get users =>_users;
    User _user;
    User get user => _user;
    List<User> _peers = List<User>();
    List<User> get peers => _peers;
    User peer ;

    Future<void> getAllUserIformation() async {
      
        _loading = true;
      //_owner.profileUrl ='string';
       notifyListeners();
        _users= await _firestoreService.getUserList();
         await _authenticationService.isUserLoggedIn();
         if(_authenticationService.currentUser == null) {
         _loading = false;
         notifyListeners();
          return;
         }

        _user= _authenticationService.currentUser;
        var result =  await  _firestoreService.tryFindMessageRoom(_user);
         

        if(result is String) {
          print(result);
        } else {
          _message = result;
         await Future.forEach(result, (element) {
           if(element[0].idFrom == _user.id) {
             peer = _users.singleWhere((e) => e.id ==element[0].idTo );
            _peers.add(peer);
           } else {
             peer = _users.singleWhere((e) => e.id ==element[0].idFrom );
            _peers.add(peer);
           }
          });
        }

       // await _googleAdsService.bottomBanner(); 

    //   await  _firestoreService.getUserList().then((data) {
    //     _owner = data.singleWhere((id) => id.id == postProperty.id);
    // });
    //  _owner = await users.singleWhere((id) => id.id == postProperty.id);
   // _owner = poster.profileUrl;
      _loading = false;
       notifyListeners();
    //await  googleMapPreview(postProperty);
 }


  //        void navigateToPostOwnerInfoView(User  user) {
  //  _navigationService.navigateTo(PostOwnerInfoViewRoute, arguments: user);
  // }

  void chatWith(int index) {
     _navigationService.navigateTo(ChatViewRoute, arguments:[_user, _peers[index]]);
  }


 


  

  //  Future googleMapPreview(PostProperty postProperty) async  {  
  //   _preview = GoogleMapServices.generateLocationPreviewImage(
  //     latitude: postProperty.latitude,
  //     longitude: postProperty.longitude  
  //   );
  // }



  // User _user ;

  //  getUser() {
  //   _user =   _authenticationService.currentUser;
  //   return  _user;
  // }
  
  // void commmentsDelete(String docId, String userId, String date) async {
  //      getUser();
  //     if(_user != null && _user.id == userId) {

  //       var dialogResponse = await _dialogService.showConfirmationDialog(
  //               title: 'Delete your comments',
  //               description: 'would you like to delete this comments  ?',
  //               confirmationTitle: 'OK',
  //               cancelTitle: 'CANCEL'        
  //             );
        
  //       if(dialogResponse.confirmed) {   
  //            await _firestoreService.commentDelete(docId, date);
  //       } 
  //     }
  // }

  
}