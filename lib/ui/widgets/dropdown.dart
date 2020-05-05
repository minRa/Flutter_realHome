import 'package:flutter/material.dart';
//import 'package:realhome/models/postProperty.dart';



class DropDownBox extends StatefulWidget {
  
  final Function searchCondition;
  final List<String> cities;
  DropDownBox({
        this.searchCondition,
        this.cities});
  @override
  _DropDownBoxState createState() => _DropDownBoxState();
}

class _DropDownBoxState extends State<DropDownBox> {
  String dropdownValueCity = 'All City';
  String dropdownValueType = 'All Type';
 List<String> _cities =['All City', 'Waitting data'];

@override
  void initState() {
       print('I AM HERE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! => ${widget.cities.length}');
        if(widget.cities.length > 0) {      
           setState(() {
             _cities = widget.cities;
           });
        }  
      
    super.initState();
  }

 

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        DropdownButton<String>(
          value: dropdownValueCity,
          // icon: Icon(Icons.arrow_downward),
          // iconSize: 24,
          // elevation: 16,
          // style: TextStyle(color: Colors.deepPurple),
          // underline: Container(
          //   height: 2,
          //   color: Colors.deepPurpleAccent,
          // ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValueCity = newValue;
              widget.searchCondition(dropdownValueCity, dropdownValueType);
            });
          },
          items: _cities     
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
               style: TextStyle(fontSize: 15),
               textAlign: TextAlign.center,),
            );
          }).toList(),
        ),
        SizedBox(width: 50,),
        DropdownButton<String>(
          value: dropdownValueType,
          //icon: Icon(Icons.arrow_downward),
         // iconSize: 24,
         // elevation: 16,
         // style: TextStyle(color: Colors.deepPurple),
          // underline: Container(
          //   height: 2,
          //   color: Colors.deepPurpleAccent,
          // ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValueType = newValue;
               widget.searchCondition(dropdownValueCity, dropdownValueType);
            });
          },
          items:<String>['All Type','Single', 'Double', 'Fmaily']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}