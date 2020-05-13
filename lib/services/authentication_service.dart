
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/firestore_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  User _currentUser;
  User get currentUser => _currentUser;

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      await _firebaseAuth.signOut();
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user);
      
      return currentUser != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
    @required String role,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      _currentUser = User(
        id: authResult.user.uid,
        email: email,
        fullName: fullName,
        userRole: role,
      );

      await _firestoreService.createUser(_currentUser).catchError((e) 
      => print(e.toString()));

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }


    final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],);

  Future googleSignUp() async {
    try {     
      await _googleSignIn.signOut();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      _currentUser = User(
            id: user.uid,
            email: user.email,
            fullName: user.displayName,
            userRole: 'User',
          );

      await _firestoreService.createUser(_currentUser);
       await _populateCurrentUser(user);

      return user != null;
    }catch (e) {
      print(e.message);
    }
  }

  var facebookLogin = new FacebookLogin();
  Future signUpWithFacebook() async{
    try {
      
      await facebookLogin.logOut();
      var result = await facebookLogin.logIn(['email']);

      if(result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,

        );
        final FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;
        print('signed in ' + user.displayName);
          _currentUser = User(
            id: user.uid,
            email: user.email,
            fullName: user.displayName,
            userRole: 'User',
          );

         await _firestoreService.createUser(_currentUser);
        await _populateCurrentUser(user);
        return user != null;
      }
    }catch (e) {
      print(e.message);
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    await _populateCurrentUser(user);
      
    return _currentUser != null;
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {    
         var result  = await _firestoreService.getUser(user.uid);   
         if(result is String) {
            _currentUser = null; // errro
             
         } else {  
           _currentUser = result;
        }
    }
  }
 

  Future logOut () async  {
    _currentUser = null;
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();    
    await facebookLogin.logOut();
  }

}
