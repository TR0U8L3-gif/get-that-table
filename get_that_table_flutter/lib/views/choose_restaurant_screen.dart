import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_that_table_flutter/controllers/route_controller.dart' as rc;

import '../models/restaurant/restaurant_model.dart';

class ChooseRestaurantScreen extends StatefulWidget {
  const ChooseRestaurantScreen({Key? key}) : super(key: key);

  @override
  State<ChooseRestaurantScreen> createState() => _ChooseRestaurantScreenState();
}

class _ChooseRestaurantScreenState extends State<ChooseRestaurantScreen> {
  bool isError = false;
  bool isLoading = true;

  List<Restaurant> restaurants = [];

  @override
  void initState() {
    super.initState();
    _getRestaurants();
  }

  Future<void> _getRestaurants() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    await FirebaseFirestore.instance.collection('restaurants').get().then((value) {
      restaurants = [];
      for (var doc in value.docs) {
        restaurants.add(Restaurant.fromJson(doc.data() ?? {}));
      }
      setState(() {
        isLoading = false;
        isError = false;
      });
    }).onError((error, stackTrace) {
      print(error);
      setState(() {
        isLoading = false;
        isError = true;
      });
    });
  }

  _goToRestaurant(int index) {
    print('Navigating to choose table: ${restaurants[index]}');
    rc.RouteController.getInstance().toRoute(context, rc.Route.chooseTable, restaurants[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () => _getRestaurants(),
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
            "Error Loading Restaurants",
            style: TextStyle(color: Colors.red),
          ),
        ],
      );
    } else if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: const EdgeInsets.all(16.0),
            child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(24)), child: Opacity(opacity: 0.76, child: Image.asset("assets/images/from_top_of_the_rock__ryan_flicker.com.jpg"))),
          ),
          SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: restaurants.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () => _goToRestaurant(index),
                        child: Text(restaurants[index].toString()),
                      ),
                    )),
          ),
        ],
      );
    }
  }
}
