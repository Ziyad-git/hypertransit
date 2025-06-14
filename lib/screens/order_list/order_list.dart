import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hypertransit/screens/live_tracking_page/live_tracking_page.dart';
import 'package:hypertransit/screens/order_list/order_list_controller.dart';

class OrdersListPage extends StatelessWidget {
  const OrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderListController>(
      init: OrderListController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Bus List'),
          ),
          body: ListView.builder(
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('driverid')
                    .where('id', isEqualTo: order.id)
                    .limit(1) // Fetch only one driver document
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Bus No : ${order.id}'),
                      subtitle: const Text('Loading driver...'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return ListTile(
                      title: Text('Bus No : ${order.id}'),
                      subtitle: const Text('Driver not found'),
                    );
                  }

                  final driverData = snapshot.data!.docs.first;
                  final driverName = driverData['name'] ?? 'Unknown';
                  final contactNumber =
                      driverData['contact'] ?? 'Not available';

                  return ListTile(
                    title: Text('Bus No : ${order.id}'),
                    subtitle: Text(
                      'Driver: $driverName\nContact No: $contactNumber',
                    ),
                    onTap: () {
                      Get.to(LiveTrackingPage(), arguments: {'order': order});
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
