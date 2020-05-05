import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

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
        title: new Text("Select Number of $type", textAlign: TextAlign.center,),
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
    return SingleChildScrollView(
            child: Container(
             margin: const EdgeInsets.fromLTRB(14.0,10,14,10),
             padding: const EdgeInsets.fromLTRB(14.0,10,14,10),
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.grey[400]),
            //   borderRadius: BorderRadius.all(
            //       Radius.circular(25.0)
            //   ),
            // ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(height: 50,),
                    SizedBox(
                      width: 110,
                      child: GestureDetector(
                          onTap: () {
                            showPickerNumber(context, 'Room');
                          }, 
                          child: Row(children: <Widget>[
                          Icon(Icons.hotel, color: Colors.blueGrey,),
                          SizedBox(width: 15,),
                          Icon(Icons.arrow_back_ios,
                          size: 11,
                          ),
                          Text(' $room ', 
                          style :TextStyle(fontSize: 18),),
                          Icon(Icons.arrow_forward_ios,
                          size: 11,)
                        ],),
                      ) 
                    ),
                SizedBox(
                  width: 110,
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
                          style :TextStyle(fontSize: 18),),
                          Icon(Icons.arrow_forward_ios,
                          size: 11,)
                        ],),
                      ) 
                ),
                SizedBox(
                  width: 110,
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
                          style :TextStyle(fontSize: 18),),
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
                height: 410,
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




// SingleChildScrollView(
//           child: Container(
//           margin: const EdgeInsets.fromLTRB(14.0,10,14,10),
//           padding: const EdgeInsets.fromLTRB(14.0,10,14,10),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey[400]),
//             borderRadius: BorderRadius.all(
//                 Radius.circular(25.0)
//             ),
//           ),
//           child: Column(
//             children: <Widget>[
//               SizedBox(
//                 width: 360,
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                       border: InputBorder.none,
//                       icon: Icon(Icons.title, color: Colors.blueGrey),
//                       labelText: 'Title',
//                       hintText: 'Type your title'
//                   ),
//                   validator: (String value) {
//                     if (value.trim().isEmpty) {
//                       return 'Title is required';
//                     }else {
//                       return null;
//                     }
//                   },
//                   style: TextStyle(color:Colors.blueGrey),
//                   controller: widget.titleController,
//                 ),
//               ),
//               Divider(),
//               SizedBox(
//                 width: 360,
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                       border: InputBorder.none,
//                       icon:Icon(Icons.credit_card, color: Colors.blueGrey),
//                       labelText: 'Price',
//                       hintText: 'Type Rent Price'
//                   ),
//                   validator: (String value) {
//                     if (value.trim().isEmpty) {
//                       return 'price is required';
//                     }else {
//                       return null;
//                     }
//                   },
//                   style: TextStyle(color: Colors.black),
//                   controller: widget.priceController,
//                 ),
//               ),
//               Divider(),
//                SizedBox(
//                 width: 360,
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                       border: InputBorder.none,
//                       icon:Icon(Icons.mobile_screen_share, color: Colors.blueGrey),
//                       labelText: 'Messenger',
//                       hintText: 'Type your Messenger & ID'
//                   ),
//                   validator: (String value) {
//                     if (value.trim().isEmpty) {
//                       return 'price is required';
//                     }else {
//                       return null;
//                     }
//                   },
//                   style: TextStyle(color: Colors.black),
//                   controller: widget.messengerController,
//                 ),
//               ),
//               Divider(),
//               SizedBox(
//                 width: 360,
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                       border: InputBorder.none,
//                       icon:Icon(Icons.phone, color: Colors.blueGrey,),
//                       labelText: 'phone',
//                       hintText: 'Type your phone number'
//                   ),
//                   validator: (String value) {
//                     if (value.trim().isEmpty) {
//                       return 'phone number is required';
//                     }else {
//                       return null;
//                     }
//                   },
//                   controller: widget.phoneController,
//                 ),
//               ),
//               Divider(),
//               Row(
//                 children: <Widget>[
//                   Icon(Icons.wc,color: Colors.blueGrey,),
//                   Radio(
//                     value: RentTypeEnum.single,
//                     groupValue: _rentType,
//                     onChanged: (RentTypeEnum value) {
//                       setState(() {
                  
//                       //  _passDataToParent('rentType','Single',);
//                         _rentType = value;
//                           widget.rentType('Single');
//                       });
//                     },
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                       //  _passDataToParent('rentType','Single');
//                         _rentType = RentTypeEnum.single;
//                           widget.rentType('Single');
//                       });
//                     },
//                     child: Text('Single'),
//                   ),
//                   SizedBox(width: 10,),
//                   Radio(
//                     value: RentTypeEnum.ddouble,
//                     groupValue: _rentType,
//                     onChanged: (RentTypeEnum value) {
//                       setState(() {
//                       //  _passDataToParent('rentType','Double');
//                         _rentType = value;
//                           widget.rentType('Double');
//                       });
//                     },
//                   ),
//                    GestureDetector(
//                     onTap: () {
//                       setState(() {
//                        // _passDataToParent('rentType','Double');
//                         _rentType = RentTypeEnum.ddouble;
//                           widget.rentType('Double');
//                       });
//                     },
//                     child: Text('Double'),
//                   ),
//                      SizedBox(width: 10,),
//                   Radio(
//                     value: RentTypeEnum.family,
//                     groupValue: _rentType,
//                     onChanged: (RentTypeEnum value) {
//                       setState(() {
//                         //_passDataToParent('rentType','Fmaily');
//                         _rentType = value;
//                         widget.rentType('Fmaily');
//                       });
//                     },
//                   ),
//                    GestureDetector(
//                     onTap: () {
//                       setState(() {
//                        // _passDataToParent('rentType','Fmaily');
//                         _rentType = RentTypeEnum.family;
//                         widget.rentType('Fmaily');
//                       });
//                     },
//                     child: Text('Fmaily'),
//                   ),
//                 ],
//               ),               
//               Divider(),
//               SizedBox(
//                 width: 360,
//                 child:
//                 Row(
//                   children: <Widget>[
//                     Icon(Icons.event_available,color: Colors.blueGrey,),
//                     Padding(
//                       padding: const EdgeInsets.only(left:14.0),
//                       child: Container(
//                         width: 260,
//                         child: RaisedButton(
//                           onPressed: () {
//                             _selectDate(context);
//                           },
//                           child: Text(_selectDateString),
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: 360,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
//                   child: Row(
//                     children: <Widget>[
//                       Checkbox(
//                         value: _agreedToTerm,
//                         onChanged: _setAgreedToTerm,
//                       ),
//                       GestureDetector(
//                         onTap: (){
//                           _agreedToTerm = !_agreedToTerm;
//                           _setAgreedToTerm(_agreedToTerm);
//                         },
//                         child:
//                         Text('I agree to '),
//                       ),
//                       GestureDetector(
//                         onTap: () => _showTermPolicy(),
//                         child: const Text(
//                           'Terms of Services',
//                           style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//     );