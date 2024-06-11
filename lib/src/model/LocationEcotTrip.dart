class LocationEcoTrip {
  late double lat;
  late double lng;

  LocationEcoTrip({ required this.lat, required this.lng });

  factory LocationEcoTrip.fromJson(Map<String, dynamic> json) {
    return LocationEcoTrip(lat: json['lat'], lng: json['lng']);
  }
}