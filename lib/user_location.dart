import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class UserLocation extends StatefulWidget {
  @override
  _UserLocationState createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  @override
  void initState() {
    getMyLocation();
    super.initState();
  }

  /// Centro da cidade de SP em coordenadas de latitude e longitude
  static const LatLng _center = const LatLng(-23.550897, -46.633149);

  /// Variável que recebe os dados da localização do usuário
  LocationData currentLocation;

  MapType _currentMapType = MapType.normal;

  Completer<GoogleMapController> _googleMapController = Completer();

   /// Definindo a primeira posição da variável
  LatLng _lastMapPosition = _center;

  LatLng lastUserPosition;

  /// Instanciar variável tipo Location
  Location location = Location();

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController.complete(controller);
  }


  getMyLocation() async {

    /// Mensagens da plataforma podem falhar, então é usado um try/catch PlatformException.
    try {
      this.currentLocation = await this.location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        String error = 'Permission denied';
      }
      this.currentLocation = null;
    }

    /// Atualiza constantemente a ultima posição do usuário
    this.location.onLocationChanged().listen((LocationData currentLocation) {
      this.lastUserPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
      print(currentLocation.latitude);
      print(currentLocation.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('User Location')),
          backgroundColor: Colors.deepOrange,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,

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
                  children: <Widget> [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}