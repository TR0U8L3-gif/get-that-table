import 'restaurant_table_model.dart';

enum RestaurantTableBuilderState{
  rid,
  size,
  add,
  done
}

class RestaurantTableBuilder{
  String? restaurantId;
  List<String> sizes = [];
  int? additionalChairs;

  RestaurantTableBuilderState getState(){
    if(restaurantId == null) return RestaurantTableBuilderState.rid;
    if(sizes.isEmpty) return RestaurantTableBuilderState.size;
    if(additionalChairs == null) return RestaurantTableBuilderState.add;
    return RestaurantTableBuilderState.done;
  }

  String getMessage(){
    String message = "Please input ";
    switch(getState()){
      case RestaurantTableBuilderState.rid:
        message += "restaurant id: ";
        break;
      case RestaurantTableBuilderState.size:
        message += "table sizes (enter values separated by space ex: S M L XL XXL): ";
        break;
      case RestaurantTableBuilderState.add:
        message += "number of additional chairs: ";
        break;
      case RestaurantTableBuilderState.done:
        return "Provided Table: ${toString()}";
    }
    return message;
  }

  void setInput(String input){
    switch(getState()){
      case RestaurantTableBuilderState.rid:
        setRid(input);
        break;
      case RestaurantTableBuilderState.size:
        setSize(input);
        break;
      case RestaurantTableBuilderState.add:
        setAdd(input);
        break;
      case RestaurantTableBuilderState.done:
        break;
    }
  }

  setRid(String rid){
    restaurantId = rid;
    return this;
  }

  setSize(String sizes){
    this.sizes = [];
    List<String> input = sizes.toUpperCase().split(" ");
    for (String size in input) {
      if({"S", "M", "L", "XL", "XXL"}.contains(size)){
        this.sizes.add(size);
      }
    }
    return this;
  }

  setAdd(String add){
    additionalChairs = int.tryParse(add);
    return this;
  }

  clear(){
    restaurantId = null;
    sizes = [];
    additionalChairs = null;
  }

  RestaurantTable build(){
    return RestaurantTable(restaurantId: restaurantId ?? "", sizes: sizes, additionalChairs: additionalChairs ?? 0);
  }

  @override
  String toString() {
    return 'restaurant id: $restaurantId, sizes: $sizes, additional chairs: $additionalChairs';
  }
}