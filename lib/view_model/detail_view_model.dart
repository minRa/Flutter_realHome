import 'package:realhome/locator.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/view_model/base_model.dart';

class DetailViewModel extends BaseModel {
 
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  String _preview;
  String get preview => _preview;
   final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
   googleMapPreview(PostProperty postProperty)  {  
    // _preview = GoogleMapService.generateLocationPreviewImage(
    //   latitude: postProperty.latitude,
    //   longitude: postProperty.longitude  
    // );
  }
  User _user ;

   getUser() {
    _user =   _authenticationService.currentUser;
    return  _user;
  }
  
  void commmentsDelete(String docId, String userId, String date) async {
       getUser();
      if(_user != null && _user.id == userId) {

        var dialogResponse = await _dialogService.showConfirmationDialog(
                title: 'Delete your comments',
                description: 'would you like to delete this comments  ?',
                confirmationTitle: 'OK',
                cancelTitle: 'CANCEL'        
              );
        
        if(dialogResponse.confirmed) {   
             await _firestoreService.commentDelete(docId, date);
        } 
      }
  }
}