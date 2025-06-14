import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hypertransit/screens/model/my_order.dart';

class AddOrderController extends GetxController{

  TextEditingController busNoController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  GoogleMapController? mapController;
  LatLng currentLocation = const LatLng(10.5658952, 174.5651656551);
  LatLng selectedLocation = const LatLng(12.65162065,48.65165162 );

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  @override
  Future<void> onInit() async {
    orderCollection = firestore.collection('order');
    super.onInit();
  }

  void addOrder(BuildContext context) {
    try {
      if (nameController.text.isEmpty || busNoController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill field')));
        return;
      } else {
        DocumentReference doc = orderCollection.doc(busNoController.text);
        MyOrder order = MyOrder(
          id: doc.id,
          name: nameController.text,
          latitude: selectedLocation!.latitude.toDouble(),
          longitude: selectedLocation!.longitude.toDouble(),
        );
        final orderJson = order.toJson();
        doc.set(orderJson);
        clearTextFields();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bus Tracking Started')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to fetch details')));
      rethrow;
    }
  }


  clearTextFields(){
    busNoController.clear();
    nameController.clear();
  }


}