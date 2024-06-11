import 'dart:convert';
import 'package:ecoway/src/enumeration/RouteModeEnum.dart';
import 'package:ecoway/src/model/LocationEcotTrip.dart';
import 'package:ecoway/src/model/RouteTrip.dart';
import 'package:http/http.dart' as http;

Future<List<List<RouteEcoTrip>>> createTrip(RouteModeEnum mode, LocationEcoTrip origin, LocationEcoTrip destination) async {
    try {
      print("Chegou aqui");
      print({
          'startMode': mode.name,
          'origin': {
            'lat': origin.lat,
            'lng': origin.lng,
          },
          'destination': {
            'lat': destination.lat,
            'lng': destination.lng,
            },
        });
      final response = await http.post(
        Uri.parse("http://ecotrip.ddns.net:8080/trips/calculate"),
        headers: <String, String> {
          'Content-Type': 'application/json',
          'accept': '*/*'
        },
        body: jsonEncode(<String, dynamic> {
          'startMode': mode.name,
          'origin': {
            'lat': origin.lat,
            'lng': origin.lng,
          },
          'destination': {
            'lat': destination.lat,
            'lng': destination.lng,
            },
        })
      );
      print(response.body);
      if (response.statusCode == 200) {
        print("deu certo");
        List<dynamic> body = json.decode(response.body);
        List<List<RouteEcoTrip>> routes = body.map((dynamic outerList) {
          List<dynamic> innerList = outerList as List<dynamic>;
          return innerList.map((dynamic item) => RouteEcoTrip.fromJson(item)).toList();
        }).toList();
        return routes;
      } else {
        throw Exception('Failed to create route');
      }
  } on http.ClientException catch(e) {
    print(e.message);
    throw e;
  }
}

List<List<RouteEcoTrip>> parseRoutes(String responseBody) {
  final parsed = json.decode(responseBody).cast<List<dynamic>>();

  return parsed.map<List<RouteEcoTrip>>((list) => 
    list.map<RouteEcoTrip>((json) => RouteEcoTrip.fromJson(json)).toList()
  ).toList();
}