class Restaurant{
  String name;
  String street;
  String type;

  Restaurant({required this.name, required this.street, required this.type,});

  static Restaurant fromJson(Map<String, dynamic> data) {
    return Restaurant(
      name: data['name'] ?? " ", 
      street: data['street'] ?? " ", 
      type: data['type'] ?? " ",
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'street' : street,
      'type' : type,
    };
  }

}