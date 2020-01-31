# Google Maps Flutter

- [developers.google.com/maps/documentation](https://developers.google.com/maps/documentation?hl=pt)
- [medium.com/flutter/google-maps-and-flutter](https://medium.com/flutter/google-maps-and-flutter-cfb330f9a245)
- [medium.com/flutter-community/exploring-google-maps-in-flutter](https://medium.com/flutter-community/exploring-google-maps-in-flutter-8a86d3783d24)
- [codelabs.developers.google.com/codelabs/google-maps-in-flutter/#3](https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/#3)
- [http://flutterdevs.com/blog/google-maps-in-flutter/](http://flutterdevs.com/blog/google-maps-in-flutter/)

## Conteúdo
- [Instalar](#instalar)
- [Utilizar](#utilizar)
- [Aprender](#aprender)
- [Contribuir](#contribuir)


## Instalar
[https://pub.dev/packages/google_maps_flutter](https://pub.dev/packages/google_maps_flutter)

``` yaml
dependencies:
  google_maps_flutter: versão mais recente
```

### Obtenha API KEY
[get-api-key](https://developers.google.com/maps/documentation/javascript/get-api-key)

### Configure a API
> Insira a API key em: android/app/src/main/AndroidManifest.xml

``` xml
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="SUA API KEY"/>
```

**!!! ATENÇÃO - NUNCA PUBLIQUE A API KEY EM REPOSITÓRIOS PÚBLICOS !!!**

## Utilizar
### Hello, World
[github.com/flutter/plugins/tree/master/packages/google_maps_flutter](https://github.com/flutter/plugins/tree/master/packages/google_maps_flutter)

[pub.dev/packages/google_maps_flutter#sample-usage](https://pub.dev/packages/google_maps_flutter#sample-usage) 

[medium.com/flutter/google-maps-and-flutter](https://medium.com/flutter/google-maps-and-flutter-cfb330f9a245)

![implement map](https://github.com/RicardoRaymundo/google_maps_example/blob/master/lib/images/implement_map.jpg)

#### Instancie um mapa
Completer<GoogleMapController> _controller = Completer();

``` dart
@override
Widget build…
...
GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
...
```

#### Habilite e registre a localização do usuário
[Working with Geolocation and Geocoding in Flutter](https://medium.com/swlh/working-with-geolocation-and-geocoding-in-flutter-and-integration-with-maps-16fb0bc35ede)

[pub.dev/packages/location](https://pub.dev/packages/location)

![user location](https://github.com/RicardoRaymundo/google_maps_example/blob/master/lib/images/user_location.jpg)

Registre a permissão em android/app/src/main/AndroidManifest.xml

```xml
<manifest> …
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name= "android.permission.ACCESS_COARSE_LOCATION"/>
...
```

Adicione a biblioteca em pubspec.yaml
``` yaml
dependencies:
 location: Versão_mais_recente
```

No arquivo .dart:
``` dart
/// Instanciar variável tipo Location
Location location = Location();

/// Variável que recebe os dados da localização do usuário
LocationData currentLocation;

/// Variável que registra a última posição do usuário
LatLng _lastUserPosition;

/// Executar o getMyLocation no initState
@override
void initState() {
 getMyLocation();
 super.initState();
}

/// Executar o getLocation em método async
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

 /// Atualiza constantemente a última posição do usuário
 this.location.onLocationChanged().listen((LocationData currentLocation) {
   this._lastUserPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
 });
}

/// Habilitar a localização de usuário no widget
GoogleMap(
	...
myLocationEnabled: true,
...      
),
```

#### Pegue o tempo e distância de viagem 
[Distance Matrix API](https://developers.google.com/maps/documentation/distance-matrix/intro) 
[Stack overflow - How to get estimated travel time and distance in flutter](https://stackoverflow.com/questions/51134004/how-to-get-estimated-travel-time-and-distance-in-flutter)

``` yaml
/// Adicione a biblioteca de http client em pubspec.yaml
dependencies:
 dio: Versão_mais_recente
```

``` dart
/// http client
Dio dio = Dio();

/// Método que pega 
getTravelDistance() async {
 Response response = await dio.get(

   /// Realizando um http request no google cloud para obter o endereco atravez das coordenadas   "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${_lastUserPosition
         .latitude},${_lastUserPosition.longitude}&destinations=${_markers
         .elementAt(0)
         .position
         .latitude}%2C${_markers
         .elementAt(0)
         .position
         .longitude}%7C&key=AIzaSyCaXztrN0JV_x0I27jHHPYIo6jPDI0bEzM"
 );
/// Resposta do http request, teste e veja os dados recebidos
print(response.data);
}
```

### Câmera
[https://developers.google.com/android/reference/com/google/android/gms/maps/model/CameraPosition](https://developers.google.com/android/reference/com/google/android/gms/maps/model/CameraPosition)

#### Posição inicial da câmera

``` dart
GoogleMap(
	...
/// Recebe a posição inicial do mapa ao ser carregado
initialCameraPosition: CameraPosition(
 target: LatLng(-23.550897, -46.633149)
,
/// Zoom inicial do maps
 zoom: 15.0,
  ),
...      
),
```

#### Registre posição de onde a câmera aponta

``` dart
/// Recupera o ponto central do mapa (centro da câmera)
CameraPosition _onCameraMove(CameraPosition position) {
 this._lastMapPosition = position.target;
}

...

GoogleMap(
	...
/// Atualiza a posição de câmera
onCameraMove: _onCameraMove,

...      
),
```

### Marker
#### Crie um marcador

![marker](https://github.com/RicardoRaymundo/google_maps_example/blob/master/lib/images/markers.jpg)

``` dart
/// Conjunto de markers vazio, saiba mais sobre a classe Set
Set<Marker> _markers = {};

setState(() {

/// Adicionando um Marker no Set 
this._markers.add(Marker(

 /// Este id de marcador pode ser qualquer coisa que identifica únicamente cada marcador
 markerId: MarkerId(this._lastMapPosition.toString()),

 /// Posição do marcador será a coordenada atual do mapa
 /// Pode-se também adicionar manualmente um marcador em uma posição específica, por ex:
 /// LatLng(-23.550897, -46.633149)
 position: this._lastMapPosition,
 infoWindow: InfoWindow(
  
   // Janela com título e descrição do marcador
   title: 'Really cool place',
   snippet: this._address,
 ),
 icon: BitmapDescriptor.defaultMarker,
));
}
```

#### Adicione os marcadores no maps

``` dart
GoogleMaps(
	...
	markers: this._markers,
	…
)
```

#### Remova todos os marcadores

``` dart
/// Conjunto de markers vazio
this._markers = {};
ou
this._markers.clear();
```

#### Customize o ícone

![custom marker](https://github.com/RicardoRaymundo/google_maps_example/blob/master/lib/images/custom_marker.jpg)

[https://stackoverflow.com/questions/53633404/how-to-change-the-icon-size-of-google-maps-marker-in-flutter](https://stackoverflow.com/questions/53633404/how-to-change-the-icon-size-of-google-maps-marker-in-flutter)

``` dart
import 'dart:ui' as ui;

Future<Uint8List> getBytesFromAsset(String path, int width) async {
 ByteData data = await rootBundle.load(path);
 ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
 ui.FrameInfo fi = await codec.getNextFrame();
 return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
}
…
final Uint8List markerIcon = await getBytesFromAsset('assets/bike.jpg', 70);
final Marker marker = Marker(icon: BitmapDescriptor.fromBytes(markerIcon));
```

#### Drag and Drop

```dart
GoogleMap(
	...
	draggable: true
...      
),
```

### Polylines
#### Trace uma rota(polyline)
[Biblioteca 'google_map_polyline'](https://pub.dev/packages/google_map_polyline)
[Exemplo detalhado de uso da biblioteca (GitHub)](https://github.com/Shark01/google_map_polyline/blob/master/example/lib/main.dart)

![polylines](https://github.com/RicardoRaymundo/google_maps_example/blob/master/lib/images/custom_marker.jpg)


```yaml
/// Instale a versão mais recente da lib em pubspec.yaml
dependencies:
google_map_polyline: VERSÃO_MAIS_RECENTE
```
```dart
    /// Recebe a google API Directions
    GoogleMapPolyline _googleMapPolyline = GoogleMapPolyline(apiKey: "SUA API KEY");

///  Pega as coordenadas pelas localizações de origem e destino
/// Para melhor entendimento, exemplo completo de implementação no segundo link deste tópico --> Exemplo detalhado de uso da biblioteca (GitHub)
await _googleMapPolyline.getCoordinatesWithLocation(
   origin: _lastUserPosition,
   destination: _markers.elementAt(0).position,
   mode: RouteMode.driving
);
```

#### Remover as polylines

``` dart
///Limpa o Map que contém as polylines
setState(() {
 this._polylines.clear();
});
```

### Polygons
#### Insira um polygon

[https://github.com/flutter/plugins/blob/master/packages/google_maps_flutter/example/lib/place_polygon.dart](https://github.com/flutter/plugins/blob/master/packages/google_maps_flutter/example/lib/place_polygon.dart)

``` dart
Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
int _polygonIdCounter = 1;
PolygonId selectedPolygon;

/// Registra qual polygon está Polygon selecionado
void _onPolygonTapped(PolygonId polygonId) {
 setState(() {
   selectedPolygon = polygonId;
 });
}

/// Adicionar um Polygon no mapa
void _add() {
 final int polygonCount = polygons.length;

/// Define o número máximo de Polygon no mapa
 if (polygonCount == 12) {
   return;
 }
 
/// Registra um id único para o Polygon
 final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
 _polygonIdCounter++;
 final PolygonId polygonId = PolygonId(polygonIdVal);

/// Criando um objeto Polygon
 final Polygon polygon = Polygon(
   polygonId: polygonId,
   consumeTapEvents: true,
   strokeColor: Colors.orange,
   strokeWidth: 5,
   fillColor: Colors.green,

/// Método que cria os pontos LatLng que definem os vértices do Polygon
   points: _createPoints(),
   onTap: () {
     _onPolygonTapped(polygonId);
   },
 );

/// Adiciona o Polygon criado à lista polygons
 setState(() {
   polygons[polygonId] = polygon;
 });

}

GoogleMap(
	...
polygons: Set<Polygon>.of(polygons.values),
...      
),
```


#### Remova um polygon

``` dart
void _remove() {
 setState(() {
   if (polygons.containsKey(selectedPolygon)) {
     polygons.remove(selectedPolygon);
   }
   selectedPolygon = null;
 });
}
```

### Geolocator
[Biblioteca Geolocator](https://pub.dev/packages/geolocator)
#### Pegue a localização por coordenadas ou endereço
[pub.dev/packages/geolocator#geocoding](https://pub.dev/packages/geolocator#geocoding)
##### Por endereço:
``` dart
  /// Variáveis que guardam o endereço
  String _street;
  String _number;
  String _neighborhood;
  String _city;
  double _latitude;
  double _longitude;

  /// address = "Av Leão Machado, 100 - Jaguaré, São Paulo"
  getAdress(String address) async {
    List<Placemark> placemark = await Geolocator().placemarkFromAddress(address);
    print('>>>>ADRESS<<<<');
    print(placemark[0].toJson());
    _street = placemark[0].thoroughfare;
    _number = placemark[0].subLocality;
    _neighborhood = placemark[0].name;
    _city = placemark[0].subAdministrativeArea;
    _latitude = placemark[0].position.latitude;
    _longitude = placemark[0].position.longitude;
  }
```

##### Por coordenadas:
``` dart
  /// Variáveis que guardam o endereço
  String _street;
  String _number;
  String _neighborhood;
  String _city;
  
  /// position = LatLng(-23.531140, -46.720788)
  getAdressFromCoordinates(LatLng position) async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    _street = placemark[0].thoroughfare;
    _number = placemark[0].subLocality;
    _neighborhood = placemark[0].name;
    _city = placemark[0].subAdministrativeArea;
  }
```

##### Resultado:
Ambos os métodos retornam `List<Placemark>`, então ao executar `print(placemark[0].toJson())` obteremos:

![](https://github.com/RicardoRaymundo/google_maps_example/blob/master/lib/images/get_address_result.png)

## Aprender
- [Introdução a Google maps api](https://www.devmedia.com.br/introducao-a-google-maps-api/26967)
- [8 alternativas poderosas para Google maps api](https://mundoapi.com.br/apis-publicadas/8-alternativas-poderosas-para-a-api-do-google-maps/)
- [Preços da Google maps api](https://arkansystem.com.br/precos-da-api-google-maps/)
- [Lista de tutoriais youtube](https://www.youtube.com/watch?v=_L4IQoAWD9E&list=PLgGbWId6zgaXFR4SW_3qJ55cxmEqRNIzx&index=1)



## Contribuir
Contribuições são sempre muito bem vindas! Não precisam ser somente através de desenvolvimento de código, qualquer ajuda com ideias, sugestões, melhorias na documentação e doações são sempre muito apreciadas!

Participe da comunidade [**Projeto que Vale**](http://www.projetoquevale.com.br/) e colabore da forma que achar melhor.

## Licença
MIT License

Copyright (c) 2018 PROJETO QUE VALE

É concedida permissão, gratuitamente, a qualquer pessoa que obtenha uma cópia deste software e dos arquivos de documentação associados (o "Software"), para negociar o Software sem restrições, incluindo, sem limitação, os direitos de uso, cópia, modificação e fusão , publicar, distribuir, sublicenciar e / ou vender cópias do Software, e permitir que as pessoas a quem o Software é fornecido o façam, sujeitas às seguintes condições:

O aviso de copyright acima e este aviso de permissão devem ser incluídos em todas as cópias ou partes substanciais do Software.
O SOFTWARE É FORNECIDO "NO ESTADO EM QUE SE ENCONTRA", SEM NENHUM TIPO DE GARANTIA, EXPRESSA OU IMPLÍCITA, INCLUINDO, MAS NÃO SE LIMITANDO ÀS GARANTIAS DE COMERCIALIZAÇÃO, ADEQUAÇÃO A UM FIM ESPECÍFICO E NÃO VIOLAÇÃO. EM NENHUMA CIRCUNST NCIA, OS AUTORES OU PROPRIETÁRIOS DE DIREITOS DE AUTOR PODERÃO SER RESPONSABILIZADOS POR QUAISQUER REIVINDICAÇÕES, DANOS OU OUTRAS RESPONSABILIDADES, QUER EM ACÇÃO DE CONTRATO, DELITO OU DE OUTRA FORMA, DECORRENTES DE, OU EM CONEXÃO COM O SOFTWARE OU O USO OU OUTRAS NEGOCIAÇÕES NO PROGRAMAS.



