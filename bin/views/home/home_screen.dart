import 'package:dart_console/dart_console.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import '../../controllers/home/home_controller.dart';
import '../console_screen_imp.dart';

class HomeScreen implements ConsoleScreenImp{
  final HomeController _controller = HomeController();
  bool reload = false;

  HomeScreen(){
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
      ..writeLine(" Press any key to exit ", TextAlignment.center)
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
          _controller.index == i ? ascii_art.printDecorated("back") : "back", 
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