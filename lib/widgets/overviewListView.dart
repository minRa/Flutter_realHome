import 'package:flutter/material.dart';
import 'package:realhome/widgets/horizontal_overview.dart';

class OverviewListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, i) => HorizontalOverview(),
      itemCount: 5,
    );
  }
}