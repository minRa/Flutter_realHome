import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:realhome/ui/shared/ui_helpers.dart';
import 'package:realhome/ui/widgets/busy_button.dart';
import 'package:realhome/ui/widgets/input_field.dart';
import 'package:realhome/ui/widgets/term_of_service.dart';
import 'package:realhome/ui/widgets/text_link.dart';
import 'package:realhome/view_model/login_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;







class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _rememberMe = false;
  String term='';
  String privacy='';
  
   _onRememberMeChanged(bool newValue) {
       setState(() {
         _rememberMe = newValue;
       });
  }

  void _checkStart() async {
   SharedPreferences prefs = await  SharedPreferences.getInstance();
   setState(() {
      if(prefs.getBool('rememberMe')!=null){
         _rememberMe =  prefs.getBool('rememberMe');
      if(_rememberMe) {
      emailController.text = prefs.getString('email');
      passwordController.text = prefs.getString('password');
     }
    }
   });  
  }

  @override
  void initState()  {
      _checkStart();
    super.initState();
  }

    Future<String> getFileData(String path) async {
     var data = await rootBundle.loadString(path);
     return data.toString();
}

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ViewModelProvider<LoginViewModel>.withConsumer(
      viewModel: LoginViewModel(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
          padding: screenSize.height > 700 ?
          EdgeInsets.symmetric(horizontal: 50, vertical: 80)
          : EdgeInsets.symmetric(horizontal: 50, vertical: 40),
          child:  SingleChildScrollView (
              child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[    
                    SizedBox(
                    height: 120,
                    child: Image.asset('assets/images/logo.png',
                    scale: 2 ,)
                  ),
                InputField(
                  placeholder: 'Email',
                  controller: emailController,
                ),

                verticalSpaceSmall,
                InputField(
                  placeholder: 'Password',
                  password: true,
                  controller: passwordController,
                ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     Checkbox(
                        value: _rememberMe,
                        onChanged: _onRememberMeChanged
                      ),
                        SizedBox(width: 5,),
                        Text('Remember Me',
                        style: GoogleFonts.mcLaren(),
                        )
                   ],
                 ),
                SizedBox(height: 15,),  
                 Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    BusyButton(
                      title:  '  GUEST  ',
                      onPressed:model.nonUserEnter,
                    ),

                     BusyButton(
                      title: '   Login   ',
                      busy: model.busy,
                      enabled: emailController.text !='' 
                      && passwordController.text!='',
                      onPressed:() {
                         model.login(
                          email: emailController.text,
                          password: passwordController.text,
                          rememberMe : _rememberMe
                        );
                      } ,
                    ),
                  ],),
                SizedBox(height: 20,),
                    Container(
                      child:
                       MediaQuery.of(context).size.width > 360 ?
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         TextLink(
                          'term of service',
                          onPressed: ()async {
                            String term =  await getFileData('assets/text/term.txt'); 
                              showTermOfService(context,term,'Terms of Services ');
                            } 
                        ),
                        Text(' and ',
                        style: GoogleFonts.mcLaren(),
                        ),
                        TextLink(
                          'privacy policy',
                            onPressed: ()  async {
                            String privacy = await  getFileData('assets/text/privacy.txt');
                            showTermOfService(context,privacy, 'Privacy Policy');
                            } 
                        )
                      ],
                    ) :  Column(
                      children: [
                         TextLink(
                          'term of service',
                          onPressed: ()async {
                            String term =  await getFileData('assets/text/term.txt'); 
                              showTermOfService(context,term,'Terms of Services ');
                            } 
                        ),

                        TextLink(
                          '& privacy policy',
                            onPressed: ()  async {
                            String privacy = await  getFileData('assets/text/privacy.txt');
                            showTermOfService(context,privacy, 'Privacy Policy');
                            } 
                        )
                      ],
                    ),
                  ),
              
                SizedBox(height: 30,), 
                 Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                  Container(
                     width: screenSize.width > 360 ?  80 : 70,
                     padding:  EdgeInsets.only(bottom:5),
                     child: RawMaterialButton(
                     onPressed:() => _showDialog(context, model.loginWithGoogle),
                     child: Image.asset('assets/images/google_logo.png',
                       fit: BoxFit.cover,
                       width: screenSize.width > 360 ? 40 :  25,
                       height: screenSize.width > 360 ? 40 : 25,  
                       ),
                     shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(18.0),
                     side: BorderSide(color: Colors.white.withOpacity(0.5))),
                     elevation: 2.0,
                     fillColor: Colors.white,
                     padding: const EdgeInsets.all(18.0),
                      ),
                    ),
                  
                   Container(
                       width: screenSize.width > 360 ?  80 : 70,
                     padding:  EdgeInsets.only(bottom:5),
                     child: RawMaterialButton(
                     onPressed:model.navigateToSignUp ,
                     child: Image.asset('assets/images/email.png',
                       fit: BoxFit.cover,
                       width: screenSize.width > 360 ? 40 : 25,
                       height: screenSize.width > 360 ? 40 : 25,
                       ),
                     shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(18.0),
                     side: BorderSide(color: Colors.white.withOpacity(0.5))),
                     elevation: 2.0,
                     fillColor: Colors.white,
                     padding: const EdgeInsets.all(18.0),
                   ),
                 ),
                  Container(
                   width: screenSize.width > 360 ?  80 : 70,
                  padding:  EdgeInsets.only(bottom:5),
                 child: RawMaterialButton(
                   onPressed: () => _showDialog(context, model.loginWithFacebook) ,
                   child: Text('f',
                     style: TextStyle(color: Colors.white,
                         fontSize: screenSize.width > 360 ? 45 : 35,
                         fontWeight: FontWeight.bold),),
                   shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(18.0),
                   side: BorderSide(color: Colors.blue[900])),
                   elevation: 2.0,
                   fillColor: Colors.blue[900],
                   padding: const EdgeInsets.all(5.5),
                  ),
                ),            
                 ],),
              ],
            ),
          ),
            )),
    );
  }
}


void _showDialog(BuildContext context, Function navigator) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('I read term of service and privacy policy, I agree with the term of service and privacy policy',
          style: GoogleFonts.mcLaren(),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
             FlatButton(
              child:  Text("Disagree", style: GoogleFonts.mcLaren(color: Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
             FlatButton(
              child:  Text("Agree",
              style: GoogleFonts.mcLaren(),
              ),
              onPressed:() {
                Navigator.of(context).pop();
                navigator();  
              }
            ),
          ],
        );
      },
    );
  }




