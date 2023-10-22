import 'package:dart_console/dart_console.dart';

import '../controllers/route_controller/route_controller.dart';

class RouteListener {
  void update(){
    //print("update recived ${DateTime.now()}");
    RouteController.getInstance().getScreen().consolePrint();
  }
}