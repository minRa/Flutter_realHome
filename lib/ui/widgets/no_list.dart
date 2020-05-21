import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
       color: Colors.white,
       child: Column(
         children: <Widget>[
           Container(
             margin: EdgeInsets.only(top:50),
             height: 270,
             width: 300,
             child:Image.asset('assets/images/emty.png',
              fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 65,
                padding: EdgeInsets.all(8),
                child:Text('Sorry, There is no result...',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.mcLaren(
                      fontSize: 22
                    ),             
                ),
              )
         ],
       ), 
      ),
    );
  }
}