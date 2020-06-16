import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LodingWidget extends StatelessWidget {
    final Function onTap;
     LodingWidget(this.onTap);
  @override
  Widget build(BuildContext context) {
    return Column(
     mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RotateAnimatedTextKit(
                onTap: onTap ,
                text: ["Hey guys...","Now Loading..."," Loading..." , " Humm ...", "Jsut click me"],
                textStyle: TextStyle(fontSize: 40.0, color: Colors.white, fontFamily: "Horizon"),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional.topStart // or Alignment.topLeft
              ),
            ],
          ),
            SpinKitCubeGrid(
            color: Colors.white,
            size: 50.0,             
            )
          ],
        );
  }
}