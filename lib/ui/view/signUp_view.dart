import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/ui/shared/ui_helpers.dart';
import 'package:realhome/ui/widgets/busy_button.dart';
import 'package:realhome/ui/widgets/input_field.dart';
import 'package:realhome/ui/widgets/term_of_service.dart';
import 'package:realhome/ui/widgets/text_link.dart';
import 'package:realhome/view_model/signup_overview_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  bool _agreement = false;

  @override
  void dispose() {
   emailController.dispose();
   passwordController.dispose();
   fullNameController.dispose();
    super.dispose();
  }
     _onAgreementChanged(bool newValue) {
       setState(() {
         _agreement = newValue;
       });
  }

    Future<String> getFileData(String path) async {
     var data = await rootBundle.loadString(path);
     return data.toString();
}


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size/ 1;
    return ViewModelProvider<SignUpViewModel>.withConsumer(
      viewModel: SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: SingleChildScrollView(
            padding: screenSize.height > 700 ?
             EdgeInsets.only(top:50)
             :EdgeInsets.only(top:0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 SizedBox(
                  child: Image.asset('assets/images/signup.png',
                  scale: 2 ,)
                ),
                InputField(
                  placeholder: 'Full Name',
                  controller: fullNameController,
                ),
                verticalSpaceSmall,
                InputField(
                  placeholder: 'Email',
                  controller: emailController,
                ),
                verticalSpaceSmall,
                InputField(
                  placeholder: 'Password',
                  password: true,
                  controller: passwordController,
                  additionalNote: 'Password has to be a minimum of 6 characters.',
                ),
                 Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                       Checkbox(
                            value: _agreement,
                            onChanged: _onAgreementChanged
                          ),
                          SizedBox(width: 5,),
                          Container(
                             width: screenSize.width <= 320 ? 160 :
                             screenSize.width <= 375 ? 200 : 250 ,
                            child: Text('I read term of service and privacy policy, I agree with the term of service and privacy policy',
                            style: GoogleFonts.mcLaren(),
                            ),
                          )
                     ],
                   ),
                verticalSpaceSmall,
                  Container(
                      child:
                       MediaQuery.of(context).size.width >= 360 ?
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
                    ) : Row (
                      children: [
                         TextLink(
                          'term of service',
                          onPressed: ()async {
                            String term =  await getFileData('assets/text/term.txt'); 
                              showTermOfService(context,term,'Terms of Services ');
                            } 
                        ),
                        Text('&',
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
                    ),
                  ),

                verticalSpaceMedium,
                BusyButton(
                  title: 'Sign Up',
                  busy: model.busy,
                  enabled: _agreement,
                  onPressed: () {
                  if(!_agreement) return;
                    model.signUp(
                        email: emailController.text,
                        password: passwordController.text,
                        fullName: fullNameController.text);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}






            