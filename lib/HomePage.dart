import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapas e Geolocalização"),
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            // -11.076070129499586, -37.14183652655418
            target: LatLng(-11.076070129499586, -37.14183652655418),
            zoom: 16,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
