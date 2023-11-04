import 'package:dart_console/dart_console.dart';
import 'package:firedart/firedart.dart';

import '../../models/reservation/reservation_model.dart';
import '../../models/restaurant/restaurant_model.dart';
import '../_impl/console_controller_impl.dart';
import '../route/route_controller.dart';

class GetReservationController extends ConsoleControllerImpl{
  bool isLoading = true;
  bool isError = false;
  bool updateView = true;

  String? reservationId;
  Reservation? reservation;
  Restaurant? restaurant;

  updateReservation(){
    isLoading = true;
    isError = false;

    try{
      reservationId = RouteController.getInstance().param as String;
    } catch (e) {
      reservationId = null;
      isError = true;
    }
    updateView = false;
    RouteController.getInstance().newRouteNotification();
    
    if(!isError) getReservation();
  }

  Future<void> getReservation() async {
    if(reservationId == null){
      isLoading = false;
      isError = true;
      updateView = true;
      RouteController.getInstance().newRouteNotification();
      return;
    }

    updateView = false;
    
    await Firestore.instance.collection('reservations').document(reservationId!).get().then((value) async { 
      reservation = Reservation.fromJson(value.map);
      await Firestore.instance.collection('restaurants').document(reservation!.rid).get().then((value) { 
        restaurant = Restaurant.fromJson(value.map);
        isLoading = false;
        isError = false;
        RouteController.getInstance().newRouteNotification();
      }).onError((error, stackTrace) {
        isLoading = false;
        isError = true;
        RouteController.getInstance().newRouteNotification();
      });
    }).onError((error, stackTrace) {
      isLoading = false;
      isError = true;
      RouteController.getInstance().newRouteNotification();
    });
  }

  @override
  void getInput(String input) {
    if(input.isEmpty){
      RouteController.getInstance().newRouteNotification();
      return;
    }

    if(input == "back"){
      updateView = true;
      RouteController.getInstance().toPreviosRoute();
      return;
    }

    if(input=="edit"){
      //TODO: edit
    }
    RouteController.getInstance().newRouteNotification();
  }

  @override
  void getKey(Key input) {
    super.getKey(input);
    RouteController.getInstance().newRouteNotification();
  }

  String getMessage(){
    String message = "To go back type: back \nTo edit reservation type: edit";
    message += "\nInput: ";
    return message;
  }
}