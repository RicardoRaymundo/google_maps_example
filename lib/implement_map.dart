import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ImplementMap extends StatefulWidget {
  @override
  _ImplementMapState createState() => _ImplementMapState();
}

class _ImplementMapState extends State<ImplementMap> {

  /// Centro da cidade de SP em coordenadas de latitude e longitude
  static const LatLng _center = const LatLng(-23.550897, -46.633149);

  MapType _currentMapType = MapType.normal;

  Completer<GoogleMapController> _googleMapController = Completer();

  /// Definindo a primeira posição da variável
  LatLng _lastMapPosition = _center;

  /// Mapa de Polylines

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController.complete(controller);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Implement Map')),
          backgroundColor: Colors.deepOrange,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              onCameraMove: _onCameraMove,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}