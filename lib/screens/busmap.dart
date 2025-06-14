import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hypertransit/screens/add_order/add_order_controller.dart';
import 'package:hypertransit/screens/order_list/order_list.dart';

class Busmap extends StatelessWidget {
  const Busmap({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddOrderController>(
        init: AddOrderController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Track Bus'),
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(const OrdersListPage());
                    },
                    icon: const Icon(Icons.list)),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.map_outlined))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextField(
                    controller: controller.busNoController,
                    decoration: const InputDecoration(
                      labelText: 'Bus Number',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Student Name',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // TextField(
                  //   controller: controller.phoneController,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Customer Phone',
                  //   ),
                  // ),
                  // const SizedBox(height: 16.0),
                  // TextField(
                  //   controller: controller.addressController,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Customer Address',
                  //   ),
                  // ),
                  // const SizedBox(height: 16.0),
                  // TextField(
                  //   controller: controller.amountController,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Bill Amount',
                  //   ),
                  // ),
                  Container(
                    height: 480,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: GestureDetector(
                      onVerticalDragUpdate:
                          (details) {}, // This allows vertical dragging inside GoogleMap
                      child: GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        initialCameraPosition: const CameraPosition(
                            target:
                                LatLng(10.17785507025893, 76.42911257560552),
                            zoom: 14),
                        onMapCreated: (GoogleMapController mapController) {
                          controller.mapController = mapController;
                          controller.update();
                        },
                        onTap: (LatLng position) {
                          controller.selectedLocation = position;
                          controller.update();
                        },
                        markers: {
                          if (controller.selectedLocation != null)
                            Marker(
                              markerId: const MarkerId('selectedLocation'),
                              position: controller.selectedLocation,
                              infoWindow: InfoWindow(
                                title: 'Selected Location',
                                snippet:
                                    'Lat: ${controller.selectedLocation.latitude}, Lng: ${controller.selectedLocation.longitude}',
                              ),
                            ),
                        },
                        gestureRecognizers: <Factory<
                            OneSequenceGestureRecognizer>>{
                          Factory<PanGestureRecognizer>(
                              () => PanGestureRecognizer()),
                          Factory<ScaleGestureRecognizer>(
                              () => ScaleGestureRecognizer()),
                          Factory<TapGestureRecognizer>(
                              () => TapGestureRecognizer()),
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      controller.addOrder(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[700],
                        foregroundColor: Colors.white),
                    child: const Text('Find Bus'),
                  )
                ],
              ),
            ),
          );
        });
  }
}
