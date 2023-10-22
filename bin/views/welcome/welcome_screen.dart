import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:get_that_table/ascii_art/ascii_art.dart' as ascii_art;

import '../../controllers/welcome/welcome_controller.dart';
import '../console_screen.dart';

class WelcomeScreen implements ConsoleScreen{
  final WelcomeController _controller = WelcomeController();

  @override
  void consolePrint() {
    final console = Console();
    console.clearScreen();
    
    ascii_art.printLogoOffset(_controller.offset);

    console 
      ..writeLine()
      ..writeLine("This console application allows you to book a table in one of your favorite restaurants in Białystok", TextAlignment.center)
      ..writeLine()
      ..writeLine("Author: Radosław Sienkiewicz", TextAlignment.right)
      ..cursorUp()
      ..write("To proceed, press ENTER: ")
      ..hideCursor()
      ;

      String? input = stdin.readLineSync();
      _controller.getInput(input);
 
    
  }
}