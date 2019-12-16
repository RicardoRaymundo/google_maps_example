import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_example/custom_marker.dart';
import 'package:google_maps_example/draw_polyline.dart';
import 'package:google_maps_example/implement_map.dart';
import 'package:google_maps_example/markers.dart';
import 'package:google_maps_example/resourses/custom_transition_animations.dart';
import 'package:google_maps_example/resourses/resource_custom_navigator.dart';
import 'package:google_maps_example/user_location.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  // Mapa de Widgets a serem listados
  final Map<String, Widget> exampleWidgets = {
    'Implement Map': ImplementMap(),
    'User Location': UserLocation(),
    'Markers': Markers(),
    'Custom Marker': CustomMarker(),
    'Draw Polyline': DrawPolyline(),
  };

  @override
  Widget build(BuildContext context) {
    // Cada chave e valor do mapa separados em duas listas
    final List<String> widgetsKeys = exampleWidgets.keys.toList();
    final List<Widget> widgetsValues = exampleWidgets.values.toList();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ListView.builder(
            // O Tamamnho da lista de Cards é o mesmo tamanho da lista de Widgets
            itemCount: this.exampleWidgets.length,

            // Itera cada Card passando o Widget e seu respectivo título
            itemBuilder: (context, index) {
              return Container(
                width: 290.0,
                height: 115.0,
                child: Card(
                  color: Colors.deepOrange,
                  // Posiciona uma area de clique no Card, ao clicar, entra na pagina do exemplo
                  child: InkWell(
                    onTap: () {
                      CustomNavigator.push(context, widgetsValues[index], CustomTransitionAnimations.slideTransitionLeft);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                        left: 64.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(widgetsKeys[index]),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
// MainCard(
//widgetTitle: widgetsKeys[index],
//widget: widgetsValues[index],
//);
