import 'dart:io';

import 'package:dart_console/src/key.dart';

import '../_impl/console_controller_impl.dart';
import '../route/route_controller.dart';

class WelcomeController extends ConsoleControllerImpl{

  @override
  void getInput(String input) {
    if(input.isEmpty){
      RouteController.getInstance().toRoute(Route.chooseRestaurant);
      return;
    }
    if(input == "admin"){
      RouteController.getInstance().toRoute(Route.admin);
    }
    if(input == "exit"){
      exit(0);
    }
    RouteController.getInstance().newRouteNotification();
  }

  @override
  void getKey(Key input) {
    super.getKey(input);
    RouteController.getInstance().newRouteNotification();
  }

}