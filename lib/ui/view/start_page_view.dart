
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:realhome/ui/view/house_overview.dart';
import 'package:realhome/ui/view/login_view.dart';
import 'package:realhome/ui/view/membership_view.dart';
import 'package:realhome/ui/view/property_manage_view.dart';
import 'package:realhome/ui/view/settings.dart';
import 'package:realhome/view_model/start_page_view_model.dart';


class StartPageView extends StatefulWidget {
  @override
  _StartPageViewState createState() => _StartPageViewState();
}

class _StartPageViewState extends State<StartPageView> with TickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartPageViewModel>.withConsumer(
      viewModel: StartPageViewModel(), 
      onModelReady: (model) => print(model.currentUser),
      builder: (context, model, child) => DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                 tabs: [
                  Tooltip(
                   message:'Home' ,
                  child: Tab(icon: Icon(Icons.home,
                  color: _tabController.index == 0
                  ? Colors.black
                  : Colors.blueGrey)),
                  ),
                      
                 Tooltip(
                   message:'Mangement' ,
                  child: Tab(icon: Icon(Icons.settings_system_daydream,
                  color: _tabController.index == 1
                      ? Colors.red
                      : Colors.blueGrey)),
                  ),

                 Tooltip(
                   message:'Event' ,
                  child: Tab(icon: Icon(Icons.card_membership,
                  color: _tabController.index == 2
                      ? Colors.green
                      : Colors.blueGrey)),
                  ), 
                
                  model.currentUser != null ?
                 Tooltip(
                   message:'Settings' ,
                  child: Tab(icon: Icon(Icons.settings,
                  color: _tabController.index == 3
                      ? Colors.deepPurple
                      : Colors.blueGrey)),
                  ) :
                  Tooltip(
                   message:'Login' ,
                  child: Tab(icon: Icon(Icons.person,
                  color: _tabController.index == 3
                      ? Colors.deepPurple
                      : Colors.blueGrey)),
                  ),

                ],
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            HouseOverview(),
            PropertyManageView(),
            MembershipView(),
            model.currentUser != null ?
            Settings() : LoginView()
          ] 
        ),
      ),)
    );
  }
}


