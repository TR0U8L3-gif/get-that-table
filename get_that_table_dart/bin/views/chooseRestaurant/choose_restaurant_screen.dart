import 'package:dart_console/dart_console.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import '../../controllers/chooseRestaurant/choose_restaurant_controller.dart';
import '../_impl/console_screen_imp.dart';

class ChooseRestaurantScreen implements ConsoleScreenImp{
  final ChooseRestaurantController _controller = ChooseRestaurantController();
  bool reload = false;

  ChooseRestaurantScreen(){
    _controller.getRestaurants();
  }

  @override
  void consolePrint() {
    
    if(reload && _controller.updateView){
      _controller.getRestaurants();
      reload = false;
    }

    if(_controller.isError){
      _controller.updateView = true;
    }

    final console = Console();
    console.clearScreen();
    ascii_art.printLogoSmall();
    if(_controller.isLoading){
      console.writeLine(" Loading Restaurants...", TextAlignment.center);
      return;
    }
    else if(_controller.isError){
      console
      ..setForegroundColor(ConsoleColor.red)
      ..writeLine(" Error Loading Restaurants", TextAlignment.center)
      ..resetColorAttributes()
      ..writeLine()
      ..writeLine(" Press any key to go back ", TextAlignment.center)
      ..hideCursor()
      ;
      
      console.readKey();
      console.clearScreen();
      console.resetCursorPosition();
      console.rawMode = false;
      _controller.getInput("back");
      return;
    }
    reload = true;

    console.writeLine();
    for(int i = 0; i <= _controller.restaurants.length; i++){

      if(i<_controller.restaurants.length){
        var restaurant = _controller.restaurants[i];
        var message = restaurant.toString();
        console.writeLine(
          _controller.index == i ? ascii_art.printDecorated(message) : message, 
          TextAlignment.center);
      }
      else {
        console.writeLine();
        console.writeLine(
          _controller.index == i ? ascii_art.printDecorated("back") : "back (Ctrl+B)", 
          TextAlignment.center);
      }
    }
    
    console.writeLine();
    Key input = console.readKey();
    _controller.getKey(input);
    console.resetCursorPosition();
    console.rawMode = false;
  }

}