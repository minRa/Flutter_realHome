import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.blue[50],    // Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

Widget buildEmailTF(TextEditingController emailController ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.mcLaren(
              color: Colors.blueGrey,
            //  fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.blueGrey,
              ),
              hintText: 'Email',
              hintStyle:GoogleFonts.mcLaren(),
            ),
          ),
        ),
      ],
    );
  }


   Widget buildPasswordTF(TextEditingController passwordController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.blueGrey,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.blueGrey,
              ),
              hintText: 'Password',
              hintStyle: GoogleFonts.mcLaren(),
            ),
          ),
        ),
      ],
    );
  }