
import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/models/postProperty.dart';




class FirebaseMessageService {
  
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final NavigationService _navigationService = 
   locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();




  // Or do other work.

int counter = 0;

void registerNotification(String userId) {
   

    void _navigate(Map<String, dynamic> message) async {

      _googleAdsService.googleAdBan();
      if(counter == 1) {
           counter =0;
           return;
        } else {
        counter++;
      if(message['data']['route'] == 'DetailViewRoute') {
        String docId = message['data']['docId'].toString();
       var post = await   _firestoreService. getPostProperty(docId);    
        PostProperty _postProperty   =   PostProperty.fromMap(post.data, docId);

      _navigationService.navigateTo(DetailViewRoute,arguments: _postProperty);
  
      } else if (message['data']['route'] =='ChatViewRoute'){

         User _user = await _firestoreService.getUser(message['data']['argument1']);
         User _peer = await _firestoreService.getUser(message['data']['argument2']);
  
      _navigationService.navigateTo(ChatViewRoute, arguments:[_peer, _user]);

     }   
   }
    message.clear();
 }


   

  _firebaseMessaging.requestNotificationPermissions(
    IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true
      )
  );
  
   _firebaseMessaging.onIosSettingsRegistered.listen(
      (IosNotificationSettings settings) {
        print("Settings registered: $settings");
      }
    );



  _firebaseMessaging.configure(
    //onBackgroundMessage: myBackgroundMessageHandler,
    onMessage: (Map<String, dynamic> message) async {
    print('onMessage config: $message');
    
    Platform.isAndroid
        ? showNotification(message['notification'])
        : showNotification(message['aps']['alert']);

  }, 
  onResume: (Map<String, dynamic> message) async {
    print('onResume: $message');

    if(_authenticationService.currentUser != null) {
       _navigate(message);
    } else {
      _navigationService.navigateTo(InitialViewRoute);
    }

 

  }, onLaunch: (Map<String, dynamic> message) async{
        print('onLaunch: $message');
         
     if(_authenticationService.currentUser != null) {
       _navigate(message);
    } else {
      _navigationService.navigateTo(InitialViewRoute);
    }

  });


  _firebaseMessaging.getToken().then((token) {
   // print('token: $token');
    Firestore.instance
        .collection('users')
        .document(userId)
        .updateData({'pushToken': token});
  }).catchError((err) {
    Fluttertoast.showToast(msg: err.message.toString());
  });


   configLocalNotification();
}







  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.min.realhome'
          : 'com.min.realhome',
      'realHome',
      'Chat',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);

    await flutterLocalNotificationsPlugin
    .show(0, message['title'].toString(),
           message['body'].toString(),
           platformChannelSpecifics,
           payload: json.encode(message),);

    
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

}

