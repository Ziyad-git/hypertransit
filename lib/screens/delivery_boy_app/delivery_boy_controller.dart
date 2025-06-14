import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:hypertransit/screens/model/my_order.dart';

class DeliveryBoyController extends GetxController {
  TextEditingController busNoController = TextEditingController();

  final Location location = Location();

  String deliveryAddress = '';
  String phoneNumber = '';
  String amountToCollect = '0';
  double customerLatitude = 10.1;
  double customerLongitude = 76.4;
  bool showDeliveryInfo = false;
  bool isDeliveryStarted = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference orderCollection;
  late final CollectionReference orderTrackingCollection;

  @override
  void onInit() {
    super.onInit();
    orderCollection = firestore.collection('order');
    orderTrackingCollection = firestore.collection('orderTracking');
    getLocationPermission();
  }

  getOrderById() async {
    try {
      String busNo = busNoController.text;
      QuerySnapshot querySnapshot =
          await orderCollection.where('id', isEqualTo: busNo).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        MyOrder? order = MyOrder.fromJson(data);
        if (order != null) {
          customerLatitude = order.latitude ?? 0;
          customerLongitude = order.longitude ?? 0;
          showDeliveryInfo = true;
        }
        update();
      } else {
        Get.snackbar('Error', 'Order not found');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      rethrow;
    }
  }

  Future<void> getLocationPermission() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void startDelivery() {
    bool isFirstUpdate = true; // Track first location update

    try {
      location.onLocationChanged.listen((LocationData currentLocation) {
        if (isFirstUpdate) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(content: Text('Journey Started')),
          ); // Display message only once
          isFirstUpdate = false; // Mark first update as done
        }

        print(
            'Location changed: ${currentLocation.latitude}, ${currentLocation.longitude}');

        // Update order tracking location when location changes
        saveOrUpdateMyOrderLocation(busNoController.text,
            currentLocation.latitude ?? 0, currentLocation.longitude ?? 0);
      });

      location.enableBackgroundMode(enable: true);
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveOrUpdateMyOrderLocation(
      String busNo, double latitude, double longitude) async {
    try {
      final DocumentReference docRef = orderTrackingCollection.doc(busNo);

      //? Use a transaction to ensure atomic read and write
      await firestore.runTransaction((transaction) async {
        final DocumentSnapshot snapshot = await transaction.get(docRef);

        if (snapshot.exists) {
          //? Document exists, so we update it
          transaction.update(docRef, {
            'latitude': latitude,
            'longitude': longitude,
          });
        } else {
          //? Document does not exist, we create a new one
          transaction.set(docRef, {
            'busNo': busNo,
            'latitude': latitude,
            'longitude': longitude,
          });
        }
      });
    } catch (e) {
      print('Error saving or updating order location: $e');
    }
  }
}
