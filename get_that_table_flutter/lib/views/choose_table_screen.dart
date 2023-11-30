import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/reservation/reservation_builder.dart';
import '../models/restaurant/restaurant_model.dart';
import '../models/restaurantTable/restaurant_table_model.dart';
import 'package:get_that_table_flutter/controllers/route_controller.dart' as rc;

class ChooseTableScreen extends StatefulWidget {
  const ChooseTableScreen({Key? key}) : super(key: key);

  @override
  State<ChooseTableScreen> createState() => _ChooseTableScreenState();
}

class _ChooseTableScreenState extends State<ChooseTableScreen> {

  final TextEditingController _surname = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _tableSize = TextEditingController();
  final TextEditingController _additionalChairs = TextEditingController();

  bool isLoading = true;
  bool isError = false;

  Restaurant? restaurant;
  RestaurantTable? table;

  ReservationBuilder builder = ReservationBuilder();

  Map<String, bool> editMap = {
    "surname": false,
    "date": false,
    "tableSize": false,
    "additionalChairs": false,
  };

  @override
  void initState() {
    super.initState();
    _updateRestaurant();
  }

  _updateRestaurant(){
    setState(() {
      isLoading = true;
      isError = false;
      _surname.clear();
      _date.clear();
      _additionalChairs.clear();
      _tableSize.clear();
      builder.clear();

      editMap = {
        "surname": false,
        "date": false,
        "tableSize": false,
        "additionalChairs": false,
      };
    });

    try{
      restaurant = rc.RouteController.getInstance().param as Restaurant;
    } catch (e) {
      setState(() {
        restaurant = null;
        isLoading = false;
        isError = true;
      });
    }
    print(restaurant);
    if(!isError) _updateTable();
  }

  Future<void> _updateTable() async {
    if(restaurant == null){
      setState(() {
        isLoading = false;
        isError = true;
      });
      return;
    }

    if(builder.rid != restaurant!.id) {
      builder.setRid(restaurant!.id);
    }

    await FirebaseFirestore.instance.collection('tables').doc(restaurant!.id).get().then((value) async {
      table = RestaurantTable.fromJson(value.data() ?? {});
      setState(() {
        isLoading = false;
        isError = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    });
  }

  editeModeInput(String input) async {
    if (checkReservationException(input)) {
      builder.setInput(input);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Wrong input'),
      ));
    }
  }

  bool checkReservationException(String input) {
    switch (builder.getState()) {
      case ReservationBuilderState.surname:
        return true;
      case ReservationBuilderState.date:
        RegExp regExp = RegExp(
          r"[0-9]{4}-[0-9]{2}-[0-9]{2}\s[0-9]{2}:[0-9]{2}",
          caseSensitive: false,
        );
        if (!regExp.hasMatch(input)) return false;
        return DateTime.tryParse(input) != null;
      case ReservationBuilderState.tableSize:
        return table != null && table!.sizes.contains(input);
      case ReservationBuilderState.additionalChairs:
        int? number = int.tryParse(input);
        if (table == null || number == null || number < 0) return false;
        return number <= table!.additionalChairs;
      case ReservationBuilderState.done:
        return true;
    }
  }

  Future<void> createReservation(Map<String, dynamic> object) async{
    setState(() {
      isError = false;
      isLoading = true;
    });

    DocumentReference doc = await FirebaseFirestore.instance.collection('reservations').add(object);
    await FirebaseFirestore.instance.collection('reservations').doc(doc.id).update({'id' : doc.id}).then((value) {
      builder.clear();
      rc.RouteController.getInstance().offRoute(context, rc.Route.getReservation, doc.id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('The reservation has been added <3'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () => _updateRestaurant(),
              child: const Icon(Icons.cached_rounded),
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blueAccent.withOpacity(0.16),
        child: Center(
          child: _buildState(context),
        ),
      ),
    );
  }

  _buildState(BuildContext context) {
    if (isError) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
            size: 50.0,
          ),
          SizedBox(height: 16.0),
          Text(
            "Error Loading Tables",
            style: TextStyle(color: Colors.red),
          ),
        ],
      );
    }
    else if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    }
    else {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  child: Opacity(
                      opacity: 0.84,
                      child: Image.asset(
                        "assets/images/waiter.jpg",
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("$restaurant"),
                      const SizedBox(height: 16.0),
                      Text("$table"),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Surname: ${editMap["surname"]! ? "${builder.surname}" : ""}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _surname,
                              decoration: const InputDecoration(
                                hintText: 'Reservation Surname',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0, right: 16.0),
                            child: InkWell(
                              onTap: () {
                                builder.surname = null;
                                if (checkReservationException(_surname.text)) {
                                  setState(() {
                                    editMap["surname"] = true;
                                    builder.surname = _surname.text;
                                  });
                                } else {
                                  setState(() {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(builder.getMessage()),
                                    ));
                                  });
                                }
                              },
                              child: const Icon(
                                Icons.send,
                                color: Colors.blueAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Date: ${editMap["date"]! ? "${builder.date}" : ""}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _date,
                              decoration: const InputDecoration(
                                hintText: 'Reservation Date',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0, right: 16.0),
                            child: InkWell(
                              onTap: () {
                                builder.date = null;
                                if (checkReservationException(_date.text)) {
                                  setState(() {
                                    editMap["date"] = true;
                                    builder.date = DateTime.parse(_date.text);
                                  });
                                } else {
                                  setState(() {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(builder.getMessage()),
                                    ));
                                  });
                                }
                              },
                              child: const Icon(
                                Icons.send,
                                color: Colors.blueAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Table Size: ${editMap["tableSize"]! ? "${builder.tableSize}" : ""}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _tableSize,
                              decoration: const InputDecoration(
                                hintText: 'Reservation Table Size',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0, right: 16.0),
                            child: InkWell(
                              onTap: () {
                                builder.tableSize = null;
                                if (checkReservationException(_tableSize.text)) {
                                  setState(() {
                                    editMap["tableSize"] = true;
                                    builder.tableSize = _tableSize.text;
                                  });
                                } else {
                                  setState(() {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(builder.getMessage()),
                                    ));
                                  });
                                }
                              },
                              child: const Icon(
                                Icons.send,
                                color: Colors.blueAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Additional Chairs: ${editMap["additionalChairs"]! ? "${builder.additionalChairs}" : ""}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _additionalChairs,
                              decoration: const InputDecoration(
                                hintText: 'Reservation Additional Chairs',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0, right: 16.0),
                            child: InkWell(
                              onTap: () {
                                builder.additionalChairs = null;
                                if (checkReservationException(_additionalChairs.text)) {
                                  setState(() {
                                    editMap["additionalChairs"] = true;
                                    builder.additionalChairs = int.parse(_additionalChairs.text);
                                  });
                                } else {
                                  setState(() {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(builder.getMessage()),
                                    ));
                                  });
                                }
                              },
                              child: const Icon(
                                Icons.send,
                                color: Colors.blueAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  bool ok = true;
                  editMap.forEach((key, value) {
                    if (value == false) {
                      ok = false;
                    }
                  });
                  if (ok) {
                    createReservation(builder.build().toJson());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please complete all information'),
                    ));
                  }
                },
                child: const Text('Get That Table'),
              ),
            ),
          ],
        ),
      );
    }
  }
}
