import 'package:dart_console/dart_console.dart';
import 'package:firedart/firedart.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import '../../models/console_controller.dart';
import '../../models/restaurant_builder.dart';
import '../route_controller/route_controller.dart';


class AdminController extends ConsoleController{
  bool isCreateMode = false;
  bool isRestaurantCreating = false;
  RestaurantBuilder builder = RestaurantBuilder();
  
  @override
  Future<void> getInput(String input) async {
    if( input.isEmpty){
      RouteController.getInstance().newRouteNotification();
      return;
    }

    
    if(isCreateMode){
      createModeInput(input);
      return;
    }
    
    if(input == "back"){
      RouteController.getInstance().toPreviosRoute();
      return;
    }
    
    if(input == "create"){
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
    if(builder.getState() != RestaurantBuilderState.done){
      builder.setInput(input);
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
        createRestaurant(builder.build().toJson());
        return; 
      }


      if(!["name", "street", "type"].contains(input)){
        RouteController.getInstance().newRouteNotification();
        return;
      }

      final console = Console();
      console.clearScreen();
      ascii_art.printLogoSmall();

      String message = "Change restaurant $input: ";
      console.write(message);
      console.hideCursor();
      String consoleInput = console.readLine() ?? "none";
      
      switch(input){
        case "name":
        builder.setName(consoleInput);
        break;
        case "street":
        builder.setStreet(consoleInput);
        break;
        case "type":
        builder.setType(consoleInput);
        break;
      }
    }

    RouteController.getInstance().newRouteNotification();
  }

  Future<void> createRestaurant(Map<String, dynamic> object) async{ 
    //{"name" : "a", "street" : "a","type" : "a"}
    isRestaurantCreating = true;
    final console = Console();
      console.clearScreen();
      ascii_art.printLogoSmall();
      console.writeLine();
      console.writeLine("createing restaurant: ${builder.toString()}");
    await Firestore.instance.collection('restaurants').add(object).then((value) {
      console.clearScreen();
      ascii_art.printLogoSmall();
      console.writeLine();
      console.writeLine("restaurant created: ${builder.toString()}");
      Future.delayed(const Duration(seconds: 5), () {
        isRestaurantCreating = false;
        isCreateMode = false;
        builder.clear();
        RouteController.getInstance().newRouteNotification();
      });
      
    });
  } 

  String getMessage(){
    String message = "To go back type: back \nTo create new restaurant in database type: create";
    if(isCreateMode){
      message = builder.getMessage();
      if(builder.getState() == RestaurantBuilderState.done){
        message += "\nTo change specific value type it name\nTo accept restaurant type: push\nTo reject changes type: back";
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