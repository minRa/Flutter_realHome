import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


void showTermOfService(BuildContext context, String content, String title) {
    showDialog(
    context: context,
     barrierDismissible: false,
     child: AlertDialog(
       title: Text(title,
       style: GoogleFonts.mcLaren(),
       ),
       shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.all(Radius.circular(20.0))),
       content: Container(
         height: 360,
         width: 300,
         child: Scrollbar(
         isAlwaysShown: true,
         child: SingleChildScrollView(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: <Widget>[
                 Text(content ,
                 style:GoogleFonts.mcLaren(),
                 ),
               ],
             ),
           ),
         ),
       ),
       actions: <Widget>[
         FlatButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
          child: Text('I GOT IT',
          style: GoogleFonts.mcLaren(),
          ),
        )]
      )
    );
  }



