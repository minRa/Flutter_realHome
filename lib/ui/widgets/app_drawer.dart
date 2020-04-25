import 'package:flutter/material.dart';
import 'package:realhome/models/user.dart';

class AppDrawer extends StatelessWidget {

  final Function home;
  final Function mebership;
  final Function property;
  final Function logout;
  final User currentUser;

  AppDrawer({
  this.home, 
  this.mebership, 
  this.property, 
  this.logout,
  this.currentUser
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: currentUser !=null ?
       Column(
        children: <Widget>[
          AppBar(
            title: Text('User Service'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.view_list),
            title: Text('Rent House List'),
            onTap: home
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Membership'),
            onTap: mebership
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage My Property'),
            onTap: property
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: logout
          ),
        ],
      ) :
       Column(
       children: <Widget>[
        AppBar(
        title: Text('User Service'),
        automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
            leading: Icon(Icons.view_list),
            title: Text('Rent House List'),
            onTap: home
          ),
        Divider(),
        Container(
         margin: EdgeInsets.symmetric(vertical: 150),
         child: Center(
         child: Text('Login required to use User service !'),
         )
        )
      ]
    )  
  );
 }
}
