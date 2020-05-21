
import 'package:get_it/get_it.dart';
import 'package:realhome/services/AnalyticsService.dart';
import 'package:realhome/services/authentication_service.dart';
import 'package:realhome/services/cloud_storage_service.dart';
import 'package:realhome/services/dataCenter.dart';
import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/services/firebase_message_service.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/services/googleMap_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/services/remote_config_service.dart';



GetIt locator = GetIt.instance;

Future setupLocator() async {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(() => GoogleAdsService());
  locator.registerLazySingleton(() => GoogleMapServices());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => FirebaseMessageService());
  locator.registerLazySingleton(() => DataCenter());


  
  var remoteConfigService = await RemoteConfigService.getInstance();
  locator.registerSingleton(remoteConfigService);
}
