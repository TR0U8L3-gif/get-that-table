import 'package:dart_console/dart_console.dart';
import 'package:firedart/firedart.dart';

import '../../models/restaurant/restaurant_model.dart';
import '../../models/restaurantTable/restaurant_table_model.dart';
import '../_impl/console_controller_impl.dart';
import '../route/route_controller.dart';

class ChooseTableController extends ConsoleControllerImpl {
  bool isLoading = true;
  bool isError = false;
  bool updateView = true;
  
  Restaurant? restaurant;
  RestaurantTable? table;

  updateRestaurant(){
    isLoading = true;
    isError = false;

    try{
      restaurant = RouteController.getInstance().param as Restaurant;
    } catch (e) {
      restaurant = null;
      isError = true;
    }
    updateView = false;
    RouteController.getInstance().newRouteNotification();
    
    if(!isError) updateTable();
  }

  Future<void> updateTable() async {
    if(restaurant == null){
      isLoading = false;
      isError = true;
      updateView = true;
      RouteController.getInstance().newRouteNotification();
      return;
    }
    updateView = false;
  
    await Firestore.instance.collection('tables').document(restaurant!.id).get().then((value) { 
      table = RestaurantTable.fromJson(value.map);
      isLoading = false;
      isError = false;
      RouteController.getInstance().newRouteNotification();
    }).onError((error, stackTrace) {
      isLoading = false;
      isError = true;
      RouteController.getInstance().newRouteNotification();
    });
  }

  @override
  void getInput(String input) {
    if(input.isEmpty){
      RouteController.getInstance().newRouteNotification();
      return;
    }

    if(input == "back"){
      updateView = true;
      RouteController.getInstance().toPreviosRoute();
      return;
    }
    RouteController.getInstance().newRouteNotification();
  }

  @override
  void getKey(Key input) {
    super.getKey(input);
    RouteController.getInstance().newRouteNotification();
  }

}