import 'package:flutter/material.dart';

class Introduce extends StatefulWidget {
  Introduce(this.introduceTextController);
  final TextEditingController introduceTextController;
  @override
  State<StatefulWidget> createState() => _Introduce();
}

class _Introduce extends State<Introduce> with AutomaticKeepAliveClientMixin<Introduce>{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.only(top:28.0,bottom:28.0),
      child: SingleChildScrollView(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 380,
              height: 380,
              child: Card(child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type about Rent House'
                    ),
                      maxLines:10 ,
                      controller: widget.introduceTextController,
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}