import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/view_model/membership_view_model.dart';

class MembershipView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MembershipViewModel>.withConsumer(
      viewModel: MembershipViewModel(), 
      //onModelReady: 
      builder: (context, model, child) => Scaffold(
        body: Container(),
      )
    );
  }
}