import 'package:flutter/material.dart';

class NoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
     color: Colors.white,
     child: Column(
       children: <Widget>[
         Container(
           margin: EdgeInsets.only(top:40),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image.asset('assets/images/mimi1.gif'),
                  Text('Sorry, There is no result...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22
                  ),
                  ),
                ],
              ),
            )
       ],
     ),

      
    );
  }
}