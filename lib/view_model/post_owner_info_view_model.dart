import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';
const adUnitId = 'ca-app-pub-7333672372977808/6055396710';

class PostOwnerInfoViewModel extends BaseModel {
  final NavigationService _navigationService = 
   locator<NavigationService>();

final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();
final FirestoreService _firestoreService = locator<FirestoreService>();

 List <PostProperty> _posts;
 List<PostProperty> get posts => _posts;

 void currentOwnerPostPropertyList(owner) async {
      await _googleAdsService.bottomBanner(adUnitId);

    _posts = await _firestoreService.getUserPropertyListFromFirebase(owner);
    notifyListeners();

  }

      navigateToDetailView(int index) {
    _navigationService.navigateTo(DetailViewRoute, arguments: _posts[index]);
    }




}