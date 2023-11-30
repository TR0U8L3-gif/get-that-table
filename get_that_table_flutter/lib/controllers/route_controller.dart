import 'package:flutter/material.dart';

import '../views/admin_screen.dart';
import '../views/choose_restaurant_screen.dart';
import '../views/choose_table_screen.dart';
import '../views/edit_reservation_screen.dart';
import '../views/get_reservation_screen.dart';
import '../views/welcome_screen.dart';

enum Route {
  welcome,
  chooseRestaurant,
  chooseTable,
  getReservation,
  editReservation,
  admin,
}

abstract class RouteControllerImp {
  Widget getWidget();
  Route getRoute();
  /// go to `destination` route
  void toRoute(BuildContext context, Route destination);
  /// go to `destination` route and delete previous one
  void offRoute(BuildContext context, Route destination);
  /// go back until `destination` route is found
  void offUntilRoute(BuildContext context, Route destination);
  /// go to `destination` route and delete all previous routes
  void offAllRoute(BuildContext context,  Route destination);
  /// go to previos route
  void toPreviousRoute(BuildContext context);
}

class RouteController implements RouteControllerImp{
  static final RouteController _routeController = RouteController._();
  final Map<Route, Widget> _routesMap = {
    Route.welcome : const WelcomeScreen(),
    Route.admin : const AdminScreen(),
    Route.chooseRestaurant : const ChooseRestaurantScreen(),
    Route.chooseTable : const ChooseTableScreen(),
    Route.getReservation : const GetReservationScreen(),
    Route.editReservation : const EditReservationScreen(),
  };
  final List<Route> _routesTree = [Route.welcome];
  Object? param;
  RouteController._();


  static RouteController getInstance() {
    return _routeController;
  }

  @override
  Widget getWidget(){
    return _routesMap[getRoute()] ?? const WelcomeScreen();
  }

  @override
  Route getRoute() {
    return _routesTree.last;
  }


  @override
  void toRoute(BuildContext context, Route destination, [Object? param]) {
    this.param = param;
    _routesTree.add(destination);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => getWidget()));
  }

  @override
  void offAllRoute(BuildContext context, Route destination, [Object? param]) {
    this.param = param;
    _routesTree.clear();
    _routesTree.add(destination);
    Navigator.of(context).popUntil((route) => false);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => getWidget()));
  }

  @override
  void offRoute(BuildContext context, Route destination, [Object? param]) {
    this.param = param;
    _routesTree.removeLast();
    Navigator.of(context).pop();
    _routesTree.add(destination);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => getWidget()));
  }

  @override
  void offUntilRoute(BuildContext context, Route destination, [Object? param]) {
    this.param = param;
    while(_routesTree.last != destination && _routesTree.isNotEmpty){
      _routesTree.removeLast();
      Navigator.of(context).pop();
    }
    if(_routesTree.isEmpty){
      _routesTree.add(Route.welcome);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => getWidget()));
    }
  }

  @override
  void toPreviousRoute(BuildContext context, [Object? param]) {
    this.param = param;
    _routesTree.removeLast();
    Navigator.of(context).pop();
    if(_routesTree.isEmpty){
      _routesTree.add(Route.welcome);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => getWidget()));
  }

}