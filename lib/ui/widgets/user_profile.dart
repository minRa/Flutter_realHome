import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:realhome/models/postProperty.dart';
import 'package:realhome/models/user.dart';

class UserProfilePage extends StatelessWidget {
  final bool onAuth;
  final bool guest;
  final bool onLoading;
  final Function navigate;
  final User user;
  final Function editImage;
  final Function editBackground;
  final Function goToChatRoom;

  UserProfilePage({
    this.guest,
    this.navigate,
    this.user,
    this.onAuth,
    this.editImage,
    this.editBackground,
    this.onLoading,
    this.goToChatRoom
  });

  Widget _buildCoverImage(BuildContext context, Size screenSize) {
    return Container(
    height: screenSize.height / 1.6,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: //user!= null?
         user.backgroundUrl !=null?
         NetworkImage(user.backgroundUrl)
         :AssetImage('assets/images/cover.jpg') ,
        fit: BoxFit.cover,
      ),
    ),
  );
 }

  Widget _buildProfileImage(BuildContext context, User user) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap:() {
            if(user.profileUrl != null) {
              showDialog(
              context: context,
              builder: (context) => detailDialog(context, user));
            }               
          },
          child: Hero (
            tag: 'profile',
            child: Center(
            child: Container(
              width: 130.0,
              height: 130.0,
              decoration: BoxDecoration(
               image:DecorationImage(
                  image:
                  user.profileUrl != null?
                  NetworkImage(user.profileUrl)
                  : AssetImage('assets/images/avata.png') ,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(80.0),
                border: Border.all(
                  color: Colors.white,
                  width: 10.0,
                    ),
                  ),
                ),
               ),
              ),
            ),
      ],
    );
  }

  Widget _buildFullName() {
    return Text(
      user.fullName,
      textAlign: TextAlign.center,
      style:GoogleFonts.mcLaren(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.black  ),
    );
  }


  Widget _buildGetInTouch(BuildContext context) {
    return Container(
      color: Colors.white,  //Theme.of(context).scaffoldBackgroundColor,
      child: Text(
        user.email,
        textAlign: TextAlign.center,
        style: GoogleFonts.mcLaren(fontSize: 16,fontWeight: FontWeight.w700 ),
      ),
    );
  }

 

  @override
  Widget build(BuildContext context) {
    Size screenSize = onAuth ?
      MediaQuery.of(context).size/ 2.65
    :MediaQuery.of(context).size/2;
    return SafeArea(
        child: Scaffold(
        backgroundColor: Colors.white,
        body: onLoading ?
        Center(child: CircularProgressIndicator()):
        Stack(
          children: <Widget>[
            _buildCoverImage(context, screenSize),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                 // onAuth?
                 // SizedBox(height: screenSize.height / 3.6):

                  SizedBox(height: screenSize.height / 3.0),
                  _buildProfileImage(context, user),
                  ListTile(
                    //contentPadding: EdgeInsets.only(left:40),
                    leading:  IconButton(
                      tooltip: 'Home',
                      icon: Icon(Icons.home,
                      color: Colors.blueGrey,
                      size: 28,
                      ),
                      onPressed: () =>navigate(0),
                    ),
                    title: _buildFullName(),
                    subtitle: _buildGetInTouch(context),
                    trailing:
                     onAuth ?
                    IconButton(
                    icon: Icon(Icons.photo_library,size: 28,),
                    color: Colors.blueGrey,
                    onPressed: () {
                    showDialog(
                    context: context,
                    builder: (context) => editDialog(context, editImage, editBackground));
                    //.then((_) => Navigator.of(context).pop());
                      }):
                     guest? SizedBox(
                      width: 43,
                     ):
                     Container(
                      padding:EdgeInsets.only(bottom: 20),
                      child: IconButton(
                          tooltip: 'Chat',
                          icon: Icon(Icons.chat,
                          color: Colors.blueGrey,),
                          onPressed:() {
                             showDialog(
                             context: context,
                             builder: (context) => chatDialog(context, user, goToChatRoom));
                          } 
                        ),
                    ), 
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Widget editDialog(BuildContext context, 
Function profile, Function background) {
  return Container(
    padding: EdgeInsets.only(left: 50, right: 50),
    child: SimpleDialog(
        contentPadding: EdgeInsets.zero,
        children: [
          Column(
            children: <Widget>[
              GestureDetector(
                onTap:() async{
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                   await profile();
                } ,
                  child: Container(
                  margin:EdgeInsets.only(top:15, bottom: 10) ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.person),
                      SizedBox(width: 10,),
                      Text('Edit profile')
                    ],
                  ),
                ),
              ),
               GestureDetector(
                 onTap: () async{
                   Navigator.of(context, rootNavigator: true).pop('dialog');
                   await background();
                } ,
                  child: Container(
                  margin:EdgeInsets.only(top:5, bottom: 10) ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.photo),
                      SizedBox(width: 10,),
                      Text('Edit Background')
                    ],
                  ),
              ),
               ),
            ],)
         ]
       ),
  );
}


Widget chatDialog(BuildContext context, User owner, Function goToChatRoom,) {
  //ThemeData localTheme = Theme.of(context);
  return Container(
    //padding: EdgeInsets.only(left: 30, right: 30),
    child: SimpleDialog(
        contentPadding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onTap://() =>  goToChatRoom(owner)
            () async{
               Navigator.of(context).pop();
               goToChatRoom(owner);},
              child: Container(
              margin:EdgeInsets.only(top:15, bottom: 10) ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.person),
                  SizedBox(width: 10,),
                  Text('Chat with ${owner.fullName}',
                  style: GoogleFonts.mcLaren(fontSize: 15),)
                ],
              ),
            ),
          )
         ]
       ),
  );
}





Widget detailDialog(BuildContext context, User user) {
  //ThemeData localTheme = Theme.of(context);
  return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: [
        Hero(
        tag: 'profile',
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
          //margin: const EdgeInsets.fromLTRB(14.0,10,14,10),
          padding: const EdgeInsets.fromLTRB(5,5,5,5),
          decoration: BoxDecoration(
          //  border: Border.all(color: Colors.grey[400]),
            borderRadius: BorderRadius.all(
                Radius.circular(25.0)
            ),
          ),
            child: Image.network(
            user.profileUrl,
            height: 320,
            fit: BoxFit.fill),
          ),
        ),
        ),
      ]
  );
}






