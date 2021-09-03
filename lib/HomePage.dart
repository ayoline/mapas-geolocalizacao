import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  // Set é como um Map mas sem o índice, que usa apenas uma posição
  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _carregarMarcadores();
    _recuperarLocalizacaoAtual();
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
            target: LatLng(-11.095173932052713, -37.13397389842669),
            zoom: 15,
          ),
          onMapCreated: _onMapCreated,
          markers: _marcadores,
          polygons: _polygons,
          polylines: _polylines,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _movimentarCamera,
      ),
    );
  }

  _recuperarLocalizacaoAtual() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    print("localizacao atual: " + position.toString());
  }

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(-11.082768893652867, -37.14316208940462),
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

    Set<Polygon> listaPolygons = {};
    Polygon polygon1 = Polygon(
        polygonId: PolygonId("polygon1"),
        fillColor: Colors.green,
        strokeColor: Colors.red,
        strokeWidth: 10,
        points: [
          LatLng(-11.091495648956094, -37.13668947232826),
          LatLng(-11.088264300963973, -37.134143529092015),
          LatLng(-11.089819235988399, -37.14056779130052),
        ],
        consumeTapEvents: true, // Faz com que a imagem seja clicável
        onTap: () {
          print("clicado na área");
        });

    listaPolygons.add(polygon1);

    setState(() {
      _polygons = listaPolygons;
    });

    Set<Polyline> listaPolylines = {};
    Polyline polyline1 = Polyline(
      polylineId: PolylineId("polyline1"),
      color: Colors.blue,
      width: 10,
      startCap: Cap.roundCap, // começo da linha fica redondo
      endCap: Cap.roundCap, // final da linha fica redondo
      points: [
        LatLng(-11.1017041273015, -37.127914375137706),
        LatLng(-11.098688573157276, -37.13650314051403),
        LatLng(-11.096111151774886, -37.139681246356645),
      ],
    );

    listaPolylines.add(polyline1);
    setState(() {
      _polylines = listaPolylines;
    });
  }
}
