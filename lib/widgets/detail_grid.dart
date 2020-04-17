import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realhome/providers/image_provider.dart';
import 'package:realhome/widgets/image_form.dart';

class DetailGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final imageData = Provider.of<ImageFiles>(context);
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: imageData.images.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: imageData,
          child: ImageForm(
          id: imageData.images[i].id,
          image: imageData.images[i].image
        ),
      ),
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
     ),
    );
  }
}