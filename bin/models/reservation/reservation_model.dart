class Reservation {
  String surname;
  String rid;
  DateTime date;
  String tableSize;
  int additionalChairs;

  Reservation({
    required this.surname,
    required this.rid,
    required this.date,
    required this.tableSize,
    required this.additionalChairs,
  });

  static Reservation fromJson(Map<String, dynamic> data) {
  return Reservation(
    surname : data["surname"] ?? "",
    rid : data["rid"] ?? "",
    date : data["date"] ?? DateTime.now(),
    tableSize : data["tableSize"] ?? "",
    additionalChairs : data["additionalChairs"] ?? 0, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "surname" : surname,
      "rid" : rid,
      "date" : date,
      "tableSize" : tableSize,
      "additionalChairs" : additionalChairs,
    };
  }
}

