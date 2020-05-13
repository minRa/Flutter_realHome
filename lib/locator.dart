
import 'package:get_it/get_it.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/cloud_storage_service.dart';
import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/services/firebase_message_service.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/services/googleMap_service.dart';
//import 'package:realhome/services/googleMap_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/utils/image_selector.dart';


GetIt locator = GetIt.instance;

Future setupLocator() async {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(() => ImageSelector());
  locator.registerLazySingleton(() => GoogleAdsService());
  locator.registerLazySingleton(() => GoogleMapServices());
  locator.registerLazySingleton(() => FirebaseMessageService());
}
