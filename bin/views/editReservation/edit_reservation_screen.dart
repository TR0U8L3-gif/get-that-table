import 'package:dart_console/dart_console.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import '../../controllers/editReservation/edit_reservation_controller.dart';
import '../../models/restaurantTable/restaurant_table_model.dart';
import '../_impl/console_screen_imp.dart';

class EditReservationScreen extends ConsoleScreenImp{
  final EditReservationController _controller = EditReservationController();
  bool reload = true;

  @override
  void consolePrint() {
    if(reload && _controller.updateView){
      _controller.updateReservationToEdit();
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
    console.writeLine("Reservation id: ${_controller.reservation?.id}", TextAlignment.center);
    console.writeLine();
    console..setForegroundColor(ConsoleColor.blue)..writeLine(_controller.restaurant, TextAlignment.center);
    console.setTextStyle(underscore: true);
    console..writeLine("  ")..resetColorAttributes()..writeLine();

    if(_controller.isLoading){
      console.writeLine(" Loading Reservation...", TextAlignment.center);
      return;
    }
    else if(_controller.isError){
      console
      ..setForegroundColor(ConsoleColor.red)
      ..writeLine(" Error Loading Reservation", TextAlignment.center)
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

  if(_controller.isCreateMode){
    if(_controller.index >=2){
      console.write(_controller.table.toString());
      console.writeLine();
      console..setForegroundColor(ConsoleColor.blue)..setTextStyle(underscore: true);
      console.writeLine("  ");
      console..resetColorAttributes()..writeLine();
    }
    console..setForegroundColor(ConsoleColor.blue)..write("[Edit]")..resetColorAttributes();
  }
  else
  {
    console..setForegroundColor(ConsoleColor.blue)..writeLine("Edit", TextAlignment.center)..resetColorAttributes();
    for(int i = 0; i <= _controller.editMap.keys.length + 1; i++){
      if(i<_controller.editMap.keys.length){
        String key = _controller.editMap.keys.toList()[i];
        var message = _controller.getEditMessage(key);
        console.writeLine(
          _controller.index == i ? ascii_art.printDecorated(message) : message, 
          TextAlignment.center);
      }
      else if(i == _controller.editMap.keys.length) {
        console.writeLine();
        console.writeLine(
          _controller.index == i ? ascii_art.printDecorated("back") : "back (Ctrl+B)", 
          TextAlignment.center);
      } else {
        console.writeLine();
        console.writeLine(
          _controller.index == i ? ascii_art.printDecorated("apply changes") : "edit finished?", 
          TextAlignment.center);
      }
    }
  }

    if(!_controller.isLoading ){
      if(_controller.isCreateMode){
        console.write(_controller.getMessage());
        if(!_controller.isCreating){
          String input = console.readLine() ?? "";
          _controller.getInput(input);
        }
      }
      else{
        Key input = console.readKey();
        _controller.getKey(input);
        console.resetCursorPosition();
        console.rawMode = false;
      }
    }
  }
  
}