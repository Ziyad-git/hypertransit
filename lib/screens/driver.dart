import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hypertransit/screens/delivery_boy_app/delivery_boy_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverScreen extends StatelessWidget {
  const DriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveryBoyController>(
        init: DeliveryBoyController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Bus Driver'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Image.asset(
                      "assets/bus_driver.png",
                      width: 200,
                      height: 200,
                  ),
                  const Text(
                    'Enter Bus Number:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.busNoController,
                    decoration: const InputDecoration(
                      hintText: 'Bus Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: !controller.showDeliveryInfo,
                    child: ElevatedButton(
                      onPressed: () async {
                        controller.getOrderById();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[700],
                          foregroundColor: Colors.white),
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: controller.showDeliveryInfo,
                    child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('driverid')
                              .where('id', isEqualTo: controller.busNoController.text)
                              .limit(1)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text('Loading driver info...',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Text('Driver not found',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                            }
                            final driverName = snapshot.data!.docs.first['name'];
                            return Text('Driver : $driverName',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // ElevatedButton.icon(
                            //   onPressed: () {
                            //     launchUrl(Uri.parse(
                            //         'https://www.google.com/maps?q=${controller.customerLatitude},${controller.customerLongitude}'));
                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //       backgroundColor: Colors.blueAccent,
                            //       foregroundColor: Colors.white),
                            //   icon: const Icon(Icons.location_on),
                            //   label: const Text('Show Location'),
                            // ),
                            ElevatedButton(
                              onPressed: () {
                                controller.startDelivery();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Start Journey'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}