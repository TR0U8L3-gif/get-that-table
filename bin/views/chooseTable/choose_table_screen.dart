import 'package:dart_console/dart_console.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import '../../controllers/chooseTable/choose_table_controller.dart';
import '../_impl/console_screen_imp.dart';

class ChooseTableScreen extends ConsoleScreenImp{
  final ChooseTableController _controller = ChooseTableController();
  bool reload = true;

  @override
  void consolePrint() {
    if(reload && _controller.updateView){
      _controller.updateRestaurant();
      reload = false;
    }

    if(_controller.isError){
      _controller.updateView = true;
    }

    final console = Console();
    console.clearScreen();
    ascii_art.printLogoSmall();
    
    reload = true;
    console.writeLine();
    console.writeLine(_controller.restaurant, TextAlignment.center);
    console.writeLine(_controller.restaurant?.id);

    if(_controller.isLoading){
      console.writeLine(" Loading Tables...", TextAlignment.center);
      return;
    }
    else if(_controller.isError){
      console
      ..setForegroundColor(ConsoleColor.red)
      ..writeLine(" Error Loading Tables", TextAlignment.center)
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

    console.writeLine(_controller.table, TextAlignment.center);
    console.writeLine();

    if(!_controller.isLoading){
      console.write("Input: ");
      String input = console.readLine() ?? "";
      _controller.getInput(input);
    }


    
  }

}