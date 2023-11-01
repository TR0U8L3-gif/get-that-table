import 'package:dart_console/dart_console.dart';

List<String> getLogoAscii() {
return [                                                                                             
r" ,----.            ,--.        ,--.  ,--.               ,--.        ,--.          ,--.   ,--.        ",
r"'  .-./    ,---. ,-'  '-.    ,-'  '-.|  ,---.  ,--,--.,-'  '-.    ,-'  '-. ,--,--.|  |-. |  | ,---.  ",
r"|  | .---.| .-. :'-.  .-'    '-.  .-'|  .-.  |' ,-.  |'-.  .-'    '-.  .-'' ,-.  || .-. '|  || .-. : ",
r"'  '--'  |\   --.  |  |        |  |  |  | |  |\ '-'  |  |  |        |  |  \ '-'  || `-' ||  |\   --. ",
r" `------'  `----'  `--'        `--'  `--' `--' `--`--'  `--'        `--'   `--`--' `---' `--' `----' ",
];}

void printLogoSmall(){
  Console console = Console();
  console
      ..setBackgroundColor(ConsoleColor.blue)
      ..setForegroundColor(ConsoleColor.white);
  console.writeLine("Get that table", TextAlignment.center);
  console.resetColorAttributes();
}

void printLogo(){
  Console console = Console();
  console
      ..setBackgroundColor(ConsoleColor.blue)
      ..setForegroundColor(ConsoleColor.white);

    for(String s in getLogoAscii()){
      console.writeLine(s, TextAlignment.center);
    }
    console.resetColorAttributes();
}

void printLogoOffset(int offset){
  Console console = Console();
  int width = console.windowWidth;
  int logoWidth = getLogoAscii()[0].length;
  if(offset < 0 || offset + logoWidth >= width){
    printLogo();
    return;
  }
  console
      ..setBackgroundColor(ConsoleColor.blue)
      ..setForegroundColor(ConsoleColor.white);

    for(String s in getLogoAscii()){
      console.writeLine(" " * offset + s, TextAlignment.left);
    }
    console.resetColorAttributes();
  
}

String printDecorated(String s){
    return "<:>:<:> $s <:>:<:>";
  }