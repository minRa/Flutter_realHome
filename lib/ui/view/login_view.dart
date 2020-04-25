import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:realhome/ui/shared/ui_helpers.dart';
import 'package:realhome/ui/widgets/busy_button.dart';
import 'package:realhome/ui/widgets/input_field.dart';
import 'package:realhome/ui/widgets/text_link.dart';
import 'package:realhome/view_model/login_view_model.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                      child: Row (
                      children: <Widget>[
                        Hero(
                           tag: 'logo',
                           child: Image.asset('assets/images/logo.png',
                           scale: 2 ,),
                        ),
                        Image.asset('assets/images/title.jpg',
                        scale: 1.4,),
                      ],
                      )
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
                  verticalSpaceMedium,
                  Column(children: <Widget>[
                    BusyButton(
                        title: 'Login',
                        busy: model.busy,
                        onPressed:() {
                           model.login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        } ,
                      ),
                       verticalSpaceMedium,
                  BusyButton(
                        title: 'Enter as A GUEST',
                        onPressed:model.nonUserEnter,
                      ),
                  verticalSpaceMedium,
                  TextLink(
                    'Create an Account if you\'re new.',
                    onPressed:model.navigateToSignUp
                  ),
                  verticalSpaceMedium,
                   Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Container(
                  child: new RawMaterialButton(
                    onPressed: model.loginWithGoogle,
                    child: Image.asset('assets/images/google_logo.png',
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(18.0),
                  ),
                ),

                 Container(
                  child: new RawMaterialButton(
                    onPressed: model.loginWithFacebook,
                    child: Text('f',
                      style: TextStyle(color: Colors.white,
                          fontSize: 45,fontWeight: FontWeight.bold),),
                    shape: new CircleBorder(),
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


