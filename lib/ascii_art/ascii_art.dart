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

void printTable(String size){
  int tableWidth = 0;
  int seats = 0;
  switch(size){
    case "S":
      seats = 2;
    break;
    case "M":
      seats = 4;
    break;
    case "L":
      seats = 6;
    break;
    case "XL":
      seats = 8;
    break;
    case "XXL":
      seats = 12;
    break;
    default:
      seats = 4;
    break;
  }

  tableWidth= (seats~/2) * 3;

  Console console = Console();
  console.writeLine();
  console.writeLine(" █ " * (seats~/2), TextAlignment.center);
  console.writeLine();
  for(int i = 0 ; i < 4; i++){
    console.writeLine("█" * tableWidth, TextAlignment.center);
  }
  console.writeLine();
  console.writeLine(" █ " * (seats~/2), TextAlignment.center);
  console.writeLine();
}
