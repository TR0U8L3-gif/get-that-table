import '../../services/route_notification_service.dart';

enum Route {
  welcome,
  home,
  chooseRestaurant,
  chooseTable,
  getReservation,
  editReservation,
}

abstract class RouteControllerImp {
  Route getRoute();
  /// go to `destination` route 
  void toRoute(Route destination);
  /// go to `destination` route and delete previous one
  void offRoute(Route destination);
  /// go to `destination` route and delete all previous routes
  void offAllRoute(Route destination);
  /// go to previos route
  void toPreviosRoute();
}

class RouteController implements RouteControllerImp{
  static final RouteController _routeController = RouteController._();
  final RouteNotificationService _routeNotificationService = RouteNotificationService();
  final List<Route> _routesTree = [Route.welcome]; 


  RouteController._();

  static RouteController getInstance() {
    return _routeController;
  }

  RouteNotificationService getService(){
    return _routeNotificationService;
  }

  void newRouteNotification(){
    _routeNotificationService.notify();
  }
  
  @override
  Route getRoute() {
    return _routesTree.last;
  }
  
  @override
  void toRoute(Route destination) {
    _routesTree.add(destination);
    newRouteNotification();
  }
  
  @override
  void offAllRoute(Route destination) {
    _routesTree.clear();
    _routesTree.add(destination);
    newRouteNotification();
  }
  
  @override
  void offRoute(Route destination) {
    _routesTree.removeLast();
    _routesTree.add(destination);
    newRouteNotification();
  }
  
  @override
  void toPreviosRoute() {
    _routesTree.removeLast();
    if(_routesTree.isEmpty){
      _routesTree.add(Route.welcome);
    }
    newRouteNotification();
  }
}