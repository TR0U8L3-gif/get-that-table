Map <String, String> tableSizeDescription =  {
  "S" : "contains 2 chairs",
  "M" : "contains 4 chairs",
  "L" : "contains 6 chairs",
  "XL" : "contains 8 chairs",
  "XXL" : "contains 12 chairs",
};

class RestaurantTable {
  String restaurantId;
  List<String> sizes;
  int additionalChairs;

  RestaurantTable({
    required this.restaurantId, 
    required this.sizes, 
    required this.additionalChairs, 
    });

  Map<String, dynamic> toJson(){
    return {
      'rid': restaurantId,
      'size' : sizes,
      'add' : additionalChairs,
    };
  }

  static RestaurantTable fromJson(Map<String, dynamic> data) {
    return RestaurantTable(
      restaurantId: data['rid'] ?? "",
      sizes: List<String>.from(data['size'] ?? ""), 
      additionalChairs: data['add'] ?? 0, 
      );
  }

}