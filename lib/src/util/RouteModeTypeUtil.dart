import 'package:ecoway/src/enumeration/RouteModeEnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

RoadType retrieveTypeFrom(RouteModeEnum mode) {
  if (mode == RouteModeEnum.CAR) {
    return RoadType.car;
  } else if (mode == RouteModeEnum.BIKE) {
    return RoadType.bike;
  } else if (mode == RouteModeEnum.FOOT) {
    return RoadType.foot;
  } else {
    return RoadType.foot;
  }
}

Color retrieveColorFrom(RouteModeEnum mode) {
  if (mode == RouteModeEnum.CAR) {
    return Colors.blue;
  } else if (mode == RouteModeEnum.BIKE) {
    return Colors.deepPurple;
  } else if (mode == RouteModeEnum.FOOT) {
    return Colors.green;
  } else {
    return Colors.red;
  }
}

Color retrieveColorFromNumber(int number) {
  if (number == 0) {
    return Colors.blue;
  } else if (number == 1) {
    return Colors.deepPurple;
  } else if (number == 2) {
    return Colors.green;
  } else {
    return Colors.red;
  }
}

IconData retrieveIconFrom(RouteModeEnum mode) {
  if (mode == RouteModeEnum.CAR) {
    return Icons.card_travel;
  } else if (mode == RouteModeEnum.BIKE) {
    return Icons.directions_bike;
  } else if (mode == RouteModeEnum.FOOT) {
    return Icons.run_circle_outlined;
  } else {
    return Icons.run_circle_outlined;
  }
}

RouteModeEnum retrieveModeFrom(String mode) {
  if (mode == "CAR") {
    return RouteModeEnum.CAR;
  } else if (mode == "BIKE") {
    return RouteModeEnum.BIKE;
  } else if (mode == "FOOT") {
    return RouteModeEnum.FOOT;
  } else {
    return RouteModeEnum.FOOT;
  }
}

