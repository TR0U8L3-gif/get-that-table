import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import 'controllers/route_controller/route_controller.dart';
import 'models/route_listener_model.dart';
import 'dart:io';

void main(List<String> arguments) {
  RouteController routeController = RouteController.getInstance();
  RouteListener routeListener = RouteListener();
  routeController.getService().subscribe(routeListener);
  print(ascii_art.getLogoAscii());
  while(true){
    String input = stdin.readLineSync() ?? "";
    if(input.isNotEmpty){
      print("input: $input");
      if(input.length%2 == 0){
        routeController.toRoute(Route.welcome);
      } else {
        routeController.toRoute(Route.home);
      }
    }
  }
  
}
