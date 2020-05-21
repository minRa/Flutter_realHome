
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/ui/widgets/Introduce.dart';
import 'package:realhome/ui/widgets/add_place.dart';
import 'package:realhome/ui/widgets/images.dart';
import 'package:realhome/ui/widgets/post_info_form.dart';
import 'package:realhome/view_model/post_hose_view_model.dart';


class PostHouseView extends StatefulWidget {
   
   final PostProperty _postProperty;
  PostHouseView(this._postProperty);
  @override
  _PostHouseViewState createState() => _PostHouseViewState();
}

class _PostHouseViewState extends State<PostHouseView> {

   final _textAreaController = TextEditingController();
   final _messengerController = TextEditingController();
   final _phoneController = TextEditingController();
   final _adressDetailController = TextEditingController();
   final _priceController = TextEditingController(); 
   final _titleController = TextEditingController(); 


 // pageController in view.
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // // save user data except textfield data like gender, images, birthday
  Map<String, dynamic> _userDataMap = Map<String, dynamic>();

    _updateUserData(List<dynamic> data) {    
         _userDataMap[data[0]] = data[1];
    }

    
  final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();


  void initState() {
    // init values
    if(!_googleAdsService.onBanner) {
       _googleAdsService.bottomBanner();
    }
    
    if(widget._postProperty != null) {
      _textAreaController.text = widget._postProperty.message;
      _messengerController.text = widget._postProperty.messenger;
      _titleController.text = widget._postProperty.title;
      _priceController.text = widget._postProperty.price;
      _phoneController.text = widget._postProperty.phone;
      _adressDetailController.text = widget._postProperty.address;
    }
     _userDataMap['RentType'] = 'Single';
     _userDataMap['term'] = false;
    // set data from SNS

    super.initState();
  }



  // Editable values
  String _nextText = 'Next';
  Color _nextColor = Colors.greenAccent;
  bool isLoading = false;

  @override
  void dispose() async {
    _textAreaController.dispose();
    _adressDetailController.dispose();
    _messengerController.dispose();
    _pageController.dispose();
    _phoneController.dispose();
    _priceController.dispose();
    _textAreaController.dispose();
    _userDataMap.clear();
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size/ 1;
    return ViewModelProvider<PostHouseViewModel>.withConsumer(
      viewModel: PostHouseViewModel(), 
      onModelReady: widget._postProperty != null? 
      (model) => model.getPostProperty(widget._postProperty) : null,
      builder: (context, model, child) => 
       Scaffold(
       body:
      Stack(
        children: <Widget>[
          WillPopScope( // blocking if the user cancel button, close the view.
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: _googleAdsService.onBanner ? EdgeInsets.only(top: 30)
                    :EdgeInsets.only(top: 50),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Post Rent House',
                        style: GoogleFonts.mcLaren(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    height: _googleAdsService.onBanner ?
                     screenSize.height > 700 ? 510 : 430
                     : screenSize.height > 700 ? 560
                     : screenSize.height > 600 ? 470 : 430,
                    child: PageView( 
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                        if (page == 3) { // if last page, change text and color
                          setState(() {
                            _nextText = 'Post';
                            _nextColor = Colors.blueAccent;
                          });
                        } else {
                          setState(() {
                            _nextText = 'Next';
                            _nextColor = Colors.greenAccent;
                          });
                        }
                      },
                      controller: _pageController,
                      children: <Widget>[
                       InputInformationForm(
                             model.updateRentType,
                             model.updateDate,
                            _messengerController,
                            _phoneController,
                            _priceController,
                            _titleController,
                             _updateUserData
                        ),
                        Introduce(
                           carpark: model.updateCarpark,
                           room: model.updateRoom,
                           toilet: model.updateToilet,
                           introduceTextController: _textAreaController,
                          
                          ),
                        PickedImages(
                          multiImage: model.multiImageUpload,
                          ),
                        AddPlace(
                          address: _adressDetailController,
                          save: model.updatePlaceDetail,
                          addLocation: model.addPlace,           
                          )                   
                      ],
                      
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Cancel',
                                  style: GoogleFonts.mcLaren(fontSize: 15),
                                ),
                              ],
                            ),
                            textColor: Colors.black,
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            onPressed: () { 
                              if (_currentPage > 0) {
                                _pageController.animateToPage(
                                    0,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  _nextText,
                                  style: GoogleFonts.mcLaren(fontSize: 15),
                                ),
                              ],
                            ),
                            textColor: Colors.white,
                            color: _nextColor,
                            padding: EdgeInsets.all(10),
                            onPressed: () async {
                              if (_pageController.page.toInt() == 0) {
                                 
                                  print('page1 or 2');
                                if (_validateUserData()) {
                                  _moveToNextPage(); // check user data validation and move next page
                                }
                              }else if (_pageController.page.toInt() == 1
                             || _pageController.page.toInt() == 2) {
                                 print('page1 or 2');
                                
                                _moveToNextPage();
                              }else if (_pageController.page.toInt() == 3) {
                                if (_validateUserData()) {
                                  print('last page');
                                  setState(() {
                                    isLoading = true;
                                  });
                                                                      
                                   await model.postingHouse(
                                   // address: _adressDetailController.text,
                                    message: _textAreaController.text,
                                    messenger: _messengerController.text,
                                    phone: _phoneController.text,
                                    price: _priceController.text,
                                    title: _titleController.text
                                  );
                                      setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onWillPop: onBackPress,
          ),
          Positioned(
            child: isLoading
                ? Container(
              child: Center(
                child: CircularProgressIndicator(
//                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                ),
              ),
              color: Colors.white.withOpacity(0.7),
            )
                : Container(),
          ),
        ],
      ), 
      ),        
    );
   }


   
bool _validateUserData() {
    String alertString = '';

    if (_titleController.text.trim() == '') {
      alertString = alertString+ 'Please type title';
    }

  
    if (_priceController.text.trim() == ''){
      if (alertString.trim() != '') {
        alertString = alertString+ '\n\n';
      }
      alertString = alertString+ 'Please type rent price';
    }

      if (_currentPage == 3 &&_adressDetailController.text.trim() == ''){
      if (alertString.trim() != '') {
        alertString = alertString+ '\n\n';
      }
      alertString = alertString+ 'Please check your address';
    }
    
     if (_messengerController.text.trim() == ''){
      if (alertString.trim() != '') {
        alertString = alertString+ '\n\n';
      }
      alertString = alertString+ 'Please type Messenger & ID';
    }

    if (_phoneController.text.trim() == ''){
      if (alertString.trim() != '') {
        alertString = alertString+ '\n\n';
      }
      alertString = alertString+ 'Please type your phone';
    }

    if (_userDataMap['move_year'] == 0){
      if (alertString.trim() != '') {
        alertString = alertString+ '\n\n';
      }
      alertString = alertString+ 'Please select Available date';
    }
     
    print(_userDataMap['term']);
    
    if (_userDataMap['term'] == false){
      if (alertString.trim() != '') {
        alertString = alertString+ '\n\n';
      }
      alertString = alertString+ 'Please agree the term check box';
    }

    if (alertString.trim() != '') {
      showDialogWithText(alertString);
      return false;
    }else {
      return true;
    }
  }

  Future<bool> onBackPress() { // block close the view.
    if (_currentPage > 0) {
      _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn);
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  void _moveToNextPage() { // move next page.
    _pageController.animateToPage(
        _pageController.page.toInt() + 1,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn);
  }


   showDialogWithText(String textMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(textMessage,
            style: GoogleFonts.mcLaren(),
            ),
          );
        }
    );
  }
}





