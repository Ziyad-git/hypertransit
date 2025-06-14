import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hypertransit/screens/busmap.dart';

class StudentMap extends StatefulWidget {
  const StudentMap({Key? key}) : super(key: key);

  @override
  _StudentMapState createState() => _StudentMapState();
}

class _StudentMapState extends State<StudentMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Tracking'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Busmap()));
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (controller) => {},
            initialCameraPosition: CameraPosition(
              target: LatLng(10.166040800933787, 76.43892452701589),
              zoom: 14
            ),
          ),
          Positioned(
            top : 16.0,
            left : 0,
            right : 0,
            child:Center(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(8.0)
                ),
                child: Text("Remaining Distance : 2 Kilometers",
                style:TextStyle(fontSize: 16.0))
              )
            )
          )
        ]
      )
    );
  }
}