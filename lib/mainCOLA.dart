import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
 var xxx;
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

  /// Recebe a google API Directions
  GoogleMapPolyline _googleMapPolyline = GoogleMapPolyline(apiKey: "SUA_API_KEY");

  /// Definindo a primeira posição da variável
  LatLng _lastMapPosition = _center;

  LatLng lastUserPosition;

  /// Instanciar variável tipo Location
  Location location = Location();

  /// Conjunto de markers
  final Set<Marker> _markers = {};

  /// Mapa de Polylines
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  int _polylineCount = 1;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() async {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(lastUserPosition.toString()),
        position: lastUserPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    await _getPolylinesWithLocation();
  }

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
    });
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

  _getPolylinesWithLocation() async {
    List<LatLng> _coordinates =
    await _googleMapPolyline.getCoordinatesWithLocation(
        origin: this.lastUserPosition,
        destination: this._markers.elementAt(0).position,
        mode: RouteMode.driving);

    setState(() {
      this._polylines.clear();
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
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
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
                  children: <Widget> [
                    SizedBox(height: 60,),
                    FloatingActionButton(
                      onPressed: _onMapTypeButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.map, size: 36.0),
                    ),
                    SizedBox(height: 16.0),
                    FloatingActionButton(
                      onPressed: _onAddMarkerButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
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