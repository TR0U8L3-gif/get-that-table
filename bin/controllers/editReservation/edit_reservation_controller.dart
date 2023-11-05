import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:firedart/firedart.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import '../../models/reservation/reservation_builder.dart';
import '../../models/reservation/reservation_model.dart';
import '../../models/restaurant/restaurant_model.dart';
import '../../models/restaurantTable/restaurant_table_model.dart';
import '../_impl/console_controller_impl.dart';
import '../route/route_controller.dart';

class EditReservationController extends ConsoleControllerImpl{
  bool isLoading = true;
  bool isError = false;
  bool updateView = true;
  int index = 0;

  Reservation? reservation;
  Restaurant? restaurant;
  RestaurantTable? table;

  ReservationBuilder builder = ReservationBuilder();

  Map<String, bool> editMap = {
    "surname" : false,
    "date" : false,
    "tableSize" : false,
    "additionalChairs" : false,
  };
  bool isCreateMode = false;
  bool isCreating = false;

  void updateIndex(int num){
    index += num;
    if(index < 0){
      index = 0;
    }
    if(index > editMap.keys.length + 1) index = editMap.keys.length + 1;
  }

  updateReservationToEdit(){
    editMap = {
      "surname" : false,
      "date" : false,
      "tableSize" : false,
      "additionalChairs" : false,
    };

    isLoading = true;
    isError = false;

    try{
      reservation = (RouteController.getInstance().param as Map<String, dynamic>)["reservation"] as Reservation;
      restaurant = (RouteController.getInstance().param as Map<String, dynamic>)["restaurant"] as Restaurant;

      builder
        ..setRid(reservation!.rid)
        ..setSurname(reservation!.surname)
        ..setDate(reservation!.date.toString())
        ..setTableSize(reservation!.tableSize)
        ..setAdditionalChairs(reservation!.additionalChairs.toString())
        ;
    } catch (e) {
      reservation = null;
      restaurant = null;
      isLoading = false;
      isError = true;
    }
    updateView = false;
    RouteController.getInstance().newRouteNotification();
    
    if(!isError) getReservationToEdit();
  }

  Future<void> getReservationToEdit() async {
    if(reservation == null || restaurant == null){
      isLoading = false;
      isError = true;
      updateView = true;
      RouteController.getInstance().newRouteNotification();
      return;
    }

    updateView = false;
    
    await Firestore.instance.collection('tables').document(restaurant!.id).get().then((value) async { 
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

    if(input == "exit"){
      exit(0);
    }

    if(isCreateMode){
      editeModeInput(input);
      return;
    }

    if(input == "back"){
      updateView = true;
      RouteController.getInstance().toPreviosRoute();
      return;
    }

    RouteController.getInstance().newRouteNotification();
  }
  
  editeModeInput(String input) async {
    if(checkReservationException(input)){
      builder.setInput(input);
      isCreateMode = false;
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
  
  Future<void> editReservation(Map<String, dynamic> object) async{ 
    if(reservation == null){
      isError = true;
      isCreateMode = false;
      RouteController.getInstance().newRouteNotification();
      return;
    }
    
    object.addAll({'id' : reservation!.id});
    isCreating = true;

    final console = Console();
    console.clearScreen();
    ascii_art.printLogoSmall();
    console.writeLine();
    console.writeLine("creating reservation: ${builder.toString()}");

    await Firestore.instance.collection('reservations').document(reservation!.id).update(object).then((value) {
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
      console.writeLine("\nreservation edited:");
      console.writeLine("\treservation id: ${reservation!.id} ${builder.toString()}");
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
      isCreating = false;
      isCreateMode = false;
      builder.clear();
      RouteController.getInstance().offAllRoute(Route.welcome);
    });
  }

 @override
  void getKey(Key input) {
    super.getKey(input);
    if(input.isControl){
      if(input.controlChar == ControlCharacter.arrowUp){
        updateIndex(-1);
      }
      if(input.controlChar == ControlCharacter.arrowDown){
        updateIndex(1);
      }
      if(input.controlChar == ControlCharacter.ctrlB){
        updateView = true;
        index = 0;
        RouteController.getInstance().toPreviosRoute();
        return;
      }
      if(input.controlChar == ControlCharacter.ctrlE){
        isError = true;
        RouteController.getInstance().newRouteNotification();
        return;
      }
      if(input.controlChar == ControlCharacter.enter){
        if(index > editMap.keys.length){
          editReservation(builder.build().toJson());
          return;
        } 
        else if(index == editMap.keys.length){
          updateView = true;
          index = 0;
          RouteController.getInstance().toPreviosRoute();
          return;
        }
        else {
          isCreateMode = true;
          switch(index){
            case 0:
            builder.surname = null;
            editMap["surname"] = true;
            break;
            case 1:
            builder.date = null;
            editMap["date"] = true;
            break;
            case 2:
            builder.tableSize = null;
            editMap["tableSize"] = true;
            break;
            case 3:
            builder.additionalChairs = null;
            editMap["additionalChairs"] = true;
            break;
          }
          RouteController.getInstance().newRouteNotification();
          return;
        }
      }
    }
    RouteController.getInstance().newRouteNotification();
  }
  
  String getEditMessage(String key){
    String message = "";
    switch(key){
      case "surname":
        message += "surname: ${builder.surname}${editMap[key] == true ? ", changed from (${reservation?.surname})" : ""}";
        break;
      case "date":
        message += "date: ${builder.date}${editMap[key] == true ? ", changed from (${reservation?.date})" : ""}";
        break;
      case "tableSize":
        message += "table size (${builder.tableSize}): ${tableSizeDescription[builder.tableSize]}  ${editMap[key] == true ? ", changed from (${reservation?.tableSize})" : ""}";
        break;
      case "additionalChairs":
        message += "number of additional chairs: ${builder.additionalChairs}${editMap[key] == true ? ", changed from (${reservation?.additionalChairs})" : ""}";
        break;
    }
    return message;
  }

  String getMessage(){
    String message = "To go back type: back \nTo edit reservation type: edit";
    
    if(isCreateMode){
      message = builder.getMessage();
    } else {
      message += "\nInput: ";
    }
    return message;
  }

  bool isReservationEdited() {
    bool output = false;
    editMap.forEach((key, value) { 
      if(value == true){
        output = true;
      }
    });
    return output;
  }

}