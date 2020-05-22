import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/dataCenter.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';


class ChatRoomListModel extends BaseModel {

   final NavigationService _navigationService = 
   locator<NavigationService>();

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
          
        var result =   await _dataCenter.getStartForChatList();
         if(result) {
            _user =  _dataCenter.user;
            _message =_dataCenter.message;
            _peers = _dataCenter.peers;
         }

      _loading = false;
       notifyListeners();
      
 }


  void chatWith(int index) {
     _navigationService.navigateTo(ChatViewRoute, arguments:[_user, _peers[index]]);
  }
}


 


  