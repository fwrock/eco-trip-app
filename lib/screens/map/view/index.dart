import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _MapScreen();

}

class _MapScreen extends State<MapScreen> {
  //-23.4872713,-46.608856
  final MapController controller = MapController(
    initPosition: GeoPoint(latitude: -23.4872713, longitude: -46.608856),
  );

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: OSMFlutter(
        osmOption: OSMOption(
          zoomOption: ZoomOption(initZoom: 100.0)
        ),
        controller: controller,
        ),
    );
  }

}