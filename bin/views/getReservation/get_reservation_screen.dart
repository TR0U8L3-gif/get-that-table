import 'package:dart_console/dart_console.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import '../../controllers/getReservation/get_reservation_controller.dart';
import '../../models/restaurantTable/restaurant_table_model.dart';
import '../_impl/console_screen_imp.dart';

class GetReservationScreen extends ConsoleScreenImp{
  final GetReservationController _controller = GetReservationController();
  bool reload = true;

  @override
  void consolePrint() {
    if(reload && _controller.updateView){
      _controller.updateReservation();
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
    console.writeLine("Reservation id: ${_controller.reservationId}", TextAlignment.center);
    console.writeLine();

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
    console..setForegroundColor(ConsoleColor.blue)..writeLine(_controller.restaurant, TextAlignment.center);
    console.writeLine();
    console.setTextStyle(underscore: true);
    console..writeLine("  ")..resetColorAttributes()..writeLine();
    console.writeLine("surname: ${_controller.reservation?.surname}", TextAlignment.center);
    console.writeLine("date: ${_controller.reservation?.date}", TextAlignment.center);
    console.writeLine();
    ascii_art.printTable(_controller.reservation?.tableSize ?? "", _controller.reservation?.additionalChairs ?? 0);
    console.writeLine();
    console.writeLine("table size (${_controller.reservation?.tableSize}): ${tableSizeDescription[_controller.reservation?.tableSize]}", TextAlignment.center);
    console.writeLine("number of additional chairs: ${_controller.reservation?.additionalChairs}", TextAlignment.center);
    console.writeLine();
    console..setForegroundColor(ConsoleColor.blue)..setTextStyle(underscore: true);
    console.writeLine("  ");
    console..resetColorAttributes()..writeLine();

    if(!_controller.isLoading){
      console.write(_controller.getMessage());
      String input = console.readLine() ?? "";
      _controller.getInput(input);
    }


  }
}