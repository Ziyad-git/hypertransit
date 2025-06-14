import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hypertransit/screens/model/my_order.dart';
import 'package:location/location.dart';

class LiveTrackingController extends GetxController {
  MyOrder? myOrder;
  LatLng destination = const LatLng(10.177851534623054, 76.42911653921071);
  LatLng BusLocation = const LatLng(10.17785507025893, 76.42911257560552);
  GoogleMapController? mapController;
  BitmapDescriptor markerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
  double remainingDistance = 0.0;
  final Location location = Location();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderTrackingCollection;

  @override
  void onInit() {
    orderTrackingCollection = firestore.collection('orderTracking');
    addCustomMarker();
    super.onInit();
  }

  void addCustomMarker() {
    ImageConfiguration configuration =
        const ImageConfiguration(size: Size(0, 0), devicePixelRatio: 1);
    BitmapDescriptor.fromAssetImage(configuration, 'assets/buslogo.png')
        .then((value) {
      markerIcon = value;
      update();
    });
  }

  void updateDestinationLocation(double latitude, double longitude) {
    destination = LatLng(latitude, longitude);
    update();
  }

  void startTracking(String busNo) {
    try {
      orderTrackingCollection.doc(busNo).snapshots().listen((snapshot) {
        if (snapshot.exists) {
          var trackingData = snapshot.data() as Map<String, dynamic>;
          double latitude = trackingData['latitude'];
          double longitude = trackingData['longitude'];
          updateUIWithLocation(latitude, longitude);
          print('Latest location: $latitude, $longitude');
        } else {
          print('No tracking data available for order ID: $busNo');
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  void updateUIWithLocation(double latitude, double longitude) {
    BusLocation = LatLng(latitude, longitude);
    mapController?.animateCamera(CameraUpdate.newLatLng(BusLocation));
    calculateRemainingDistance();
    update(); // Ensure UI rebuilds with the new marker position
  }

  void calculateRemainingDistance() {
    double distance = Geolocator.distanceBetween(
      BusLocation.latitude,
      BusLocation.longitude,
      destination.latitude,
      destination.longitude,
    );
    remainingDistance = distance / 1000;
    print("Remaining Distance: ${remainingDistance.toStringAsFixed(2)} km");
    update();
  }
}
