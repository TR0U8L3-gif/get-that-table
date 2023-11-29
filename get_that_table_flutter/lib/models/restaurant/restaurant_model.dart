class Restaurant{
  String id;
  String name;
  String street;
  String type;

  Restaurant({this.id = "", required this.name, required this.street, required this.type,});

  static Restaurant fromJson(Map<String, dynamic> data) {
    return Restaurant(
      id: data['id'] ?? "",
      name: data['name'] ?? " ", 
      street: data['street'] ?? " ", 
      type: data['type'] ?? " ",
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name' : name,
      'street' : street,
      'type' : type,
    };
  }

  @override
  String toString() {
    return "$name ($type) - $street";
  }

}