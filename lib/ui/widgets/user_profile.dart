import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:realhome/models/postProperty.dart';
import 'package:realhome/models/user.dart';

class UserProfilePage extends StatelessWidget {
  final bool onAuth;
  final Function navigate;
  final User user;
  final Function editImage;
  final Function editBackground;
  final Function goToChatRoom;

  UserProfilePage({
    this.navigate,
    this.user,
    this.onAuth,
    this.editImage,
    this.editBackground,
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
         //:AssetImage('assets/images/cover.jpg')
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
                  image:// user != null?
                  user.profileUrl != null?
                  NetworkImage(user.profileUrl)
                 //: AssetImage('assets/images/EditAvata.png')
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
            onAuth ?
              Positioned(
              top: 70,
              left: 200,
              child: Container(
                  height: 50,
                  width: 50,
                  //color: Colors.white.withOpacity(0.1),
                  child: IconButton(
                  icon: Icon(Icons.edit,size: 30,),
                  color: Colors.white,
                  onPressed: () {
                  showDialog(
                  context: context,
                  builder: (context) => editDialog(context, editImage, editBackground));
                  //.then((_) => Navigator.of(context).pop());
                 }               
                ),
              )
        ) : Positioned(
           child: Container(),
        )
      ],
    );
  }

  Widget _buildFullName() {

    // TextStyle _nameTextStyle = TextStyle(
    //   fontFamily: 'Roboto',
    //   color: Colors.black,
    //   fontSize: 20.0,
    //   fontWeight: FontWeight.w700,
    // );

    return Text(
      user.fullName,
      textAlign: TextAlign.center,
      style:GoogleFonts.mcLaren(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.black  ),
      //_nameTextStyle,
    );
  }


  Widget _buildGetInTouch(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      //padding: EdgeInsets.only(top: 8.0),
      child: Text(
        user.email,
        textAlign: TextAlign.center,
        style: GoogleFonts.mcLaren(fontSize: 16,fontWeight: FontWeight.w700 ),
        // TextStyle(
        //   fontFamily: 'Roboto', 
        //   fontSize: 16.0,
        //   fontWeight: FontWeight.w700
        //   ), 
      ),
    );
  }

 

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size/ 2;
    return SafeArea(
        child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildCoverImage(context, screenSize),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 2.6),
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
                     onAuth ?  SizedBox(
                      width: 43,
                    ) :
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     IconButton(
                  //     tooltip: 'Home',
                  //     icon: Icon(Icons.home,
                  //     color: Colors.blueGrey,),
                  //     onPressed:navigate,
                  //   ), 
                  //   _buildFullName(),
                  //    SizedBox(width: 10.0),
                  // _buildGetInTouch(context),
                  // ],), 
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
  //ThemeData localTheme = Theme.of(context);
  return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: [
        Container(
       // margin: const EdgeInsets.fromLTRB(14.0,10,14,10),
       // padding: const EdgeInsets.fromLTRB(5,5,5,5),
        decoration: BoxDecoration(
         // border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.all(
              Radius.circular(25.0)
          ),
        ),
          child:Column(
            children: <Widget>[
              GestureDetector(
                onTap:() async{
                   await profile();
                   Navigator.of(context).pop();
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

                   await background();
                   Navigator.of(context).pop();
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
              // Container(
              // child:IconButton(
              //   icon: Icon(Icons.close),
              //   onPressed:() {
              //     Navigator.of(context).pop();
              //   },
              //  ) )
            ],),)
       ]
     );
}


Widget chatDialog(BuildContext context, User owner, Function goToChatRoom,) {
  //ThemeData localTheme = Theme.of(context);
  return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: [
        Container(
       // margin: const EdgeInsets.fromLTRB(14.0,10,14,flutte10),
       // padding: const EdgeInsets.fromLTRB(5,5,5,5),
        decoration: BoxDecoration(
         // border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.all(
              Radius.circular(25.0)
          ),
        ),
          child:GestureDetector(
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
          ),)
       ]
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
            height: 400,
            fit: BoxFit.fill),
          ),
        ),
        ),
        // Container(
        //   height: 100,
        //   child:IconButton(
        //     icon: Icon(Icons.close),
        //     onPressed:null,
        //   )
        // )
      ]
  );
}


//////////////////////////////////////////////////////////////////////////////////////

// import 'package:flutter/material.dart';

// class UserProfilePage extends StatelessWidget {
//   final String _fullName = "Nick Frost";
//   final String _status = "Software Developer";
//   final String _bio =
//       "\"Hi, I am a Freelance developer working for hourly basis. If you wants to contact me to build your product leave a message.\"";
//   final String _followers = "173";
//   final String _posts = "24";
//   final String _scores = "450";

//   Widget _buildCoverImage(Size screenSize) {
//     return Container(
//       height: screenSize.height / 2.6,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/images/cover.jpg'),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileImage() {
//     return Center(
//       child: Container(
//         width: 140.0,
//         height: 140.0,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/avata.png'),
//             fit: BoxFit.cover,
//           ),
//           borderRadius: BorderRadius.circular(80.0),
//           border: Border.all(
//             color: Colors.white,
//             width: 10.0,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFullName() {
//     TextStyle _nameTextStyle = TextStyle(
//       fontFamily: 'Roboto',
//       color: Colors.black,
//       fontSize: 28.0,
//       fontWeight: FontWeight.w700,
//     );

//     return Text(
//       _fullName,
//       style: _nameTextStyle,
//     );
//   }

//   Widget _buildStatus(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         borderRadius: BorderRadius.circular(4.0),
//       ),
//       child: Text(
//         _status,
//         style: TextStyle(
//           fontFamily: 'Spectral',
//           color: Colors.black,
//           fontSize: 20.0,
//           fontWeight: FontWeight.w300,
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String count) {
//     TextStyle _statLabelTextStyle = TextStyle(
//       fontFamily: 'Roboto',
//       color: Colors.black,
//       fontSize: 16.0,
//       fontWeight: FontWeight.w200,
//     );

//     TextStyle _statCountTextStyle = TextStyle(
//       color: Colors.black54,
//       fontSize: 24.0,
//       fontWeight: FontWeight.bold,
//     );

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Text(
//           count,
//           style: _statCountTextStyle,
//         ),
//         Text(
//           label,
//           style: _statLabelTextStyle,
//         ),
//       ],
//     );
//   }

//   Widget _buildStatContainer() {
//     return Container(
//       height: 60.0,
//       margin: EdgeInsets.only(top: 8.0),
//       decoration: BoxDecoration(
//         color: Color(0xFFEFF4F7),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           _buildStatItem("Followers", _followers),
//           _buildStatItem("Posts", _posts),
//           _buildStatItem("Scores", _scores),
//         ],
//       ),
//     );
//   }

//   Widget _buildBio(BuildContext context) {
//     TextStyle bioTextStyle = TextStyle(
//       fontFamily: 'Spectral',
//       fontWeight: FontWeight.w400,//try changing weight to w500 if not thin
//       fontStyle: FontStyle.italic,
//       color: Color(0xFF799497),
//       fontSize: 16.0,
//     );

//     return Container(
//       color: Theme.of(context).scaffoldBackgroundColor,
//       padding: EdgeInsets.all(8.0),
//       child: Text(
//         _bio,
//         textAlign: TextAlign.center,
//         style: bioTextStyle,
//       ),
//     );
//   }

//   Widget _buildSeparator(Size screenSize) {
//     return Container(
//       width: screenSize.width / 1.6,
//       height: 2.0,
//       color: Colors.black54,
//       margin: EdgeInsets.only(top: 4.0),
//     );
//   }

//   Widget _buildGetInTouch(BuildContext context) {
//     return Container(
//       color: Theme.of(context).scaffoldBackgroundColor,
//       padding: EdgeInsets.only(top: 8.0),
//       child: Text(
//         "Get in Touch with ${_fullName.split(" ")[0]},",
//         style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
//       ),
//     );
//   }

//   Widget _buildButtons() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: InkWell(
//               onTap: () => print("followed"),
//               child: Container(
//                 height: 40.0,
//                 decoration: BoxDecoration(
//                   border: Border.all(),
//                   color: Color(0xFF404A5C),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "FOLLOW",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 10.0),
//           Expanded(
//             child: InkWell(
//               onTap: () => print("Message"),
//               child: Container(
//                 height: 40.0,
//                 decoration: BoxDecoration(
//                   border: Border.all(),
//                 ),
//                 child: Center(
//                   child: Padding(
//                     padding: EdgeInsets.all(10.0),
//                     child: Text(
//                       "MESSAGE",
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           _buildCoverImage(screenSize),
//           SafeArea(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(height: screenSize.height / 6.4),
//                   _buildProfileImage(),
//                   _buildFullName(),
//                   _buildStatus(context),
//                   _buildStatContainer(),
//                   _buildBio(context),
//                   _buildSeparator(screenSize),
//                   SizedBox(height: 10.0),
//                   _buildGetInTouch(context),
//                   SizedBox(height: 8.0),
//                   _buildButtons(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




