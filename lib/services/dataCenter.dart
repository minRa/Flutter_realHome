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

  set oldUserData(User currentUser) => _oldUser = currentUser;
  set peerData(List<User> peers ) => _peers = peers;
  set messageData(List<Message> list) => _message = list;

  //  void oldUserData(User currentUser) {
  //   _oldUser = currentUser;
  // }

  





  











} 