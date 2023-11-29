import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_that_table_flutter/models/reservation/reservation_model.dart';
import 'package:get_that_table_flutter/controllers/route_controller.dart' as rc;

import '../models/restaurant/restaurant_model.dart';

class GetReservationScreen extends StatefulWidget {
  const GetReservationScreen({Key? key}) : super(key: key);

  @override
  State<GetReservationScreen> createState() => _GetReservationScreenState();
}

class _GetReservationScreenState extends State<GetReservationScreen> {
  bool isError = false;
  bool isLoading = true;
  String? reservationId;
  Reservation reservation = Reservation(
    surname: 'Doe',
    rid: 'ABC123',
    date: DateTime.now(),
    tableSize: "M",
    additionalChairs: 2,
  );
  Restaurant restaurant = Restaurant(
      name: 'ABC123',
      street: 'ABC123',
      type: 'ABC123',
  );
  @override
  void initState() {
    super.initState();
    _updateReservation();
  }

  _updateReservation() {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      reservationId = rc.RouteController.getInstance().param as String;
    } catch (e) {
      setState(() {
        reservationId = null;
        isLoading = false;
        isError = true;
      });
    }

    print("reservationId: $reservationId");

    if (!isError) _getReservation();
  }

  Future<void> _getReservation() async {
    if(reservationId == null || reservationId!.isEmpty){
      setState(() {
        isLoading = false;
        isError = true;
      });
      return;
    }
    print("_getReservation");

    await FirebaseFirestore.instance.collection('reservations').doc(reservationId!).get().then((snap) async {
      reservation = Reservation.fromJson(snap.data() ?? {});
      print(reservation);
      await FirebaseFirestore.instance.collection('restaurants').doc(reservation.rid).get().then((snap) {
        restaurant = Restaurant.fromJson(snap.data() ?? {});
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
    }).onError((error, stackTrace) {
      print(error);
      setState(() {
        isLoading = false;
        isError = true;
      });
    });
  }

  void _editReservation() {
    print('Edit Reservation');
    rc.RouteController.getInstance().toRoute(context, rc.Route.editReservation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Details'),
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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
            size: 50.0,
          ),
          const SizedBox(height: 16.0),
          Text(
            "Wrong reservation id: $reservationId",
            style: const TextStyle(color: Colors.red),
          ),
        ],
      );
    } else if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                child: Opacity(opacity: 0.84, child: Image.asset("assets/images/big-restaurant-chair-table-set.jpg"))),
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
                    Text('Reservation ID: ${reservation.rid}'),
                    SizedBox(height: 16.0),
                    Text('Surname: ${reservation.surname}'),
                    SizedBox(height: 8.0),
                    Text('Date: ${reservation.date.toLocal()}'),
                    SizedBox(height: 8.0),
                    Text('Table Size: ${reservation.tableSize}'),
                    SizedBox(height: 8.0),
                    Text('Additional Chairs: ${reservation.additionalChairs}'),
                    SizedBox(height: 16.0),
                    Text('Restaurant: ${restaurant.name} (${restaurant.type})'),
                    SizedBox(height: 8.0),
                    Text('Street: ${restaurant.street}'),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _editReservation(),
              child: const Text('EditReservation'),
            ),
          ),
        ],
      );
    }
  }
}
