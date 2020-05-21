import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realhome/models/postProperty.dart';



class ListViewCard extends StatelessWidget {
  final bool onAuth;
  //final int index;
  final String id;
 // final Function navigate;
  final Function edit;
  final Function delete;
  final PostProperty userProperty;

  ListViewCard({
    this.onAuth,
    this.edit,
    this.delete,
    this.userProperty, 
    this.id, 
    //this.navigate
    });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
     key: ValueKey(id),
     background: Container(
        color: Colors.blueGrey[100], //Theme.of(context).cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.redAccent,
              size: 40,
            ),
            Text('Delete',
            style: GoogleFonts.mcLaren(color: Colors.redAccent)
            )
          ],
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: onAuth ?
       DismissDirection.endToStart : null,
      confirmDismiss: onAuth ?
      (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Delete Rent House',
                style: GoogleFonts.mcLaren(),
                textAlign: TextAlign.center,),
                content: Text(
                  'would you like to delete this house ?',
                  style: GoogleFonts.mcLaren(),
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                  ),
                ],
              ),
        );
      } : null,
      onDismissed: onAuth ?
      (direction) {
         delete();
      } : null,
///////////////////////////////////////////////////////////////////////////////////////////
      child: Column(
        children: <Widget>[
          ListTile(
          contentPadding:EdgeInsets.only(left:20, right: 20, top: 10, bottom: 10) ,
          leading: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                  width: 90 ,
                  height: 72 ,
                  child: Image.network(userProperty.imageUrl[0],
                  fit: BoxFit.cover,
                    loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null ? 
                              loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                              : null,
                            ),
                          );
                        },
                      ) ,
                   ),     
                ),
              ),
             title: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${userProperty.title}',
                      style: GoogleFonts.mcLaren(fontSize: 16,fontWeight: FontWeight.bold ),
                      textAlign: TextAlign.left,
                      maxLines: 5,
                    ),
                  ), 

              subtitle:  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${userProperty.city} \$${userProperty.price}',
                      style: GoogleFonts.mcLaren(fontSize: 13,fontWeight: FontWeight.normal ),
                      textAlign: TextAlign.left,
                      maxLines: 5,
                    ),
                  ),

              trailing: !onAuth ? 
             SizedBox()
            :Container(
              //padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child:
                  IconButton(
                    icon:Icon(Icons.edit, size: 24.0,),
                    color: Colors.blueGrey,
                    tooltip: 'Edit',
                    onPressed: edit,                   
                  ),
                  ),            
                ),
            Divider()
        ],
      ),
    );
  }
}
