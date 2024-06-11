import 'package:ecoway/src/model/RouteTrip.dart';

class Trips {
  late List<List<RouteEcoTrip>> routes;

  Trips({ required this.routes });

  factory Trips.fromJson(Map<String, dynamic> json) {
    return Trips(routes: json['routes']);
  }
}