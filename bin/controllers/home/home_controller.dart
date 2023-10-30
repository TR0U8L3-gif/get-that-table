import 'package:firedart/firestore/firestore.dart';

import '../../models/console_controller.dart';
import '../../models/restaurant_model.dart';
import '../route_controller/route_controller.dart';

class HomeController extends ConsoleController{
  bool isLoading = true;
  bool isError = false;
  List<Restaurant> restaurants = [];


  Future<void> getRestaurants() async {
    isLoading = true;
    isError = false;
    await Firestore.instance.collection('restaurants').get().then((value) {
      restaurants = [];
      for (var doc in value) {
        restaurants.add(Restaurant.fromJson(doc.map));
      }
      isLoading = false;
      RouteController.getInstance().newRouteNotification();
    }).onError((error, stackTrace) {
      isError = true;
      RouteController.getInstance().newRouteNotification();
    });
  }
  
  @override
  void getInput(String? input) {
    if(input == null || input.isEmpty){
      RouteController.getInstance().newRouteNotification();
      return;
    }

    if(input == "back"){
      RouteController.getInstance().toPreviosRoute();
      return;
    }
    RouteController.getInstance().newRouteNotification();
  }
}