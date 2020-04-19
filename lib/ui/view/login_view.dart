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
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 150,
                  child: Image.asset('assets/images/title.png'),
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BusyButton(
                      title: 'Login',
                      busy: model.busy,
                      onPressed: () {
                        model.login(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      },
                    )
                  ],
                ),
                verticalSpaceMedium,
                TextLink(
                  'Create an Account if you\'re new.',
                  onPressed:model.navigateToSignUp
                ),
                verticalSpaceMedium,
                BusyButton(
                      title: 'Enter as a Gest',
                      onPressed:model.nonUserEnter ,
                    )
              ],
            ),
          )),
    );
  }
}
