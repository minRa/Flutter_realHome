import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/ui/shared/ui_helpers.dart';
import 'package:realhome/ui/widgets/busy_button.dart';
import 'package:realhome/ui/widgets/input_field.dart';
import 'package:realhome/ui/widgets/text_link.dart';
import 'package:realhome/view_model/signup_overview_model.dart';

class SignUpView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpViewModel>.withConsumer(
      viewModel: SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               SizedBox(
                      height: 120,
                      child: Image.asset('assets/images/logo.png',
                      scale: 2 ,)
                    ),
              // Text(
              //   '-- Sign Up --',
              //   style: TextStyle(
              //     fontSize: 15,
              //   ),
              // ),
            //  verticalSpaceLarge,
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
              verticalSpaceSmall,
               TextLink(
                  'Back to Login if you don\'t wanna sign-up.',
                  onPressed: () {
                    model.navigateToLogin();
                  },
                ),
              // ExpansionList<String>(
              //     items: ['Admin', 'User'],
              //     title: model.selectedRole,
              //     onItemSelected: model.setSelectedRole),
              verticalSpaceMedium,
              BusyButton(
                title: 'Sign Up',
                busy: model.busy,
                onPressed: () {
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
    );
  }
}






            