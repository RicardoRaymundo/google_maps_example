import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class DrawPolyline extends StatefulWidget {
  @override
  _DrawPolylineState createState() => _DrawPolylineState();
}

class _DrawPolylineState extends State<DrawPolyline> {
  /// Centro da cidade de SP em coordenadas de latitude e longitude
  static const LatLng _center = const LatLng(-23.550897, -46.633149);

  Completer<GoogleMapController> _googleMapController = Completer();

  /// Recebe a google API Directions
  GoogleMapPolyline _googleMapPolyline = GoogleMapPolyline(apiKey: "AIzaSyCaXztrN0JV_x0I27jHHPYIo6jPDI0bEzM");

  /// Definindo a primeira posição da variável
  LatLng _lastMapPosition = _center;

  /// Conjunto de markers
  final Set<Marker> _markers = {};

  /// Mapa de Polylines
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  int _polylineCount = 1;



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
    _markers.length > 1 ? await _getPolylinesWithLocation(_markers.length - 2, _markers.length - 1) : null;
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


  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController.complete(controller);
  }

  /// Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  _getPolylinesWithLocation(origin, destination) async {
    List<LatLng> _coordinates = await _googleMapPolyline.getCoordinatesWithLocation(
        //origin: origin,
        //destination: destination,
        origin: this._markers.elementAt(origin).position,
        destination: this._markers.elementAt(destination).position,
        mode: RouteMode.driving);

    setState(() {
      //this._polylines.clear();
    });
    _addPolyline(_coordinates);
  }

  _addPolyline(List<LatLng> _coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: this.patterns[0],
        color: Colors.deepOrange,
        points: _coordinates,
        width: 5,
        onTap: () {});

    setState(() {
      this._polylines[id] = polyline;
      this._polylineCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Draw Polyline')),
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

              /// Rotas do maps
              polylines: Set<Polyline>.of(this._polylines.values),

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
