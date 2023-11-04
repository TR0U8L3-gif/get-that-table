import 'package:dart_console/dart_console.dart';
import 'package:dart_console/src/key.dart';
import 'package:firedart/firestore/firestore.dart';

import '../_impl/console_controller_impl.dart';
import '../../models/restaurant/restaurant_model.dart';
import '../route/route_controller.dart';

class ChooseRestaurantController extends ConsoleControllerImpl{
  bool isLoading = true;
  bool isError = false;
  bool updateView = true;
  int index = 0;
  List<Restaurant> restaurants = [];

  void updateIndex(int num){
    index += num;
    if(index < 0){
      updateView = true;
      index = 0;
    }
    if(index > restaurants.length) index = restaurants.length;
  }

  Future<void> getRestaurants() async {
    isLoading = true;
    isError = false;
    index = 0;
    await Firestore.instance.collection('restaurants').get().then((value) {
      restaurants = [];
      for (var doc in value) {
        restaurants.add(Restaurant.fromJson(doc.map));
      }
      isLoading = false;
      updateView = false;
      RouteController.getInstance().newRouteNotification();
    }).onError((error, stackTrace) {
      isLoading = false;
      isError = true;
      updateView = true;
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
      RouteController.getInstance().toPreviosRoute();
      return;
    }
    RouteController.getInstance().newRouteNotification();
  }

  @override
  void getKey(Key input) {
    super.getKey(input);
    if(input.isControl){
      if(input.controlChar == ControlCharacter.arrowUp){
        updateIndex(-1);
      }
      if(input.controlChar == ControlCharacter.arrowDown){
        updateIndex(1);
      }
      if(input.controlChar == ControlCharacter.ctrlB){
        updateView = true;
        index = 0;
        RouteController.getInstance().toPreviosRoute();
        return;
      }
      if(input.controlChar == ControlCharacter.ctrlE){
        isError = true;
        RouteController.getInstance().newRouteNotification();
        return;
      }
      if(input.controlChar == ControlCharacter.enter){
        if(index >= restaurants.length){
          updateView = true;
          index = 0;
          RouteController.getInstance().toPreviosRoute();
          return;
        } 
        else {
          RouteController.getInstance().toRoute(Route.chooseTable, restaurants[index]);
          return;
        }
      }
    }
    RouteController.getInstance().newRouteNotification();
  }
}