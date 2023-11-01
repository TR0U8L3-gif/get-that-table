import 'package:dart_console/dart_console.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import '../../controllers/welcome/welcome_controller.dart';
import '../console_screen_imp.dart';

class WelcomeScreen implements ConsoleScreenImp{
  final WelcomeController _controller = WelcomeController();

  @override
  void consolePrint() {
    final console = Console();
    console.clearScreen();
    
    ascii_art.printLogo();

    console 
      ..writeLine()
      ..writeLine("This console application allows you to book a table in one of your favorite restaurants in Białystok", TextAlignment.center)
      ..writeLine("Author: Radosław Sienkiewicz", TextAlignment.center)
      ..writeLine()
      ..writeLine("To exit type: exit")
      ..writeLine("To proceed press: ENTER")
      ..write("Input: ")
      ..hideCursor()
      ;
      
      String input = console.readLine() ?? "";
      _controller.getInput(input);
 
    
  }
}