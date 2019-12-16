# Google Maps API JS


## Conteúdo
- [Instalar](#instalar)
- [Utilizar](#utilizar)
- [Aprender](#aprender)
- [Contribuir](#contribuir)

## Instalar

``` html
<script async defer src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&callback=initMap" type="text/javascript"></script>
```

### Obtenha API KEY
[get-api-key](https://developers.google.com/maps/documentation/javascript/get-api-key)

### Configure a API
[Loading_the_Maps_API](https://developers.google.com/maps/documentation/javascript/tutorial#Loading_the_Maps_API) 

**!!! ATENÇÃO - NUNCA PUBLIQUE A API KEY EM REPOSITÓRIOS PÚBLICOS !!!**


## Utilizar
### Hello, World

[tutorial#The_Hello_World_of_Google_Maps_v3
examples/map-simple](https://github.com/flutter/plugins/tree/master/packages/google_maps_flutter)

#### Instancie um mapa

``` javascript
function initMap() { 
  var myLatLng = {lat: -25.363, lng: 131.044};
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 4,
    center: myLatLng
  });
}
```

#### Localização do usuário

[https://developers.google.com/maps/documentation/javascript/geolocation](https://developers.google.com/maps/documentation/javascript/geolocation)

[MDN - Geolocation.getCurrentPosition()](https://developer.mozilla.org/pt-BR/docs/Web/API/Geolocation/getCurrentPosition)

``` js
// Para esse exemplo deve ser permitido o compartilhamento de posição do usuário pelo browser
navigator.geolocation.getCurrentPosition(function(position) {
            var pos = {
              lat: position.coords.latitude,
              lng: position.coords.longitude
            };
               map.setCenter(pos);
          }, function() {
            handleLocationError(true, infoWindow, map.getCenter());
          });
```

#### Pegue o tempo e distância de viagem

[distancematrix#distance_matrix_requests](https://developers.google.com/maps/documentation/javascript/distancematrix#distance_matrix_requests) 
[distance-matrix/#DistanceMatrixService](https://developers.google.com/maps/documentation/javascript/reference/distance-matrix/#DistanceMatrixService)
[Exemplo](https://codepen.io/youfoundron/pen/GIlvp) 
[developers.google.com/maps/documentation/javascript/distancematrix](https://developers.google.com/maps/documentation/javascript/distancematrix)
[examples/distance-matrix#try-it-yourself](https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/distance-matrix#try-it-yourself) 

```
// Instanciando o serviço para obter tempo e distância de viagem
var service = new google.maps.DistanceMatrixService;
       
// Executando o método do serviço que retorna o tempo e distância de viagem
  distanceMatrixService.getDistanceMatrix(distanceMatrixRequest, callback);

/* O distanceMatrixRequest é uma interface que envia uma query com   
 *parâmetros de pontos de origem, destino e diversas opções para fins de 
 *computação*/
var distanceMatrixRequest = {
          origins: [origin1, origin2],
          destinations: [destinationA, destinationB],
          travelMode: 'DRIVING',
          unitSystem: google.maps.UnitSystem.METRIC,
          avoidHighways: false,
          avoidTolls: false
        }

/* O callback é uma função que recebe DistanceMatrixResponse e 
 *DistanceMatrixStatus e é executada após o fim do distanceMatrixRequest. Aqui
 * pode ser executada a formatação dos dados recebidos pela request*/
function(response, status) {
          if (status !== 'OK') {
            alert('Error was: ' + status);
          } else {

// Registrando os endereços de origem e destino recebidos pela response
            var originList = response.originAddresses;
            var destinationList = response.destinationAddresses;
            var outputDiv = document.getElementById('output');
            outputDiv.innerHTML = '';
            deleteMarkers(markersArray);


// Adicionando os markers e definindo o auto zoom
            var showGeocodedAddressOnMap = function(asDestination) {
              var icon = asDestination ? destinationIcon : originIcon;
              return function(results, status) {
                if (status === 'OK') {
                  map.fitBounds(bounds.extend(results[0].geometry.location));
                  markersArray.push(new google.maps.Marker({
                    map: map,
                    position: results[0].geometry.location,
                    icon: icon
                  }));
                } else {
                  alert('Geocode was not successful due to: ' + status);
                }
              };
            };

	// Dispondo no HTML os endereços recebidos  
            for (var i = 0; i < originList.length; i++) {
              var results = response.rows[i].elements;
              geocoder.geocode({'address': originList[i]},
                  showGeocodedAddressOnMap(false));
              for (var j = 0; j < results.length; j++) {
                geocoder.geocode({'address': destinationList[j]},
                    showGeocodedAddressOnMap(true));
                outputDiv.innerHTML += originList[i] + ' to ' + destinationList[j] +
                    ': ' + results[j].distance.text + ' in ' +
                    results[j].duration.text + '<br>';
              }
            }
          }
        }
```

### Marker
#### Crie um marcador
[examples/marker-simple](https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/marker-simple) 
[markers#add](https://developers.google.com/maps/documentation/javascript/markers#add)

```
var marker = new google.maps.Marker({
    position: myLatLng,
    map: map,
    title: 'Hello World!'
  });
```

#### Adicione um marcador

```
marker.setMap(map);
```

#### Remova todos os marcadores

```
marker.setMap(null);
```

#### Animação
[markers#animate](https://developers.google.com/maps/documentation/javascript/markers#animate) 
[examples/marker-animations](https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/marker-animations)

```
marker = new google.maps.Marker({
animation: google.maps.Animation.DROP
});
```

#### Evento de click

```
marker.addListener('click', toggleBounce);

function toggleBounce() {
  if (marker.getAnimation() !== null) {
    marker.setAnimation(null);
  } 
  else {
    marker.setAnimation(google.maps.Animation.BOUNCE);
  }
}
```

#### Adicione marcadores ao clicar

[https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/marker-labels](https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/marker-labels)

```
 function initMap() {
	...
//Crie um event listener que executa addMarker() quando o mapa é clicado.
        	google.maps.event.addListener(map, 'click', function(event) {
          	addMarker(event.latLng, map);
        });  
}
      function addMarker(location, map) {
        // Adicione um marker no local onde o mapa foi clicado
        var marker = new google.maps.Marker({
          position: location,
          map: map
        });
      }
```

#### Customize o ícone

[markers#icons](https://developers.google.com/maps/documentation/javascript/markers#icons) 
[examples/marker-labels](https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/marker-labels)

```
marker = new google.maps.Marker({
icon: 'URL DA IMAGEM'
  });
```

#### Ícone complexo

[markers#complex_icons](https://developers.google.com/maps/documentation/javascript/markers#complex_icons) 
[examples/icon-complex](https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/icon-complex)

#### Drag and Drop
[markers#draggable](https://developers.google.com/maps/documentation/javascript/markers#draggable) 

```
marker = new google.maps.Marker({
draggable: true,
});
```

#### Ícone SVG

[symbols#add_to_marker](https://developers.google.com/maps/documentation/javascript/symbols#add_to_marker) 
[examples/marker-symbol-custom](https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/marker-symbol-custom)


### Polylines
#### Trace uma polyline
[shapes#polyline_add](https://developers.google.com/maps/documentation/javascript/symbols#add_to_marker)
[examples/polyline-simple](https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/marker-symbol-custom) 

```
var path = [
    {lat: 37.772, lng: -122.214},
    {lat: 21.291, lng: -157.821},
    {lat: -18.142, lng: 178.431},
    {lat: -27.467, lng: 153.027}
 ];
  var flightPath = new google.maps.Polyline({
    path: path,
    geodesic: true,
    strokeColor: '#FF0000',
    strokeOpacity: 1.0,
    strokeWeight: 2
  });

flightPath.setMap(map);
```

#### Remova uma polyline
```
flightPath.setMap(null);
```

#### Trace uma rota com Directions API
[Directions API](https://developers.google.com/maps/documentation/javascript/directions#Directions) 
[Exemplo de implementação](https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/directions-travel-modes) 

```
function initMap() {
        var directionsRenderer = new google.maps.DirectionsRenderer;
        var directionsService = new google.maps.DirectionsService;
       ...
        directionsRenderer.setMap(map);

        calculateAndDisplayRoute(directionsService, directionsRenderer);
        document.getElementById('mode').addEventListener('change', function() {
          calculateAndDisplayRoute(directionsService, directionsRenderer);
        });
      }

      function calculateAndDisplayRoute(directionsService, directionsRenderer) {
        var selectedMode = document.getElementById('mode').value;
        directionsService.route({
          origin: {lat: -23.5677552, lng: -46.7183694},  // Instituto butanta
          destination: {lat: -23.6507056, lng: -46.6215427},  // Ocean Beach.
          /// A propriedade nas chaves de TravelMode pode ser DRIVING (Default), BICYCLING, TRANSIT ou WALKING 
          travelMode: google.maps.TravelMode[selectedMode]
        }, function(response, status) {
          if (status == 'OK') {
            directionsRenderer.setDirections(response);
          } else {
            window.alert('Directions request failed due to ' + status);
          }
        });
      }

```

#### Operadores de Inspeção
[shapes#polyline_inspect](https://developers.google.com/maps/documentation/javascript/shapes#polyline_inspect) 

- getPath() Retorna a lista de objetos LatLng da array tipo MVCArray que compõe a polyline
- getAt() Retorna a LatLng de determinado  index  
- insertAt() Insere objeto LatLng em determinado index, empurrando os itens à frente 
- removeAt() Remove objeto LatLng em determinado index



### Polygons
#### Insira um polygon
Os operadores de inspeção de Polygon são os mesmo que os de Polyline

[shapes#polygon_add](https://developers.google.com/maps/documentation/javascript/shapes#polyline_inspect)

```
var paths = [
    {lat: 25.774, lng: -80.190},
    {lat: 18.466, lng: -66.118},
    {lat: 32.321, lng: -64.757},
  ];

  var bermudaTriangle = new google.maps.Polygon({
    paths: paths,
    strokeColor: '#FF0000',
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: '#FF0000',
    fillOpacity: 0.35
  });

  bermudaTriangle.setMap(map);
```

#### Remova um polygon

```
bermudaTriangle.setMap(null);
```

 
## Aprender
- Introdução a Google maps api
- 8 alternativas poderosas para Google maps api
- Preços da Google maps api
- Lista de tutoriais youtube

## Licença
MIT License

Copyright (c) 2019 Ricardo Raymundo

É concedida permissão, gratuitamente, a qualquer pessoa que obtenha uma cópia deste software e dos arquivos de documentação associados (o "Software"), para negociar o Software sem restrições, incluindo, sem limitação, os direitos de uso, cópia, modificação e fusão , publicar, distribuir, sublicenciar e / ou vender cópias do Software, e permitir que as pessoas a quem o Software é fornecido o façam, sujeitas às seguintes condições:

O aviso de copyright acima e este aviso de permissão devem ser incluídos em todas as cópias ou partes substanciais do Software.

O SOFTWARE É FORNECIDO "NO ESTADO EM QUE SE ENCONTRA", SEM NENHUM TIPO DE GARANTIA, EXPRESSA OU IMPLÍCITA, INCLUINDO, MAS NÃO SE LIMITANDO ÀS GARANTIAS DE COMERCIALIZAÇÃO, ADEQUAÇÃO A UM FIM ESPECÍFICO E NÃO VIOLAÇÃO. EM NENHUMA CIRCUNST NCIA, OS AUTORES OU PROPRIETÁRIOS DE DIREITOS DE AUTOR PODERÃO SER RESPONSABILIZADOS POR QUAISQUER REIVINDICAÇÕES, DANOS OU OUTRAS RESPONSABILIDADES, QUER EM ACÇÃO DE CONTRATO, DELITO OU DE OUTRA FORMA, DECORRENTES DE, OU EM CONEXÃO COM O SOFTWARE OU O USO OU OUTRAS NEGOCIAÇÕES NO PROGRAMAS.



