import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class Introduce extends StatefulWidget {

  Introduce({
    this.toilet,
    this.carpark,
    this.room,
    this.introduceTextController
  });
  final  ValueChanged<int> room;
  final  ValueChanged<int> carpark;
  final  ValueChanged<int> toilet;
  final TextEditingController introduceTextController;
  @override
  State<StatefulWidget> createState() => _Introduce();
}

class _Introduce extends State<Introduce> with AutomaticKeepAliveClientMixin<Introduce>{

  int room = 1;
  int carpark = 0;
  int toilet = 1;


  @override
  Widget build(BuildContext context) {

  showPickerNumber(BuildContext context, String type) {
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 10),
         // NumberPickerColumn(begin: 100, end: 200),
        ]),
        delimiter: [
          PickerDelimiter(child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        hideHeader: true,
        title: new Text("Select Number of $type", 
        style: GoogleFonts.mcLaren(),
        textAlign: TextAlign.center,),
        onConfirm: (Picker picker, List value) {
          setState(() {
            if(type == 'Room')
            room = picker.getSelectedValues()[0];
            widget.room(room);
            if(type =='Toilet')
             toilet = picker.getSelectedValues()[0];
            widget.toilet(toilet);
            if(type =='CarPark')
             carpark = picker.getSelectedValues()[0];
              widget.carpark(carpark);
          });
        }
    ).showDialog(context);
  }
    super.build(context);
     Size screenSize = MediaQuery.of(context).size/ 1;
    return SingleChildScrollView(
            child: Container(
             margin: const EdgeInsets.fromLTRB(14.0,10,14,10),
             padding: const EdgeInsets.fromLTRB(14.0,10,14,10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(height: 50,),
                    SizedBox(
                      width: 100,
                      child: GestureDetector(
                          onTap: () {
                            showPickerNumber(context, 'Room');
                          }, 
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                          Icon(Icons.hotel, color: Colors.blueGrey,),
                          SizedBox(width: 15,),
                          Icon(Icons.arrow_back_ios,
                          size: 11,
                          ),
                          Text(' $room ', 
                          style :GoogleFonts.mcLaren(fontSize: 18),),
                          Icon(Icons.arrow_forward_ios,
                          size: 11,)
                        ],),
                      ) 
                    ),
                SizedBox(
                  width: 100,
                  child: GestureDetector(
                          onTap: () {
                            showPickerNumber(context, 'Toilet');
                          }, 
                          child: Row(children: <Widget>[
                          Icon(Icons.airline_seat_legroom_reduced, color: Colors.blueGrey,),
                          SizedBox(width: 15,),
                          Icon(Icons.arrow_back_ios,
                          size: 11,
                          ),
                          Text(' $toilet ', 
                          style :GoogleFonts.mcLaren(fontSize: 18),),
                          Icon(Icons.arrow_forward_ios,
                          size: 11,)
                        ],),
                      ) 
                ),
                SizedBox(
                  width: 100,
                 child: GestureDetector(
                          onTap: () {
                            showPickerNumber(context, 'CarPark');
                          }, 
                          child: Row(children: <Widget>[
                          Icon(Icons.directions_car, color: Colors.blueGrey,),
                          SizedBox(width: 15,),
                          Icon(Icons.arrow_back_ios,
                          size: 11,
                          ),
                          Text(' $carpark ', 
                          style :GoogleFonts.mcLaren(fontSize: 18),),
                          Icon(Icons.arrow_forward_ios,
                          size: 11,)
                        ],),
                      ) 
                ),       
                  ],
                ),
             Divider(),   
              Container(
                width: 380,
                height: screenSize.height > 700 ?
                410 : 330,
                child: Card(child:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type about Rent House',
                        hintStyle: GoogleFonts.mcLaren(),
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


