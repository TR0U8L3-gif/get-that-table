import 'package:firedart/firedart.dart';

import 'models/route_listener_model.dart';
import 'controllers/route_controller/route_controller.dart';

void main(List<String> arguments) {
  Firestore.initialize("get-that-table-d392b");
  RouteController routeController = RouteController.getInstance();
  RouteListener routeListener = RouteListener();
  
  routeController.getService().subscribe(routeListener);
  routeController.toRoute(Route.welcome);

}
