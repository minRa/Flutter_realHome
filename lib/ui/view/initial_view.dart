
import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:realhome/ui/widgets/loading_widgets.dart';
import 'package:realhome/view_model/initial_view_model.dart';

class InitialView extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<InitialViewModel>.withConsumer(
      viewModel: InitialViewModel(), 
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => Scaffold(
      backgroundColor: Colors.white,
      body: Container( 
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.symmetric(),
        color: Colors.blueAccent,     
        child: LodingWidget(model.navigateToLogin),
      ),
      ),
    );
  }
}

