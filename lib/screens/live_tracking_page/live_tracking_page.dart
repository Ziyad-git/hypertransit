import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hypertransit/screens/live_tracking_page/live_tracking_controller.dart';
import 'package:hypertransit/screens/model/my_order.dart';

class LiveTrackingPage extends StatelessWidget {
  Widget build(BuildContext context) {
    Map<String, dynamic> arg = Get.arguments;
    MyOrder order = arg['order'];

    return GetBuilder<LiveTrackingController>(
        init: LiveTrackingController(),
        builder: (controller) {
          controller.myOrder = order;
          controller.updateDestinationLocation(order.latitude, order.longitude);
          controller.startTracking(order.id);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Bus Tracking'),
            ),
            body: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  onMapCreated: (mpCtrl) {
                    controller.mapController = mpCtrl;
                  },
                  initialCameraPosition: CameraPosition(
                    target: controller.BusLocation,
                    zoom: 15.0,
                  ),
                  markers: controller.getMarkers(), // Dynamically updating markers
                ),
                Positioned(
                  top: 16.0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        "Remaining Distance: ${controller.remainingDistance.toStringAsFixed(2)} km",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

extension MarkerUpdate on LiveTrackingController {
  Set<Marker> getMarkers() {
    return {
      Marker(
        markerId: const MarkerId('destination'),
        position: destination,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Stop',
          snippet: 'Lat: ${destination.latitude}, Lng: ${destination.longitude}',
        ),
      ),
      Marker(
        markerId: const MarkerId('deliveryBoy'),
        position: BusLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        infoWindow: InfoWindow(
          title: 'Bus',
          snippet: 'Lat: ${BusLocation.latitude}, Lng: ${BusLocation.longitude}',
        ),
      ),
    };
  }
}
