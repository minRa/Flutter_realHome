
import 'package:realhome/locator.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/firebase_message_service.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/view_model/base_model.dart';

class StartPageViewModel extends BaseModel {
  
final AuthenticationService _authenticationService = locator<AuthenticationService>();
 
final FirestoreService _firestoreService = locator<FirestoreService>();
final FirebaseMessageService _firebaseMessageService =
   locator<FirebaseMessageService>();
     
    void init() {   
       var user = _authenticationService.currentUser;         
     _firebaseMessageService.registerNotification(user.id);
     _firestoreService.chattingWithClear(user.id);
       
    }



}