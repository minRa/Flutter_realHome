import 'package:flutter/material.dart';
import 'package:realhome/constants/route_names.dart';
import 'package:realhome/ui/view/detail_view.dart';
import 'package:realhome/ui/view/house_overview.dart';
import 'package:realhome/ui/view/login_view.dart';
import 'package:realhome/ui/view/membership_view.dart';
import 'package:realhome/ui/view/post_house_view.dart';
import 'package:realhome/ui/view/post_owner_info_view.dart';
import 'package:realhome/ui/view/property_manage_view.dart';
import 'package:realhome/ui/view/signUp_view.dart';
import 'package:realhome/ui/view/bigImage.dart';
import 'package:realhome/ui/view/start_page_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {

  switch(settings.name) {
    case HouseOverviewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HouseOverview(),
      );

        case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );

      case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );

      case DetailViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: DetailView(settings.arguments),
      );

      case PostHouseViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: PostHouseView(settings.arguments),
      );
      case StartPageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: StartPageView(),
      );

       case PropertyManageViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: PropertyManageView(),
      );

      case BigImageViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: BigImageView(
          data: settings.arguments)
      );

       case MembershipViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: MembershipView(),
      );

      case PostOwnerInfoViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: PostOwnerInfoView(settings.arguments),
      );



    default:
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
      ));

  }

}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
