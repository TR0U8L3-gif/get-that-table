import '../../models/route/route_listener_model.dart';
import '../_impl/notification_service_imp.dart';

class RouteNotificationService implements NotificationService<RouteListener> {
  final List<RouteListener> _subscribers = [];

  @override
  void notify() {
    for (RouteListener listener in _subscribers) {
      listener.update();
    }
  }

  @override
  void subscribe(listener) {
    _subscribers.add(listener);
  }

  @override
  void unsubscribe(listener) {
    _subscribers.remove(listener);
  }
  

}
