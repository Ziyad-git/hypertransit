// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hypertransit/screens/delivery_boy_app/delivery_boy_controller.dart';
// import 'package:url_launcher/url_launcher.dart';

// class DeliveryBoyPage extends StatelessWidget {
//   const DeliveryBoyPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<DeliveryBoyController>(
//       init: DeliveryBoyController(),
//         builder: (controller) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Delivery Boy App'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ListView(
//             children: [
//               Image.network(
//                 'https://img.freepik.com/free-vector/illustration-delivery-service-with-mask-design_23-2148509423.jpg',
//                 width: 200,
//                 height: 200,
//               ),
//               const Text(
//                 'Enter MyOrder ID:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: controller.orderIdController,
//                 decoration: const InputDecoration(
//                   hintText: 'MyOrder ID',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Visibility(
//                 visible: !controller.showDeliveryInfo,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     controller.getOrderById();
//                   },
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
//                   child: const Text('Submit'),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               //? Display delivery address and phone number if available
//               Visibility(
//                 visible: controller.showDeliveryInfo,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       'Delivery Address: ${controller.deliveryAddress}',
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Phone Number: ${controller.phoneNumber}',
//                           style: const TextStyle(fontSize: 18),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.call),
//                           onPressed: () {
//                             // Launch the phone dialer with the phone number
//                             launch('tel:${controller.phoneNumber}');
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Amount to Collect: \$ ${controller.amountToCollect}',
//                       style: const TextStyle(fontSize: 18),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             launchUrl(Uri.parse('https://www.google.com/maps?q=${controller.customerLatitude},${controller.customerLongitude}'));
//                           },
//                           style:
//                           ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
//                           icon: Icon(Icons.location_on),
//                           label: Text('Show Location'),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             controller.startDelivery();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             foregroundColor: Colors.white,
//                           ),
//                           child: const Text('Start Delivery'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
