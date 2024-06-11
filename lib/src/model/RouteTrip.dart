import 'package:ecoway/src/enumeration/RouteModeEnum.dart';
import 'package:ecoway/src/model/LocationEcotTrip.dart';
import 'package:ecoway/src/util/RouteModeTypeUtil.dart';

class RouteEcoTrip {
  late RouteModeEnum mode;
  late LocationEcoTrip origin;
  late LocationEcoTrip destination;

  RouteEcoTrip({required this.mode, required this.origin, required this.destination});

  factory RouteEcoTrip.fromJson(Map<String, dynamic> json) {
    return RouteEcoTrip(
      mode: retrieveModeFrom(json['mode']),
      origin: LocationEcoTrip.fromJson(json['origin']),
      destination: LocationEcoTrip.fromJson(json['destination']),
    );
  }
}