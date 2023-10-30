import '../../services/route_notification_service.dart';
import '../../views/admin/admin_screen.dart';
import '../../views/console_screen.dart';
import '../../views/home/home_screen.dart';
import '../../views/welcome/welcome_screen.dart';

enum Route {
  welcome,
  home,
  chooseRestaurant,
  chooseTable,
  getReservation,
  editReservation,
  admin,
}

abstract class RouteControllerImp {
  Route getRoute();
  ConsoleScreen getScreen();
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
  final Map<Route, ConsoleScreen> _routesMap = {
    Route.welcome : WelcomeScreen(),
    Route.home : HomeScreen(),
    Route.admin : AdminScreen(),
  };

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
  ConsoleScreen getScreen() {
    return _routesMap[getRoute()] ?? WelcomeScreen();
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