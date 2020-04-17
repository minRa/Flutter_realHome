import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realhome/providers/image_provider.dart';
import 'package:realhome/screens/Detail.dart';
import 'package:realhome/screens/detail_Image.dart';
import 'package:realhome/screens/overview.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: ImageFiles(),
            ),
          ],
          child: MaterialApp(
          title: 'Flutter Demo',
         theme: ThemeData(      
          primarySwatch: Colors.blue,
        ),
        home: Overview(),
        routes: {
          Detail.id :(ctx)=> Detail(),  
          DetailImage.id: (ctx) => DetailImage()     
        } ,
      ),
    );
  }
}
