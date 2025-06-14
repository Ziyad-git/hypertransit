// import 'package:flutter/material.dart';
// import 'package:hypertransit/screens/add_order/add_order.dart';
// import 'package:hypertransit/screens/delivery_boy_app/delivery_boy_page.dart';

// class ScanPass extends StatefulWidget {
//   const ScanPass({super.key});

//   @override
//   State<ScanPass> createState() => _ScanPassState();
// }

// class _ScanPassState extends State<ScanPass> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: 
//       Center(
//         child: Row(
//           children: [
//             ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (context) => AddOrderPage()));
//                   },
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple,foregroundColor: Colors.white),
//                   child:const Text('Add Order'),
//                 ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(builder: (context) => DeliveryBoyPage()));
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple,foregroundColor: Colors.white),
//               child:const Text('Delivery Boy'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
