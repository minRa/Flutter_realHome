import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/dataCenter.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';


class ChatRoomListModel extends BaseModel {

   final NavigationService _navigationService = 
   locator<NavigationService>();
   
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  final DataCenter _dataCenter = locator<DataCenter>();

    List<dynamic> _message;
    List<dynamic> get message => _message;
    bool _loading = false;
    bool get loading => _loading ;
    User _user;
    User get user => _user;
    List<User> _peers = List<User>();
    List<User> get peers => _peers;
    User peer ;

    Future<void> getAllUserIformation() async {


         _loading = true;
          notifyListeners();
         await getStartForChatList();
        _loading = false;
        notifyListeners();
      
 }


 Future<bool> getStartForChatList() async {       
      try {
       await _authenticationService.isUserLoggedIn();
         if(_authenticationService.currentUser == null) {
          return false;
         }

          _user =_authenticationService.currentUser;                
          var result = _dataCenter.oldUser.chattings.toString().compareTo(_user.chattings.toString()) == 0;

          if(result && _dataCenter.message != null && _dataCenter.peers != null) {
             _user = _dataCenter.oldUser;
             _message = _dataCenter.message;
             _peers = _dataCenter.peers;
             return true;
          }
          else {
            
            _dataCenter.oldUserData =_user;
            var result =  await  _firestoreService.tryFindMessageRoom(_user);

            if(result == null) {
              return false;
            } else {
              await Future.forEach(result, (element) async {
                if(element.idFrom == _user.id) {
                  peer = await _firestoreService.getUser(element.idTo);  
                  _peers.add(peer);       //_users.singleWhere((e) => e.id == element[0].idTo );
                } else {
                  peer = await _firestoreService.getUser(element.idFrom);   
                  _peers.add(peer);       //_users.singleWhere((e) => e.id == element[0].idFrom );
                }              
              }); 
             _dataCenter.messageData = result;
             _dataCenter.peerData = _peers;
             _message = result;
               return true;       
            }
           } 
          } catch (e) {
              print(e.toString());
              return false;
      }
   }


  void chatWith(int index) {
     _navigationService.navigateTo(ChatViewRoute, arguments:[_user, _peers[index]]);
  }
}


 


  