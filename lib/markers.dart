import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Markers extends StatefulWidget {
  @override
  _MarkersState createState() => _MarkersState();
}

class _MarkersState extends State<Markers> {
  /// Centro da cidade de SP em coordenadas de latitude e longitude
  static const LatLng _center = const LatLng(-23.550897, -46.633149);

  Completer<GoogleMapController> _googleMapController = Completer();

  /// Definindo a primeira posição da variável
  LatLng _lastMapPosition = _center;

  /// Conjunto de markers
  final Set<Marker> _markers = {};


  void _onAddMarkerButtonPressed() async {
    await getAdress(_lastMapPosition);
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: _city,
          snippet: _street + ', ' +
              _number +
              ', ' +
              _neighborhood,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController.complete(controller);
  }

  /// Variáveis que guardam o endereço
  String _street;
  String _number;
  String _neighborhood;
  String _city;

  getAdress(LatLng position) async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    print('>>>>ADRESS<<<<');
    print(placemark[0].toJson());
    _street = placemark[0].thoroughfare;
    _number = placemark[0].subLocality;
    _neighborhood = placemark[0].name;
    _city = placemark[0].subAdministrativeArea;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Markers')),
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
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: _onAddMarkerButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.deepOrange,
                      child: const Icon(Icons.add_location, size: 36.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
