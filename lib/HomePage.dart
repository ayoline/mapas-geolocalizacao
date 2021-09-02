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

  // Set é como um Map mas sem o índice, que usa apenas uma posição
  Set<Marker> _marcadores = {};

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(-11.076070129499586, -37.14183652655418),
      zoom: 19, // muda o zoom da camera
      tilt: 30, // muda o angulo da camera
      bearing: 30, // rotaciona a camera
    )));
  }

  _carregarMarcadores() {
    Set<Marker> _marcadoresLocal = {};

    Marker marcadorMercado = Marker(
      markerId: MarkerId("marcador-Mercado"),
      position: LatLng(-11.09611097535822, -37.13930358541416),
      // Adiciona um título ao marcador
      infoWindow: InfoWindow(
        title: "Mercado Passeo",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        // muda a cor padrão do icone
        BitmapDescriptor.hueBlue,
      ),
      onTap: () {
        print("Mercado Clicado!!");
      },
    );

    Marker marcadorIgreja = Marker(
      markerId: MarkerId("marcador-Igreja"),
      position: LatLng(-11.097121315494359, -37.138092648056215),
      infoWindow: InfoWindow(
        title: "Igreja Batista",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        // muda a cor padrão do icone
        BitmapDescriptor.hueOrange,
      ),
    );

    _marcadoresLocal.add(marcadorMercado);
    _marcadoresLocal.add(marcadorIgreja);

    setState(() {
      _marcadores = _marcadoresLocal;
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarMarcadores();
  }

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
            target: LatLng(-11.09611097535822, -37.13930358541416),
            zoom: 16,
          ),
          onMapCreated: _onMapCreated,
          markers: _marcadores,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _movimentarCamera,
      ),
    );
  }
}
