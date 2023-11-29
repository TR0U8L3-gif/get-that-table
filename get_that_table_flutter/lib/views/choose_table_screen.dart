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
  bool isLoading = true;
  bool isError = false;

  Restaurant? restaurant;
  RestaurantTable? table;

  ReservationBuilder builder = ReservationBuilder();

  @override
  void initState() {
    super.initState();
    _updateRestaurant();
  }

  _updateRestaurant(){
    setState(() {
      isLoading = true;
      isError = false;
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

    await FirebaseFirestore.instance.collection('tables').doc(restaurant!.id).get().then((value) {
      table = RestaurantTable.fromJson(value.data() ?? {});
      print(table);
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

  bool checkReservationException(String input){
    switch(builder.getState()){
      case ReservationBuilderState.surname:
        return true;
      case ReservationBuilderState.date:
        RegExp regExp = RegExp(r"[0-9]{4}-[0-9]{2}-[0-9]{2}\s[0-9]{2}:[0-9]{2}", caseSensitive: false,);
        if(!regExp.hasMatch(input)) return false;
        return DateTime.tryParse(input) != null;
      case ReservationBuilderState.tableSize:
        return table != null && table!.sizes.contains(input);
      case ReservationBuilderState.additionalChairs:
        int? number = int.tryParse(input);
        if(table == null || number == null || number < 0) return false;
        return number <= table!.additionalChairs;
      case ReservationBuilderState.done:
        return true;
    }
  }

  Future<void> createReservation(Map<String, dynamic> object) async{
    DocumentReference doc = await FirebaseFirestore.instance.collection('reservations').add(object);
    await FirebaseFirestore.instance.collection('reservations').doc(doc.id).update({'id' : doc.id}).then((value) {
      builder.clear();
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
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [],
      );
    }
  }
}
