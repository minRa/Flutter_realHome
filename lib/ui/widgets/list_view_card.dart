import 'package:flutter/material.dart';
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
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Delete Rent House',
                textAlign: TextAlign.center,),
                content: Text(
                  'would you like to delete this house ?',
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
      },
      onDismissed: (direction) {
         delete();
      },
///////////////////////////////////////////////////////////////////////////////////////////
      child: Card(
      margin: EdgeInsets.only(top:10, bottom:10, left:20, right:20),
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Container(
                width: 90 ,
                height: 72 ,
                //  decoration: BoxDecoration(
                //    borderRadius: BorderRadius.only(
                //      topLeft: Radius.circular(100.0),
                //      topRight:Radius.circular(100.0) ,
                //      bottomLeft: Radius.circular(100.0),
                //      bottomRight: Radius.circular(100.0),
                //    )
                //    ),
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
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top:10.0,right: 20,),
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${userProperty.title}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.left,
                    maxLines: 5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top:4),
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${userProperty.city} \$${userProperty.price}',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 16),
                    textAlign: TextAlign.left,
                    maxLines: 5,
                  ),
                ),
              ],
            ),
          ),
           !onAuth ? 
           SizedBox()
          :Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: IconButton(
              icon:Icon(Icons.edit, size: 24.0,),
              color: Colors.blueGrey,
              tooltip: 'Edit',
              onPressed: edit,                   
            )),  
        ],
      ),
   ),
    );
  }
}
