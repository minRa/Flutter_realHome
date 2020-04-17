
import 'package:flutter/material.dart';
import 'package:realhome/widgets/horizontal_overview_ListTile.dart';
import 'package:provider/provider.dart';
import 'package:realhome/providers/image_provider.dart';

class HorizontalOverview extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final imageData = Provider.of<ImageFiles>(context);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
          Text('City'),
          Text('title'),
          Text('price'),
        ],),
        Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            height: 200.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageData.images.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value:imageData,
                  child:OverviewListTile (
                  image: imageData.images[i].image,
                  )                   
              ),
          ),
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
