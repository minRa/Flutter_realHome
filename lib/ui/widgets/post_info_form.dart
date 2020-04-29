import 'package:flutter/material.dart';

class InputInformationForm extends StatefulWidget {
  InputInformationForm(
      this.rentType,
      this.date,
      this.messengerController,
      this.phoneController,
      this.priceController,
      this.titleController,
      this.parentAction);
    final ValueChanged<String> date;
    final ValueChanged<String> rentType;
    final TextEditingController messengerController;
    final TextEditingController phoneController;
    final TextEditingController priceController;
    final TextEditingController titleController; 
    final ValueChanged<List<dynamic>> parentAction;


  @override
  State<StatefulWidget> createState() => _InputInformationForm();
}

enum RentTypeEnum { single, ddouble, family }

class _InputInformationForm extends State<InputInformationForm> with AutomaticKeepAliveClientMixin<InputInformationForm> {

  // init data
  RentTypeEnum _rentType = RentTypeEnum.single;
  String _selectDateString = 'Avaiable Date';
  bool _agreedToTerm = false;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year, DateTime.now().month),
        firstDate: DateTime(DateTime.now().year-1, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day));
    if (picked != null && picked != DateTime.now())
      setState(() {
        _selectDateString = "${picked.toLocal()}".split(' ')[0];
        // _passDataToParent('move_year',picked.year.toString());
        // _passDataToParent('move_month',picked.month.toString());
        // _passDataToParent('move_day',picked.day.toString());
          widget.date (picked.toString().split(' ')[0]);
          print(widget.date);
        
      });
   
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _setAgreedToTerm(bool newValue) {
    _passDataToParent('term',newValue);
    setState(() {
      _agreedToTerm = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.rentType);
    super.build(context);
    return SingleChildScrollView(
          child: Container(
          margin: const EdgeInsets.fromLTRB(14.0,10,14,10),
          padding: const EdgeInsets.fromLTRB(14.0,10,14,10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]),
            borderRadius: BorderRadius.all(
                Radius.circular(25.0)
            ),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 360,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.title, color: Colors.blueGrey),
                      labelText: 'Title',
                      hintText: 'Type your title'
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Title is required';
                    }else {
                      return null;
                    }
                  },
                  style: TextStyle(color:Colors.blueGrey),
                  controller: widget.titleController,
                ),
              ),
              Divider(),
              SizedBox(
                width: 360,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon:Icon(Icons.credit_card, color: Colors.blueGrey),
                      labelText: 'Price',
                      hintText: 'Type Rent Price'
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'price is required';
                    }else {
                      return null;
                    }
                  },
                  style: TextStyle(color: Colors.black),
                  controller: widget.priceController,
                ),
              ),
              Divider(),
               SizedBox(
                width: 360,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon:Icon(Icons.mobile_screen_share, color: Colors.blueGrey),
                      labelText: 'Messenger',
                      hintText: 'Type your Messenger & ID'
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'price is required';
                    }else {
                      return null;
                    }
                  },
                  style: TextStyle(color: Colors.black),
                  controller: widget.messengerController,
                ),
              ),
              Divider(),
              SizedBox(
                width: 360,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon:Icon(Icons.phone, color: Colors.blueGrey,),
                      labelText: 'phone',
                      hintText: 'Type your phone number'
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'phone number is required';
                    }else {
                      return null;
                    }
                  },
                  controller: widget.phoneController,
                ),
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Icon(Icons.wc,color: Colors.blueGrey,),
                  Radio(
                    value: RentTypeEnum.single,
                    groupValue: _rentType,
                    onChanged: (RentTypeEnum value) {
                      setState(() {
                  
                      //  _passDataToParent('rentType','Single',);
                        _rentType = value;
                          widget.rentType('Single');
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                      //  _passDataToParent('rentType','Single');
                        _rentType = RentTypeEnum.single;
                          widget.rentType('Single');
                      });
                    },
                    child: Text('Single'),
                  ),
                  SizedBox(width: 10,),
                  Radio(
                    value: RentTypeEnum.ddouble,
                    groupValue: _rentType,
                    onChanged: (RentTypeEnum value) {
                      setState(() {
                      //  _passDataToParent('rentType','Double');
                        _rentType = value;
                          widget.rentType('Double');
                      });
                    },
                  ),
                   GestureDetector(
                    onTap: () {
                      setState(() {
                       // _passDataToParent('rentType','Double');
                        _rentType = RentTypeEnum.ddouble;
                          widget.rentType('Double');
                      });
                    },
                    child: Text('Double'),
                  ),
                     SizedBox(width: 10,),
                  Radio(
                    value: RentTypeEnum.family,
                    groupValue: _rentType,
                    onChanged: (RentTypeEnum value) {
                      setState(() {
                        //_passDataToParent('rentType','Fmaily');
                        _rentType = value;
                        widget.rentType('Fmaily');
                      });
                    },
                  ),
                   GestureDetector(
                    onTap: () {
                      setState(() {
                       // _passDataToParent('rentType','Fmaily');
                        _rentType = RentTypeEnum.family;
                        widget.rentType('Fmaily');
                      });
                    },
                    child: Text('Fmaily'),
                  ),
                ],
              ),               
              Divider(),
              SizedBox(
                width: 360,
                child:
                Row(
                  children: <Widget>[
                    Icon(Icons.event_available,color: Colors.blueGrey,),
                    Padding(
                      padding: const EdgeInsets.only(left:14.0),
                      child: Container(
                        width: 260,
                        child: RaisedButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Text(_selectDateString),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: _agreedToTerm,
                        onChanged: _setAgreedToTerm,
                      ),
                      GestureDetector(
                        onTap: (){
                          _agreedToTerm = !_agreedToTerm;
                          _setAgreedToTerm(_agreedToTerm);
                        },
                        child:
                        Text('I agree to '),
                      ),
                      GestureDetector(
                        onTap: () => _showTermPolicy(),
                        child: const Text(
                          'Terms of Services',
                          style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  void _showTermPolicy() {
    showDialog(context: context, child:
       AlertDialog(
       title: Text("SignInExample's Terms of Services, Privacy Policy"),
       shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.all(Radius.circular(20.0))),
       content: Container(
         height: 360,
         width: 300,
         child: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: <Widget>[
               Text(
                   'Terms of Services, Privacy Policy' * 100
               ),
             ],
           ),
         ),
       ),
      //  actions: <Widget>[
      //    FlatButton(
      //      onPressed: () {
      //       // Navigator.popUntil(context, context)
      //       // Navigator.of(context).pop(false);
      //      },
      //      child: const Text('Close'),
      //    )
      //  ],
      )
    );
  }

  void _passDataToParent(String key, dynamic value) {
    List<dynamic> addData = List<dynamic>();
    addData.add(key);
    addData.add(value);
    widget.parentAction(addData);
  }

  @override
  bool get wantKeepAlive => true;
}


  // Text(
  //                 '--- Rent House Information ---',
  //                 style: TextStyle (
  //                   fontSize: 20.0,
  //                   color: Colors.blueAccent,                  
  //                    ),),
  //                    Divider(), 
  //                     Container(
  //                            padding: EdgeInsets.only(top: 20,left: 40,right: 40,bottom:20),
  //                          // padding: EdgeInsets.all(15.0),
  //                           child:   InputField(
  //                           smallVersion: true,
  //                           placeholder: 'Title',
  //                           controller: titleController,            
  //                         ),
  //                       ),  
  //                       Container(
  //                       padding: EdgeInsets.only(left: 40,right: 40,bottom:20),
  //                        child: ExpansionList<String>(
  //                           items: ['Auckland','Wellington','christchurch','Invercagill'],
  //                           title: model.selectedCity,
  //                           onItemSelected: model.setdCity,
  //                           smallVersion: true,
  //                           ),

  //                          ), 
  //                           Container(
  //                            padding: EdgeInsets.only(left: 40,right: 40,bottom:20),
  //                          // padding: EdgeInsets.all(15.0),
  //                           child:   InputField(
  //                           smallVersion: true,
  //                           placeholder: 'Address Details',
  //                           controller: adressDetailController,            
  //                         ),
  //                       ),  
                       
  //                      Container(
  //                       padding: EdgeInsets.only(left: 40,right: 40,bottom:20),
  //                        child: ExpansionList<String>(
  //                           items: ['Facebook','Wechat','Line','Kako'],
  //                           title: model.selectedMessenger,
  //                           onItemSelected: model.setdMessenger,
  //                           smallVersion: true,
  //                           ),
  //                          ),
  //                         Container(
  //                            padding: EdgeInsets.only(left: 40,right: 40,bottom:20),
  //                          // padding: EdgeInsets.all(15.0),
  //                           child:   InputField(
  //                           smallVersion: true,
  //                           placeholder: 'Messenger Id',
  //                           controller: messengerIdController,            
  //                         ),
  //                       ),
  //                        Container(
  //                            padding: EdgeInsets.only(left: 40,right: 40,bottom:20),
  //                          // padding: EdgeInsets.all(15.0),
  //                           child:   InputField(
  //                           smallVersion: true,
  //                           placeholder: 'Price /per week',
  //                           controller: priceController,            
  //                         ),
  //                       ),
  //                     Container(
  //                       padding: EdgeInsets.only(left: 40,right: 40,bottom:20),
  //                       // padding: EdgeInsets.all(15.0),
  //                       child: InputField(
  //                       maxLines: 200,
  //                       placeholder: 'Rent House description',
  //                       bigVersion: true,
  //                       textInputType: TextInputType.multiline,
  //                       controller: textAreaController,            
  //                     ),), 
                      