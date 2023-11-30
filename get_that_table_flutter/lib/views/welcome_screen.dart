import 'package:flutter/material.dart';
import 'package:get_that_table_flutter/controllers/route_controller.dart' as rc;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _reservationIdController = TextEditingController();

  void _searchReservation(){
    String reservationId = _reservationIdController.text;
    print('Searching reservation with ID: $reservationId');
    rc.RouteController.getInstance().toRoute(context, rc.Route.getReservation, reservationId);
  }

  void _goToAdminPanel(){
    print('Navigating to Admin Panel');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('You do not have administrator rights ☺'),
    ));
  }

  void _searchRestaurant(){
    print('Searching for Restaurants');
    rc.RouteController.getInstance().toRoute(context, rc.Route.chooseRestaurant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get That Table"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blueAccent.withOpacity(0.16),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(24)), child: Opacity(opacity: 0.84, child: Image.asset("assets/images/eating_family_dinner_together.png"))),
                  ),
                  TextField(
                    controller: _reservationIdController,
                    decoration: const InputDecoration(
                        hintText: 'Reservation ID',),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () => _searchReservation(),
                    child: const Text('Search Reservation'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () => _goToAdminPanel(),
                    child: const Text('Go to Admin Panel'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () => _searchRestaurant(),
                    child: const Text('Search Restaurants'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
