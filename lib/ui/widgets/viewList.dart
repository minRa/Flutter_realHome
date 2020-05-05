//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realhome/models/postProperty.dart';


class HorizontalList extends StatelessWidget {
  
  final PostProperty post;
  HorizontalList (
    this.post);
     //data['profileUrl']
  @override
  Widget build(BuildContext context) {
    //print(userList);
    return  Card(
             // color: Colors.indigo.withOpacity(0.01),
             child: Column(
               children: <Widget>[
               Container(
                //  decoration: BoxDecoration(
                //  borderRadius: BorderRadius.only(
                //    bottomLeft: Radius.circular(10.0),
                //    bottomRight: Radius.circular(10.0),
                //  )
                //  ),
                // color: Colors.blueGrey.withOpacity(0.1),
               //padding: const EdgeInsets.fromLTRB(0,10,0,0),
                margin: EdgeInsets.only(top:10, bottom:10),
                child: ListTile(
                // leading: ClipRRect(
                // borderRadius: BorderRadius.circular(30.0),
                // child:
                // user.profileUrl != null ?
                // Image.network(user.profileUrl,
                //    height: 100,
                //    fit: BoxFit.cover,
                //    width: 60) :
                //    Image.asset('assets/images/avata.png',
                //    height: 100,
                //    fit: BoxFit.cover,
                //    width: 60
                //   ),),
                   title: Text(post.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                     onTap: () {},
                     subtitle: 
                          Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: <Widget>[
                             Text(post.city,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                             Text('\$${post.price}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                             Row(
                               children: <Widget>[
                                   Icon(Icons.hotel),
                                   Text('  ${post.room}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                               ],
                             ),
                              Row(
                               children: <Widget>[
                                   Icon(Icons.airline_seat_recline_extra),
                                   Text('  ${post.toilet}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                               ],
                             ),
                              Row(
                               children: <Widget>[
                                   Icon(Icons.time_to_leave),
                                   Text('  ${post.carpark}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                   ],
                                  )
                              ],),
                              ),
                            ),     
                        Container(
                         height: 200,
                         child: ListView.builder(
                         scrollDirection: Axis.horizontal,
                         itemCount: post.imageUrl.length,
                         itemBuilder: (ctx, i) => Container (
                         //color: Colors.blueGrey,
                         //padding: EdgeInsets.all(1),
                         width: 200,
                         child: Image.network(
                           post.imageUrl[i], 
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
                            ),
                           )    
                      ),    
                    ),
                  ], 
                )      
            );
          }
}




