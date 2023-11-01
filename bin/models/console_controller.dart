import 'dart:io';

import 'package:dart_console/dart_console.dart';

abstract class ConsoleController{
  void getInput(String input);
  void getKey(Key input){
    if(input.isControl && input.controlChar == ControlCharacter.ctrlC){
      Console console = Console();
      console.clearScreen();
      console.resetCursorPosition();
      console.rawMode = false;
      exit(0);
    }
  }
}