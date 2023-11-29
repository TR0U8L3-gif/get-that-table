import 'reservation_model.dart';

enum ReservationBuilderState {
  surname,
  date,
  tableSize,
  additionalChairs,
  done, 
}

class ReservationBuilder {
  String? rid;
  String? surname;
  DateTime? date;
  String? tableSize;
  int? additionalChairs;

  ReservationBuilderState getState(){
    if(surname == null) return ReservationBuilderState.surname;
    if(date == null) return ReservationBuilderState.date;
    if(tableSize == null) return ReservationBuilderState.tableSize;
    if(additionalChairs == null) return ReservationBuilderState.additionalChairs;
    return ReservationBuilderState.done;
  }

  String getMessage(){
    String message = "Please input ";
    switch(getState()){
      case ReservationBuilderState.surname:
        message += "your surname: ";
        break;
      case ReservationBuilderState.date:
        message += "reservation date (ex 2002-12-20 12:20): ";
        break;
      case ReservationBuilderState.tableSize:
        message += "table size: ";
        break;
      case ReservationBuilderState.additionalChairs:
        message += "number of additional chairs: ";
        break;  
      case ReservationBuilderState.done:
        return "Provided reservation: ${toString()}";
    }
    return message;
  }

  void setInput(String input){
    switch(getState()){
      case ReservationBuilderState.surname:
        setSurname(input);
        break;
      case ReservationBuilderState.date:
        setDate(input);
        break;
      case ReservationBuilderState.tableSize:
        setTableSize(input);
        break;
      case ReservationBuilderState.additionalChairs:
        setAdditionalChairs(input);
        break;  
      case ReservationBuilderState.done:
        break;
    }
  }
  setRid(String rid){
    this.rid = rid;
    return this;
  }

  setSurname(String surname){
    this.surname = surname;
    return this;
  }

  setDate(String date){
    this.date = DateTime.parse(date);
    return this;
  }

  setTableSize(String tableSize){
    this.tableSize = tableSize;
    return this;
  }

  setAdditionalChairs(String additionalChairs){
    this.additionalChairs = int.parse(additionalChairs);
    return this;
  }

  clear(){
    surname = null;
    date = null;
    tableSize = null;
    additionalChairs = null;
  }

  Reservation build(){
    return Reservation(surname: surname ?? "", rid: rid ?? "", date: date ?? DateTime.now(), tableSize: tableSize ?? "L", additionalChairs: additionalChairs ?? 0);
  }

  @override
  String toString() {
    String message = "\n\t";
    // message += "restaurant id: $rid,";
    // message += "\n\t";
    message += "surname: $surname,";
    message += "\n\t";
    message += "date: $date,";
    message += "\n\t";
    message += "table size: $tableSize, ";
    message += "\n\t";
    message += "additional chairs: $additionalChairs";
    message += "\n";
    return message;
  }
}
