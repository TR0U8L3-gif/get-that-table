import 'package:firedart/firedart.dart';

import 'controllers/admin/admin_controller.dart';
import 'models/route_listener_model.dart';
import 'controllers/route_controller/route_controller.dart';

void main(List<String> arguments) {
  Firestore.initialize("get-that-table-d392b");
  RouteController routeController = RouteController.getInstance();
  RouteListener routeListener = RouteListener();
  
  routeController.getService().subscribe(routeListener);
  routeController.toRoute(Route.welcome);


  // while(true){
  // }
    // print("enter data: ");
    // String input = stdin.readLineSync() ?? "";
    // if(input.isNotEmpty){
    //   print("input: $input");
    //   if(input.length%2 == 0){
    //     routeController.toRoute(Route.welcome);
    //   } else {
    //     routeController.toRoute(Route.home);
    //   }
    // }
  
  
  // await firestore.collection('restaurants').get().then((event) {
  //   for(var doc in event){
  //     print(doc.id);
  //     print(doc.map);
  //   }
  // });

}