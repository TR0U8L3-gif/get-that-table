import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:firedart/firedart.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import '../../models/restaurantTable/restaurant_table_builder.dart';
import '../_impl/console_controller_impl.dart';
import '../../models/restaurant/restaurant_builder.dart';
import '../route/route_controller.dart';


class AdminController extends ConsoleControllerImpl{
  bool isCreateRestaurantMode = false;
  RestaurantBuilder restaurantBuilder = RestaurantBuilder();

  bool isCreateTableMode = false;
  RestaurantTableBuilder tableBuilder = RestaurantTableBuilder();

  bool isCreating = false;
  
  @override
  Future<void> getInput(String input) async {
    if( input.isEmpty){
      RouteController.getInstance().newRouteNotification();
      return;
    }

    if(input == "exit"){
      exit(0);
    }
    
    if(isCreateRestaurantMode){
      createRestaurantModeInput(input);
      return;
    }

    if(isCreateTableMode){
      createTableModeInput(input);
      return;
    }
    
    if(input == "back"){
      RouteController.getInstance().toPreviosRoute();
      return;
    }
    
    if(input == "restaurant"){
      isCreateRestaurantMode = true;
      isCreateTableMode = false;
    }

    if(input == "table"){
      isCreateRestaurantMode = false;
      isCreateTableMode = true;
    }

    RouteController.getInstance().newRouteNotification();
  }

  createRestaurantModeInput(String input) async {
    if(input == "back"){
      isCreateRestaurantMode = false;
      restaurantBuilder.clear();
      RouteController.getInstance().newRouteNotification();
      return;
    }
    if(restaurantBuilder.getState() != RestaurantBuilderState.done){
      restaurantBuilder.setInput(input);
      RouteController.getInstance().newRouteNotification();
      return;
    }
    else {

      if(input == "push"){
        createRestaurant(restaurantBuilder.build().toJson());
        return; 
      }


      if(!["name", "street", "type"].contains(input)){
        RouteController.getInstance().newRouteNotification();
        return;
      }
      
      switch(input){
        case "name":
        restaurantBuilder.name = null;
        break;
        case "street":
        restaurantBuilder.street = null;
        break;
        case "type":
        restaurantBuilder.type = null;
        break;
      }
    }

    RouteController.getInstance().newRouteNotification();
  }

  Future<void> createRestaurant(Map<String, dynamic> object) async{ 
    //{"name" : "a", "street" : "a","type" : "a"}
    isCreating = true;
    final console = Console();
      console.clearScreen();
      ascii_art.printLogoSmall();
      console.writeLine();
      console.writeLine("creating restaurant: ${restaurantBuilder.toString()}");
    Document doc = await Firestore.instance.collection('restaurants').add(object);
    await Firestore.instance.collection('restaurants').document(doc.id).update({'id' : doc.id}).then((value) {
      console.clearScreen();
      ascii_art.printLogoSmall();
      console.writeLine();
      console.writeLine("restaurant created: ${restaurantBuilder.toString()}");
      Future.delayed(const Duration(seconds: 5), () {
        isCreating = false;
        isCreateRestaurantMode = false;
        restaurantBuilder.clear();
        RouteController.getInstance().newRouteNotification();
      });
    });
  } 

  createTableModeInput(String input) async {
    if(input == "exit"){
      isCreateTableMode = false;
      tableBuilder.clear();
      RouteController.getInstance().newRouteNotification();
      return;
    }
    if(tableBuilder.getState() != RestaurantTableBuilderState.done){
      tableBuilder.setInput(input);
      RouteController.getInstance().newRouteNotification();
      return;
    }
    else {
      if(input == "back"){
        isCreateTableMode = false;
        tableBuilder.clear();
        RouteController.getInstance().newRouteNotification();
        return;
      }

      if(input == "push"){
        createTable(tableBuilder.build().toJson());
        return; 
      }

      if(!["restaurant id", "sizes", "additional chairs"].contains(input)){
        RouteController.getInstance().newRouteNotification();
        return;
      }
      
      switch(input){
        case "restaurant id":
        tableBuilder.restaurantId = null;
        break;
        case "sizes":
        tableBuilder.sizes = [];
        break;
        case "additional chairs":
        tableBuilder.additionalChairs = null;
        break;
      }
    }

    RouteController.getInstance().newRouteNotification();
  }

  Future<void> createTable(Map<String, dynamic> object) async {
    isCreating = true;
    final console = Console();
      console.clearScreen();
      ascii_art.printLogoSmall();
      console.writeLine();
      console.writeLine("creating table: ${tableBuilder.toString()}");
    await Firestore.instance.collection('tables').document(object['rid']).update(object).then((value) {
      console.clearScreen();
      ascii_art.printLogoSmall();
      console.writeLine();
      console.writeLine("table created: ${tableBuilder.toString()}");
      Future.delayed(const Duration(seconds: 5), () {
        isCreating = false;
        isCreateTableMode = false;
        tableBuilder.clear();
        RouteController.getInstance().newRouteNotification();
      });
    });
  } 

  String getMessage(){
    String message = "To go back type: back \nTo create new table in database type: table\nTo create new restaurant in database type: restaurant";
    if(isCreateRestaurantMode){
      message = restaurantBuilder.getMessage();
      if(restaurantBuilder.getState() == RestaurantBuilderState.done){
        message += "\nTo change specific value type it name\nTo accept restaurant type: push\nTo reject changes type: back";
      }
    }
    if(isCreateTableMode){
      message = tableBuilder.getMessage();
      if(tableBuilder.getState() == RestaurantTableBuilderState.done){
        message += "\nTo change specific value type it name\nTo accept table type: push\nTo reject changes type: back";
      }
    }
    message += "\nInput: ";
    return message;
  }
  
  @override
  void getKey(Key input) {
    super.getKey(input);
    RouteController.getInstance().newRouteNotification();
  }
}