import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/models/user.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';


class PostOwnerInfoViewModel extends BaseModel {
  final NavigationService _navigationService = 
   locator<NavigationService>();

final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();
final FirestoreService _firestoreService = locator<FirestoreService>();

 List <PostProperty> _posts;
 List<PostProperty> get posts => _posts;

 void currentOwnerPostPropertyList(owner) async {
      await _googleAdsService.bottomBanner();

    _posts = await _firestoreService.getUserPropertyListFromFirebase(owner);
    notifyListeners();

  }

      navigateToDetailView(int index) {
    _navigationService.navigateTo(DetailViewRoute, arguments: _posts[index]);
    }


   

       navigateToChatView(User peerUser) {
         final List<User> users = List<User>.generate(2, (i) => null);
         users[0] = currentUser;
         users[1] = peerUser;
        _navigationService.navigateTo(ChatViewRoute, arguments:  users);
   }




}