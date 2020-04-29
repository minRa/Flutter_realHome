import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/ui/widgets/Introduce.dart';
import 'package:realhome/ui/widgets/add_place.dart';
import 'package:realhome/ui/widgets/app_drawer.dart';
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


  void initState() {
    // init values
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
  Color _nextColor = Colors.green[800];
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PostHouseViewModel>.withConsumer(
      viewModel: PostHouseViewModel(), 
      onModelReady: widget._postProperty != null? 
      (model) => model.getPostProperty(widget._postProperty) : null,
      builder: (context, model, child) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Post Rent House'),
        actions: <Widget>[
          Container(
            child: model.currentUser != null?            
            IconButton(
              icon:Icon(Icons.exit_to_app),
              onPressed:model.logout)
              : IconButton(
              icon:Icon(Icons.person_add),
              onPressed: model.navigateToLogin
              ) 
         )
        ],
      ),
      drawer:
      AppDrawer(
        currentUser: model.currentUser,
        home:model.navigateToHouseOverView,
        mebership: model.navigateToMembershipView,
        property: model.navigateToPropertyManageView,
        logout: model.logout
      ),
      body:Stack(
        children: <Widget>[
          WillPopScope( // blocking if the user cancel button, close the view.
            child: SingleChildScrollView(
              child: Column(
               // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'Information Form',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        height: 520,
                        child: PageView( 
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                            if (page == 3) { // if last page, change text and color
                              setState(() {
                                _nextText = 'Submit';
                                _nextColor = Colors.blue[900];
                              });
                            } else {
                              setState(() {
                                _nextText = 'Next';
                                _nextColor = Colors.green[800];
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
                            Introduce(_textAreaController,),
                            PickedImages(
                              cropImage: model.cropImage,
                              imageUpload: model.uploadImage,
                              imageUrl: model.images,
                              remove: model.remove,
                              ),
                            AddPlace(
                              addressController: _adressDetailController,
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
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(12.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Cancel',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                                textColor: Colors.black,
                                color: Colors.white,
                                padding: EdgeInsets.all(10),
                                onPressed: () { // move first page view when click 'cancel' button
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
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(12.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      _nextText,
                                      style: TextStyle(fontSize: 15),
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
            content: Text(textMessage),
          );
        }
    );
  }
}








  // PickedImages(model.updateUserData,0),
  //                     Container(
  //                       padding: EdgeInsets.only(right: 300),
  //                       child: IconButton(
  //                         icon: addMorePicture1? Icon(Icons.minimize) : Icon(Icons.add_circle_outline),
                          
  //                         onPressed: () {
  //                           setState(() {
  //                             addMorePicture1 = !addMorePicture1;
  //                              if(addMorePicture2) addMorePicture2 = !addMorePicture2;
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                     Visibility(
  //                      visible: addMorePicture1,
  //                      child:PickedImages(model.updateUserData,1),
  //                    ), 
  //                     Visibility(
  //                      visible: addMorePicture1,              
  //                      child:Container(
  //                        padding: EdgeInsets.only(right: 300),
  //                        child: IconButton(
  //                         icon: addMorePicture2? Icon(Icons.minimize) : Icon(Icons.add_circle_outline),
  //                         onPressed: () {
  //                           setState(() {
  //                             addMorePicture2 = !addMorePicture2;
  //                           });
  //                         },
  //                     ),
  //                      ),
  //                    ),      
  //                     Visibility(
  //                      visible: addMorePicture2,
  //                      child:PickedImages(model.updateUserData,2),
  //                    ) ,



  // verticalSpaceMedium,
  //                        Container(
  //                          padding: EdgeInsets.only(
  //                            left: 35.0,
  //                            right: 35.0,
  //                            bottom: 20.0
  //                          ),
  //                          child: BusyButton(
  //                           title: 'Post House',
  //                           busy: model.busy,
  //                           onPressed:() {
  //                             model.postHouse(
  //                               title: titleController.text,
  //                               address:adressDetailController.text,
  //                               message: messengerIdController.text,
  //                               messengerId: messengerIdController.text,
  //                               price: priceController.text,

  //                             );
  //                           }
  //                       ),
  //                        ),         