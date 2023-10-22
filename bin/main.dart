import 'dart:convert';
import 'dart:io';

import 'package:firedart/firedart.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import 'models/route_listener_model.dart';
import 'controllers/route_controller/route_controller.dart';

Future<void> main(List<String> arguments) async {
  RouteController routeController = RouteController.getInstance();
  RouteListener routeListener = RouteListener();
  routeController.getService().subscribe(routeListener);

  Firestore.initialize("get-that-table-d392b"); 
  Firestore firestore = Firestore.instance;


  print(ascii_art.getLogoAscii());
  // while(true){
  //   String input = stdin.readLineSync() ?? "";
  //   if(input.isNotEmpty){
  //     print("input: $input");
  //     if(input.length%2 == 0){
  //       routeController.toRoute(Route.welcome);
  //     } else {
  //       routeController.toRoute(Route.home);
  //     }
  //   }
  // }
  
  // await firestore.collection('restaurants').get().then((event) {
  //   for(var doc in event){
  //     print(doc.id);
  //     print(doc.map);
  //   }
  // });

}
