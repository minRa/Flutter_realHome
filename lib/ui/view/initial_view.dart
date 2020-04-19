
import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:realhome/view_model/initial_view_model.dart';

class InitialView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<InitialViewModel>.withConsumer(
      viewModel: InitialViewModel(), 
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => Scaffold(
      backgroundColor: Colors.white,
      body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 100,
                child: Image.asset('assets/images/icon_large.png'),
              ),
              CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
      ),
    );
  }
}