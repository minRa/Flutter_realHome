import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:realhome/ui/shared/ui_helpers.dart';
import 'package:realhome/ui/widgets/busy_button.dart';
import 'package:realhome/ui/widgets/input_field.dart';
import 'package:realhome/ui/widgets/text_link.dart';
import 'package:realhome/view_model/login_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:realhome/ui/widgets/Input_Field_login.dart';






class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _rememberMe = false;
  
   _onRememberMeChanged(bool newValue) {
       setState(() {
         _rememberMe = newValue;
       });
       print(_rememberMe);
  }
  void _checkStart() async {
   SharedPreferences prefs = await  SharedPreferences.getInstance();
   setState(() {
      // print(prefs.getBool('rememberMe'));

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


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ViewModelProvider<LoginViewModel>.withConsumer(
      viewModel: LoginViewModel(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
            child:  SingleChildScrollView (
                child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[    
                      SizedBox(
                      height: 120,
                      child: Image.asset('assets/images/logo.png',
                      scale: 2 ,)
                    ),
                  //buildEmailTF(emailController),
                  InputField(
                    placeholder: 'Email',
                    controller: emailController,
                  ),
                //  buildPasswordTF(passwordController),

                  verticalSpaceSmall,
                  InputField(
                    placeholder: 'Password',
                    password: true,
                    controller: passwordController,
                  ),
                   Row(
                     children: <Widget>[
                       Checkbox(
                            value: _rememberMe,
                            onChanged: _onRememberMeChanged
                          ),
                          SizedBox(width: 10,),
                          Text('Remember Me',
                          style: GoogleFonts.mcLaren(),
                          )
                     ],
                   ),
                 // verticalSpaceMedium,
                  Column(children: <Widget>[
                    BusyButton(
                        title: 'Login',
                        busy: model.busy,
                        onPressed:() {
                           model.login(
                            email: emailController.text,
                            password: passwordController.text,
                            rememberMe : _rememberMe
                          );
                        } ,
                      ),
                      SizedBox(height: 15,),
                      // verticalSpaceMedium,
                  BusyButton(
                        title: 'Enter as A GUEST',
                        onPressed:model.nonUserEnter,
                      ),
                  SizedBox(height: 15,), // verticalSpaceMedium,
                  TextLink(
                    'Create an Account with your emaill',
                    onPressed:model.navigateToSignUp,
                  ),
                 SizedBox(height: 10,), // verticalSpaceMedium,
                   Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Container(
                          padding:  EdgeInsets.only(bottom:5),
                          child: new RawMaterialButton(
                          onPressed: model.loginWithGoogle,
                          child: Image.asset('assets/images/google_logo.png',
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,),
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white.withOpacity(0.5))),
                          elevation: 2.0,
                          fillColor: Colors.white,
                          padding: const EdgeInsets.all(18.0),
                        ),
                      ),
                
                    Container(
                       padding:  EdgeInsets.only(bottom:5),
                      child: new RawMaterialButton(
                        onPressed: model.loginWithFacebook,
                        child: Text('f',
                          style: TextStyle(color: Colors.white,
                              fontSize: 45,fontWeight: FontWeight.bold),),
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blue[900])),
                        elevation: 2.0,
                        fillColor: Colors.blue[900],
                        padding: const EdgeInsets.all(5.5),
                       ),
                     ),            
                   ],),               
                  ],),
                ],
              ),
            ),
          )),
    );
  }
}


