import 'package:flutter/material.dart';
import 'package:realhome/widgets/detail_grid.dart';

class Detail extends StatelessWidget {
  static const id ="/detail";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Text('hellow world')
        ],
      ),
      body:Column(
        children: <Widget>[
          Text('this is house'),
          SizedBox(height: 10,),
         Expanded(
            child:DetailGrid(),
          ),
          Expanded(
            child:ListView(
              children: <Widget>[
                
              ],
            ),
          ),
        ],
      ),
      
    );
  }
}


      // Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),
      //     Text('details information !!!'),