
import 'package:realhome/locator.dart';
import 'package:realhome/services/dialog_service.dart';
import 'package:realhome/view_model/base_model.dart';

class PropertyManageViewModel extends BaseModel {

final DialogService _dialogService = locator<DialogService>();
Future <void> nonUserAddPost () async {
   var dialogResponse = await _dialogService.showConfirmationDialog(
          title: ' Rent House - login required',
          description: 'Would you like to login?',
          confirmationTitle: 'OK',
          cancelTitle: 'CANCEL'        
        );
    
    if(dialogResponse.confirmed) {   
      navigateToLogin();
      
    }
  } 
}