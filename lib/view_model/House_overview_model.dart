
import 'dart:async';
import 'package:realhome/constants/route_names.dart';
import 'package:realhome/locator.dart';
import 'package:realhome/models/postProperty.dart';
import 'package:realhome/services/firestore_service.dart';
import 'package:realhome/services/navigation_service.dart';
import 'package:realhome/view_model/base_model.dart';
const adUnitId = 'ca-app-pub-7333672372977808/8753848294';

class HouseOverviewModel extends BaseModel {
  
  final FirestoreService _firestoreService = locator<FirestoreService>();
   final NavigationService _navigationService = 
   locator<NavigationService>();
 

  

  List<PostProperty> _postProperty;
  List<PostProperty> get postProperty => _postProperty;
  // List<User> _userList;
  // List<User> get userList => _userList;

  List<String> _cities;
  List<String> get cities => _cities;
  bool finish;
  updateCity(String city) {
      var post =_postProperty.singleWhere((c) => c.city == city);
       print(post);
  }
   
   //bool _first = true;

 //Timer timer;
 bool _show = false;
 bool get show => _show;
 bool data;
 bool _onLoading = false;
 bool get onLoading => _onLoading;
 
Future<void> listenToPosts() async {  

           data = false;
          _onLoading = true;
          notifyListeners();
        //   if(_firestoreService.count == 0) {
        //       _firestoreService.count++;
        //     _show = true;
        //     notifyListeners();
        //     timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
        //       _show = false;
        //       notifyListeners();
        //   });
        //  }
        await getCities();  
        await tryTofindData();
        
      
       if(data == false) {
           if(_firestoreService.allPropertyPagedResults !=null 
           &&_firestoreService.allPropertyPagedResults.length > 0) {
                
              List<PostProperty> temp = List<PostProperty>();  
              await Future.forEach(_firestoreService.allPropertyPagedResults, (element){
                 temp+= element;
              });
              _postProperty = temp; 
               data = true;
               notifyListeners();
           }       
        } 

        if(_cities !=null && _cities.length > 0) { 
           if(data) {
             _onLoading = false;
           }
        } else {
         _onLoading = false; 
        } 

        notifyListeners();      
  }

  Future getPostProperty(List<PostProperty> post) async {
     if(post != null && post.length > 0) {
     _postProperty = post; 
      data = true; 
     }
    _onLoading = false; 
     notifyListeners();
  }

  Future tryTofindData() async {
       _firestoreService.listenToPostPropertyRealTime().listen((postsData) async{
          await getPostProperty(postsData);
          });
  }
  
   int _total = 0;
   int get total => _total;

   Future<void> getCities() async {
      //    print('i am GOGING ====================>!!!!!!!!!!!!!!!');
        List<PostProperty> posts = await  _firestoreService.getPropertyListFromFirebase('All City', 'All Type');
        _total = posts.length;
        _cities = List<String>.generate(posts.length + 1, (i)=>'');
        if(posts.length > 0) {    
          _cities[0] ='All City';
          for(var i =0; i<posts.length; i++) {
          if(_cities.contains(posts[i].city)) continue;
          _cities[i+ 1] = posts[i].city;
        } 
        for(var i=0; i< _cities.length; i++){
            if(_cities.contains(''))
             _cities.remove('');
        } 
        notifyListeners();   
      }
   }
    

    Future<void> updatePostCodition(String city, String type) async{
       _postProperty = await _firestoreService.getPropertyListFromFirebase(city, type);
        _total = _postProperty.length;
        notifyListeners();
    }





      navigateToDetailView(int index) {
     _navigationService.navigateTo(
      DetailViewRoute, arguments: _postProperty[index]);
    }





    void requestMoreData() => _firestoreService.requestMoreData();
  }


