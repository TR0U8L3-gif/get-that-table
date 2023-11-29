abstract class NotificationService<T> {

  void subscribe(T listener);

  void unsubscribe(T listener);

  void notify();
}