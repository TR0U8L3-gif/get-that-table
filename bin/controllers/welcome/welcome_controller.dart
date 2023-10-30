import 'dart:io';

import '../../models/console_controller.dart';
import '../route_controller/route_controller.dart';

class WelcomeController extends ConsoleController{

  @override
  void getInput(String? input){
    if(input == null) return;
    if(input.isEmpty){
      RouteController.getInstance().toRoute(Route.home);
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



}