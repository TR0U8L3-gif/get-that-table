import 'package:dart_console/dart_console.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import '../../controllers/home/home_controller.dart';
import '../console_screen.dart';

class HomeScreen implements ConsoleScreen{
  final HomeController _controller = HomeController();
  bool reload = false;

  HomeScreen(){
    _controller.getRestaurants();
  }

  @override
  void consolePrint() {
    if(reload){
      _controller.getRestaurants();
      reload = false;
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
    for(var restaurant in _controller.restaurants){
      console.writeLine(restaurant.toJson(), TextAlignment.center);
    }
    console.writeLine("back", TextAlignment.center);
    console.writeLine();
    String? input = console.readLine();
    _controller.getInput(input);

  
  }

}