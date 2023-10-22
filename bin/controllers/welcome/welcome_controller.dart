import 'dart:io';

import '../route_controller/route_controller.dart';

class WelcomeController{
  int offset = 0;

  void getInput(String? input){
    if(input == null) return;
    if(input.isEmpty){
      RouteController.getInstance().toRoute(Route.home);
      return;
    }
    if(input == "exit"){
      exit(0);
    }
    offset++;
    RouteController.getInstance().newRouteNotification();
  }



}