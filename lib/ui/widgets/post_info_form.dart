import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realhome/ui/widgets/term_of_service.dart';
import 'package:realhome/ui/widgets/text_link.dart';
import 'package:flutter/services.dart' show rootBundle;

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

  Future<String> getFileData(String path) async {
     var data = await rootBundle.loadString(path);
     return data.toString();
}

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year, DateTime.now().month),
        firstDate: DateTime(DateTime.now().year-1, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day));
    if (picked != null && picked != DateTime.now())
      setState(() {
        _selectDateString = "${picked.toLocal()}".split(' ')[0];
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
    super.build(context);
      double setHeight =5;
      Size screenSize = MediaQuery.of(context).size/ 1;
    return SingleChildScrollView(
          child: Container(
           margin: screenSize.height > 700 ?
           EdgeInsets.fromLTRB(14.0,15,15,10)
           :EdgeInsets.fromLTRB(14.0,0,0,10),
           padding: screenSize.height > 700 ?
           EdgeInsets.fromLTRB(14.0,10,14,10)
           : EdgeInsets.fromLTRB(14.0,0,14,0),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 360,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.title, color: Colors.blueGrey),
                      labelText: 'Title',
                      hintText: 'Type your title',
                      hintStyle: GoogleFonts.mcLaren()
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Title is required';
                    }else {
                      return null;
                    }
                  },
                  style: GoogleFonts.mcLaren(color:Colors.blueGrey),
                  controller: widget.titleController,
                ),
              ),
              SizedBox(height: setHeight,),
              SizedBox(
                width: 360,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon:Icon(Icons.credit_card, color: Colors.blueGrey),
                      labelText: 'Price',
                      hintText: 'Type Rent Price',
                      hintStyle: GoogleFonts.mcLaren()
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'price is required';
                    }else {
                      return null;
                    }
                  },
                  style: GoogleFonts.mcLaren(color: Colors.black),
                  controller: widget.priceController,
                ),
              ),
               SizedBox(height: setHeight,),
               SizedBox(
                width: 360,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon:Icon(Icons.mobile_screen_share, color: Colors.blueGrey),
                      labelText: 'Messenger',
                      hintText: 'Type your Messenger & ID',
                      hintStyle: GoogleFonts.mcLaren(),
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'price is required';
                    }else {
                      return null;
                    }
                  },
                  style: GoogleFonts.mcLaren(color: Colors.black),
                  controller: widget.messengerController,
                ),
              ),
             SizedBox(height: setHeight,),
              SizedBox(
                width: 360,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon:Icon(Icons.phone, color: Colors.blueGrey,),
                      labelText: 'phone',
                      hintText: 'Type your phone number',
                      hintStyle: GoogleFonts.mcLaren()
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'phone number is required';
                    }else {
                      return null;
                    }
                  },
                  controller: widget.phoneController,
                  style: GoogleFonts.mcLaren(color: Colors.black),
                ),
              ),
            //  Divider(),
              Row(
              children: <Widget>[
                Icon(Icons.wc,color: Colors.blueGrey,),
                Radio(
                  value: RentTypeEnum.single,
                  groupValue: _rentType,
                  onChanged: (RentTypeEnum value) {
                    setState(() {
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
                  child: Text('Single',
                  style: GoogleFonts.mcLaren(fontSize: 12)
                  ),
                ),
                SizedBox(width: setHeight,),
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
                  child: Text('Double',
                  style: GoogleFonts.mcLaren(fontSize: 12)
                  ),
                ),
                   SizedBox(width: setHeight,),
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
                  child: Text('Fmaily',
                 style: GoogleFonts.mcLaren(fontSize: 12)
                  ),
                ),
              ],
                ),               
              SizedBox(height: setHeight,),
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
                          child: Text(_selectDateString,
                          style: GoogleFonts.mcLaren(),
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: setHeight,),
              SizedBox(
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        Text('I agree to ',
                        style: GoogleFonts.mcLaren(),
                        ),
                      ),
                      Container(
                      child: Column(
                        children: [
                          TextLink(
                           'term of service',
                           onPressed: ()async {
                             String term =  await getFileData('assets/text/term.txt'); 
                               showTermOfService(context,term,'Terms of Services ');
                             } 
                            ),
                           TextLink(
                              ' & privacy policy',
                                onPressed: ()  async {
                                String privacy = await  getFileData('assets/text/privacy.txt');
                                showTermOfService(context,privacy, 'Privacy Policy');
                                } 
                           )
                        ],
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


  void _passDataToParent(String key, dynamic value) {
    List<dynamic> addData = List<dynamic>();
    addData.add(key);
    addData.add(value);
    widget.parentAction(addData);
  }

  @override
  bool get wantKeepAlive => true;
}
