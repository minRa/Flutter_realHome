import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realhome/providers/image_provider.dart';
import 'package:realhome/widgets/app_drawer.dart';
import 'package:realhome/widgets/horizontal_overview.dart';
import 'package:realhome/widgets/overviewListView.dart';
import 'package:realhome/widgets/selectBox.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Overview extends StatefulWidget {

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Overview> {

  @override
  void initState() {
    Provider.of<ImageFiles>(context, listen: false).getImage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main page'),
      ),
      drawer: AppDrawer(),
      body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                   MyStatefulWidget(),
                    MyStatefulWidget(),
                     MyStatefulWidget(),
              ],
            ),
            SizedBox(height: 10,),
            Expanded(child: OverviewListView()),
          ],
        ),
    );
  }
}


