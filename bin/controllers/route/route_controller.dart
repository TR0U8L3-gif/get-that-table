import '../../services/route/route_notification_service.dart';
import '../../views/admin/admin_screen.dart';
import '../../views/_impl/console_screen_imp.dart';
import '../../views/chooseRestaurant/choose_restaurant_screen.dart';
import '../../views/chooseTable/choose_table_screen.dart';
import '../../views/welcome/welcome_screen.dart';

enum Route {
  welcome,
  chooseRestaurant,
  chooseTable,
  getReservation,
  editReservation,
  admin,
}

abstract class RouteControllerImp {
  Route getRoute();
  ConsoleScreenImp getScreen();
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
  final Map<Route, ConsoleScreenImp> _routesMap = {
    Route.welcome : WelcomeScreen(),
    Route.admin : AdminScreen(),
    Route.chooseRestaurant : ChooseRestaurantScreen(),
    Route.chooseTable : ChooseTableScreen(),
  };

  Object? param;

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
  ConsoleScreenImp getScreen() {
    return _routesMap[getRoute()] ?? WelcomeScreen();
  }
  
  @override
  void toRoute(Route destination, [Object? param]) {
    this.param = param; 
    _routesTree.add(destination);
    newRouteNotification();
  }
  
  @override
  void offAllRoute(Route destination, [Object? param]) {
    this.param = param; 
    _routesTree.clear();
    _routesTree.add(destination);
    newRouteNotification();
  }
  
  @override
  void offRoute(Route destination, [Object? param]) {
    this.param = param; 
    _routesTree.removeLast();
    _routesTree.add(destination);
    newRouteNotification();
  }
  
  @override
  void toPreviosRoute() {
    param = null;
    _routesTree.removeLast();
    if(_routesTree.isEmpty){
      _routesTree.add(Route.welcome);
    }
    newRouteNotification();
  }
  
}