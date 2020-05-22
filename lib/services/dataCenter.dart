
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/firestore_service.dart';
//import 'package:realhome/services/navigation_service.dart';

class DataCenter {


  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  //final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();


    bool _initData = false;
    bool get initData => _initData;
   

    List<dynamic> _message;
    List<dynamic> get message => _message;
    User _user;
    User get user => _user;
    List<User> _peers = List<User>();
    List<User> get peers => _peers;
    User peer ;
    User _oldUser;

  initStart(User currentUser)  async {
      _oldUser = currentUser;
   //  await getStartForChatList();
  }





  Future<bool> getStartForChatList() async {
            
      try {
       await _authenticationService.isUserLoggedIn();
         if(_authenticationService.currentUser == null) {
          return false;
         }
         _user =_authenticationService.currentUser;    

         if(_message != null 
            && _message.length >0 
            && _peers!= null
            && _peers.length >0
            ) {              
          var result =  _oldUser.chattings.toString().compareTo(_user.chattings.toString()) == 0;
          if(result) return true;
          else {
                 _peers.clear();
                _message.clear();
                _oldUser = _user;
               }
            }
        var result =  await  _firestoreService.tryFindMessageRoom(_user);

        if(result == null) {
          print(result);
          return false;
        } else {
          _message = result;
         await Future.forEach(result, (element) async {
           if(element.idFrom == _user.id) {
             peer = await _firestoreService.getUser(element.idTo);  
            _peers.add(peer);       //_users.singleWhere((e) => e.id == element[0].idTo );
           } else {
             peer = await _firestoreService.getUser(element.idFrom);   
            _peers.add(peer);       //_users.singleWhere((e) => e.id == element[0].idFrom );
           }
      
          }); 
          return true;       
        }
      } catch (e) {
          print(e.toString());
          return false;
      }

   }











} 