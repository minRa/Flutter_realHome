import 'package:realhome/models/message.dart';
import 'package:realhome/models/user.dart';


class DataCenter {


  List<dynamic> _message;
  List<dynamic> get message => _message;
  List<User> _peers;
  List<User> get peers => _peers;
  User peer ;
  User _oldUser;
  User get oldUser => _oldUser;

   void oldUserData(User currentUser) => _oldUser = currentUser;
   void peerData(List<User> peers ) => _peers = peers;
   void messageData(List<Message> list) => _message = list;

  //  void oldUserData(User currentUser) {
  //   _oldUser = currentUser;
  // }

  





  











} 