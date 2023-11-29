import 'restaurant_model.dart';

enum RestaurantBuilderState{
  name,
  street,
  type,
  done
}

class RestaurantBuilder{
  String? name;
  String? street;
  String? type;

  RestaurantBuilderState getState(){
    if(name == null) return RestaurantBuilderState.name;
    if(street == null) return RestaurantBuilderState.street;
    if(type == null) return RestaurantBuilderState.type;
    return RestaurantBuilderState.done;
  }

  String getMessage(){
    String message = "Please input restaurant";
    switch(getState()){
      case RestaurantBuilderState.name:
        message += " name: ";
        break;
      case RestaurantBuilderState.street:
        message += " street: ";
        break;
      case RestaurantBuilderState.type:
        message += " type: ";
        break;
      case RestaurantBuilderState.done:
        return "Provided Restaurant: ${toString()}";
    }
    return message;
  }

  void setInput(String input){
    switch(getState()){
      case RestaurantBuilderState.name:
        setName(input);
        break;
      case RestaurantBuilderState.street:
        setStreet(input);
        break;
      case RestaurantBuilderState.type:
        setType(input);
        break;
      case RestaurantBuilderState.done:
        break;
    }
  }

  setName(String name){
    this.name = name;
    return this;
  }

  setStreet(String street){
    this.street = street;
    return this;
  }

  setType(String type){
    this.type =  type;
    return this;
  }

  clear(){
    name = null;
    street = null;
    type = null;
  }

  Restaurant build(){
    return Restaurant(name: name ?? "", street: street ?? "", type: type ?? "");
  }

  @override
  String toString() {
    return 'name: $name, street: $street, type: $type';
  }

}