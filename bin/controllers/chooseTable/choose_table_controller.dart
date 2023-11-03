import 'package:dart_console/dart_console.dart';
import 'package:firedart/firedart.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import '../../models/reservation/reservation_builder.dart';
import '../../models/restaurant/restaurant_model.dart';
import '../../models/restaurantTable/restaurant_table_model.dart';
import '../_impl/console_controller_impl.dart';
import '../route/route_controller.dart';

class ChooseTableController extends ConsoleControllerImpl {
  bool isLoading = true;
  bool isError = false;
  bool updateView = true;
  bool isCreateMode = false;
   bool isReservationCreating = false;

  Restaurant? restaurant;
  RestaurantTable? table;

  ReservationBuilder builder = ReservationBuilder();

  updateRestaurant(){
    isLoading = true;
    isError = false;

    try{
      restaurant = RouteController.getInstance().param as Restaurant;
    } catch (e) {
      restaurant = null;
      isError = true;
    }
    updateView = false;
    RouteController.getInstance().newRouteNotification();
    
    if(!isError) updateTable();
  }

  Future<void> updateTable() async {
    if(restaurant == null){
      isLoading = false;
      isError = true;
      updateView = true;
      RouteController.getInstance().newRouteNotification();
      return;
    }

    updateView = false;

    if(builder.rid != restaurant!.id) {
      builder.setRid(restaurant!.id);
    }
    
    await Firestore.instance.collection('tables').document(restaurant!.id).get().then((value) { 
      table = RestaurantTable.fromJson(value.map);
      isLoading = false;
      isError = false;
      RouteController.getInstance().newRouteNotification();
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

    if(isCreateMode){
      createModeInput(input);
      return;
    }

    if(input == "back"){
      updateView = true;
      isCreateMode = false;
      RouteController.getInstance().toPreviosRoute();
      return;
    }

    if(input=="get that table"){
      isCreateMode = true;
    }
    RouteController.getInstance().newRouteNotification();
  }

  createModeInput(String input) async {
    if(input == "exit"){
      isCreateMode = false;
      builder.clear();
      RouteController.getInstance().newRouteNotification();
      return;
    }
    if(builder.getState() != ReservationBuilderState.done){
      if(checkReservationException(input)){
        builder.setInput(input);
      }
      RouteController.getInstance().newRouteNotification();
      return;
    }
    else {
      if(input == "back"){
        isCreateMode = false;
        builder.clear();
        RouteController.getInstance().newRouteNotification();
        return;
      }

      if(input == "push"){
        createReservation(builder.build().toJson());
        return; 
      }

      if(!["surname", "date", "table size", "additional chairs", ].contains(input)){
        RouteController.getInstance().newRouteNotification();
        return;
      }

      switch(input){
        case "surname":
        builder.surname = null;
        break;
        case "date":
        builder.date = null;
        break;
        case "table size":
        builder.tableSize = null;
        break;
        case "additional chairs":
        builder.additionalChairs = null;
        break;
      }
    }

    RouteController.getInstance().newRouteNotification();
  }

  bool checkReservationException(String input){
    switch(builder.getState()){
      case ReservationBuilderState.surname:
        return true;
      case ReservationBuilderState.date:
        RegExp regExp = RegExp(r"[0-9]{4}-[0-9]{2}-[0-9]{2}\s[0-9]{2}:[0-9]{2}", caseSensitive: false,);
        if(!regExp.hasMatch(input)) return false;
        return DateTime.tryParse(input) != null;
      case ReservationBuilderState.tableSize:
        return table != null && table!.sizes.contains(input);
      case ReservationBuilderState.additionalChairs:
        int? number = int.tryParse(input);
        if(table == null || number == null || number < 0) return false; 
        return number <= table!.additionalChairs;
      case ReservationBuilderState.done:
        return true;
    }
  }
  
  Future<void> createReservation(Map<String, dynamic> object) async{ 
    isReservationCreating = true;
    final console = Console();
      console.clearScreen();
      ascii_art.printLogoSmall();
      console.writeLine();
      console.writeLine("creating reservation: ${builder.toString()}");
    Document doc = await Firestore.instance.collection('reservations').add(object);
    await Firestore.instance.collection('reservations').document(doc.id).update({'id' : doc.id}).then((value) {
      console.clearScreen();
      ascii_art.printLogoSmall();
      console.writeLine();
      ascii_art.printTable(builder.tableSize ?? "L", builder.additionalChairs ?? 0);
      console.writeLine();
      console.writeLine("REMEMBER YOUR RESERVATION ID IF YOU WANT TO MAKE CHANGES!!!", TextAlignment.center);
      console..setForegroundColor(ConsoleColor.blue)..setTextStyle(underscore: true);
      console.writeLine("  ");
      console.resetColorAttributes();
      console.writeLine();
      console.writeLine("\nreservation created:");
      console.writeLine("\treservation id: ${doc.id} ${builder.toString()}");
      console..setForegroundColor(ConsoleColor.blue)..setTextStyle(underscore: true);
      console.writeLine("  ");
      console.resetColorAttributes();
      console.setForegroundColor(ConsoleColor.green);
      console.writeLine();
      console.writeLine("Press any key to continue ", TextAlignment.center);
      console.resetColorAttributes();

      console.readKey();
      console.clearScreen();
      console.resetCursorPosition();
      console.rawMode = false;
      isReservationCreating = false;
      isCreateMode = false;
      builder.clear();
      RouteController.getInstance().toPreviosRoute();
    });
  } 


  @override
  void getKey(Key input) {
    super.getKey(input);
    RouteController.getInstance().newRouteNotification();
  }

   String getMessage(){
    String message = "To go back type: back \nTo create new table reservation type: get that table";
    if(isCreateMode){
      message = builder.getMessage();
      if(builder.getState() == ReservationBuilderState.done){
        message += "\nTo change specific value type it name\nTo accept reservation type: push\nTo reject changes type: back";
      }
    }
    message += "\nInput: ";
    return message;
  }

}