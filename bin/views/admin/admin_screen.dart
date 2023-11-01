import 'package:dart_console/dart_console.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import '../../controllers/admin/admin_controller.dart';
import '../console_screen_imp.dart';

class AdminScreen implements ConsoleScreenImp{
  final AdminController _controller = AdminController();

  @override
  void consolePrint() {
    final console = Console();
    console.clearScreen();
    console.resetColorAttributes();
    console.resetColorAttributes();
    
    ascii_art.printLogoSmall();

    console 
      ..writeLine()
      ..write(_controller.getMessage())
      ..hideCursor()
      ;

    if(!_controller.isRestaurantCreating) {
      String input = console.readLine() ?? "";
      _controller.getInput(input);
    }
    
  }
}