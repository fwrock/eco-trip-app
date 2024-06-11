import 'package:ecoway/src/enumeration/RouteModeEnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:ecoway/src/client/RouteClient.dart';
import 'package:ecoway/src/model/RouteTrip.dart';
import 'package:ecoway/src/model/LocationEcotTrip.dart';
import 'package:ecoway/src/util/RouteModeTypeUtil.dart';
import 'package:ecoway/src/enumeration/RouteModeEnum.dart';
import 'package:ecoway/src/pages/MyTransportPage.dart';
import 'package:ecoway/src/pages/EcoRankPage.dart';
import 'package:ecoway/src/pages/PartnersPage.dart';
import 'package:ecoway/src/pages/RewardsPage.dart';
import 'package:ecoway/src/pages/SettingsPage.dart';


class MainPageExample extends StatelessWidget {
  const MainPageExample({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Main(),
      drawer: PointerInterceptor(
        child: DrawerMain(),
      ),
    );
  }
}

class Main extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<Main> with OSMMixinObserver {
  late MapController controller;
  ValueNotifier<bool> trackingNotifier = ValueNotifier(false);
  ValueNotifier<bool> showFab = ValueNotifier(false);
  ValueNotifier<bool> disableMapControlUserTracking = ValueNotifier(true);
  ValueNotifier<IconData> userLocationIcon = ValueNotifier(Icons.near_me);
  ValueNotifier<GeoPoint?> lastGeoPoint = ValueNotifier(null);
  ValueNotifier<GeoPoint?> userLocationNotifier = ValueNotifier(null);
  final mapKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initPosition: GeoPoint(
        latitude: -23.4872713,
        longitude: -46.608856,
      ),
      useExternalTracking: disableMapControlUserTracking.value,
    );
    controller.addObserver(this);
    trackingNotifier.addListener(() async {
      if (userLocationNotifier.value != null && !trackingNotifier.value) {
        await controller.removeMarker(userLocationNotifier.value!);
        userLocationNotifier.value = null;
      }
    });
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      showFab.value = true;
    }
  }

  @override
  void onSingleTap(GeoPoint position) {
    super.onSingleTap(position);
    Future.microtask(() async {
      if (lastGeoPoint.value != null) {
        await controller.changeLocationMarker(
          oldLocation: lastGeoPoint.value!,
          newLocation: position,
        );
      } else {
        await controller.addMarker(
          position,
          markerIcon: MarkerIcon(
            icon: Icon(
              Icons.person_pin,
              color: Colors.red,
              size: 32,
            ),
          ),
        );
      }
      await controller.moveTo(position, animate: true);
      lastGeoPoint.value = position;
    });
  }

  @override
  void onRegionChanged(Region region) {
    super.onRegionChanged(region);
    if (trackingNotifier.value) {
      final userLocation = userLocationNotifier.value;
      if (userLocation == null ||
          !region.center.isEqual(
            userLocation,
            precision: 1e4,
          )) {
        userLocationIcon.value = Icons.gps_not_fixed;
      } else {
        userLocationIcon.value = Icons.gps_fixed;
      }
    }
  }

  @override
  void onLocationChanged(UserLocation userLocation) async {
    super.onLocationChanged(userLocation);
    if (disableMapControlUserTracking.value && trackingNotifier.value) {
      await controller.moveTo(userLocation);
      if (userLocationNotifier.value == null) {
        await controller.addMarker(
          userLocation,
          markerIcon: MarkerIcon(
            icon: Icon(Icons.navigation),
          ),
          angle: userLocation.angle,
        );
      } else {
        await controller.changeLocationMarker(
          oldLocation: userLocationNotifier.value!,
          newLocation: userLocation,
          angle: userLocation.angle,
        );
      }
      userLocationNotifier.value = userLocation;
    } else {
      if (userLocationNotifier.value != null && !trackingNotifier.value) {
        await controller.removeMarker(userLocationNotifier.value!);
        userLocationNotifier.value = null;
      }
    }
  }

  @override
  void onRoadTap(RoadInfo road) {
    super.onRoadTap(road);
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.maybeOf(context)?.viewPadding.top;
    return Stack(
      children: [
        Map(
          controller: controller,
        ),
        if (!kReleaseMode || kIsWeb) ...[
          Positioned(
            bottom: 23.0,
            left: 15,
            child: ZoomNavigation(
              controller: controller,
            ),
          )
        ],
        Positioned.fill(
          child: ValueListenableBuilder(
            valueListenable: showFab,
            builder: (context, isVisible, child) {
              if (!isVisible) {
                return SizedBox.shrink();
              }
              return Stack(
                children: [
                  if (!kIsWeb) ...[
                    Positioned(
                      top: (topPadding ?? 26) + 48,
                      right: 15,
                      child: MapRotation(
                        controller: controller,
                      ),
                    )
                  ],
                  Positioned(
                    top: kIsWeb ? 26 : topPadding ?? 26.0,
                    left: 12,
                    child: PointerInterceptor(
                      child: MainNavigation(),
                    ),
                  ),
                  Positioned(
                    bottom: 32,
                    right: 15,
                    child: ActivationUserLocation(
                      controller: controller,
                      trackingNotifier: trackingNotifier,
                      userLocation: userLocationNotifier,
                      userLocationIcon: userLocationIcon,
                    ),
                  ),
                  Positioned(
                    bottom: 92,
                    right: 15,
                    child: DirectionRouteLocation(
                      controller: controller,
                    ),
                  ),
                  Positioned(
                    top: kIsWeb ? 26 : topPadding,
                    left: 64,
                    right: 72,
                    child: SearchFields(
                      controller: controller,
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}

class Map extends StatelessWidget {
  const Map({
    super.key,
    required this.controller,
  });
  final MapController controller;
  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: controller,
      mapIsLoading: Center(
        child: CircularProgressIndicator(),
      ),
      onLocationChanged: (location) {
        debugPrint(location.toString());
      },
      osmOption: OSMOption(
        enableRotationByGesture: true,
        zoomOption: ZoomOption(
          initZoom: 16,
          minZoomLevel: 3,
          maxZoomLevel: 19,
          stepZoom: 1.0,
        ),
        userLocationMarker: UserLocationMaker(
            personMarker: MarkerIcon(
              // icon: Icon(
              //   Icons.car_crash_sharp,
              //   color: Colors.red,
              //   size: 48,
              // ),
              // iconWidget: SizedBox.square(
              //   dimension: 56,
              //   child: Image.asset(
              //     "asset/taxi.png",
              //     scale: .3,
              //   ),
              // ),
              iconWidget: SizedBox(
                width: 32,
                height: 64,
                child: Image.asset(
                  "asset/directionIcon.png",
                  scale: .3,
                ),
              ),
              // assetMarker: AssetMarker(
              //   image: AssetImage(
              //     "asset/taxi.png",
              //   ),
              //   scaleAssetImage: 0.3,
              // ),
            ),
            directionArrowMarker: MarkerIcon(
              icon: Icon(
                Icons.navigation_rounded,
                size: 48,
              ),
              // iconWidget: SizedBox(
              //   width: 32,
              //   height: 64,
              //   child: Image.asset(
              //     "asset/directionIcon.png",
              //     scale: .3,
              //   ),
              // ),
            )
            // directionArrowMarker: MarkerIcon(
            //   assetMarker: AssetMarker(
            //     image: AssetImage(
            //       "asset/taxi.png",
            //     ),
            //     scaleAssetImage: 0.25,
            //   ),
            // ),
            ),
        staticPoints: [
          StaticPositionGeoPoint(
            "line 1",
            MarkerIcon(
              icon: Icon(
                Icons.train,
                color: Colors.green,
                size: 32,
              ),
            ),
            [
              GeoPoint(
                latitude: 47.4333594,
                longitude: 8.4680184,
              ),
              GeoPoint(
                latitude: 47.4317782,
                longitude: 8.4716146,
              ),
            ],
          ),
          /*
           StaticPositionGeoPoint(
                      "line 2",
                      MarkerIcon(
                        icon: Icon(
                          Icons.train,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                      [
                        GeoPoint(latitude: 47.4433594, longitude: 8.4680184),
                        GeoPoint(latitude: 47.4517782, longitude: 8.4716146),
                      ],
            )
          */
        ],
        roadConfiguration: RoadOption(
          roadColor: Colors.blueAccent,
        ),
        showContributorBadgeForOSM: true,
        //trackMyPosition: trackingNotifier.value,
        showDefaultInfoWindow: false,
      ),
    );
  }
}

class SearchFields extends StatefulWidget {
  final MapController controller;

  const SearchFields({
    super.key,
    required this.controller,
  });
  @override
  State<StatefulWidget> createState() => _SearchFieldsState();
}

class _SearchFieldsState extends State<SearchFields> {
  final originController = TextEditingController();
  final destinationController = TextEditingController();

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  void searchRoute() async {
    String originText = originController.text;
    String destinationText = destinationController.text;

    if (originText.isNotEmpty && destinationText.isNotEmpty) {
      List<Location> originLocations = await locationFromAddress(originText);
      List<Location> destinationLocations =
          await locationFromAddress(destinationText);

      print(originLocations);
      print(destinationLocations);

      if (originLocations.isNotEmpty && destinationLocations.isNotEmpty) {
        GeoPoint originGeoPoint = GeoPoint(
          latitude: originLocations.first.latitude,
          longitude: originLocations.first.longitude,
        );
        GeoPoint destinationGeoPoint = GeoPoint(
          latitude: destinationLocations.first.latitude,
          longitude: destinationLocations.first.longitude,
        );

        List<List<RouteEcoTrip>> trips = await createTrip(
          RouteModeEnum.CAR,
          LocationEcoTrip(
            lat: originGeoPoint.latitude,
            lng: originGeoPoint.longitude
          ),
          LocationEcoTrip(
            lat: destinationGeoPoint.latitude,
            lng: destinationGeoPoint.longitude
          )
        );

        await widget.controller.addMarker(
          originGeoPoint,
          markerIcon: MarkerIcon(
            icon: Icon(
              Icons.people,
              color: Colors.green,
              size: 32,
            ),
          ),
        );
        int number = 0;
        trips.forEach((routes) async {
          routes.forEach((route) async { 
            GeoPoint routeOrigin = GeoPoint(latitude: route.origin.lat, longitude: route.origin.lng);
            GeoPoint routeDestination = GeoPoint(latitude: route.destination.lat, longitude: route.destination.lng);
            RoadInfo roadInfo = await widget.controller.drawRoad(
              routeOrigin,
              routeDestination,
              roadType: retrieveTypeFrom(route.mode),
              roadOption: RoadOption(
                  roadWidth: 20,
                  roadColor: retrieveColorFromNumber(number),
                  zoomInto: true,
              ),
            );
            await widget.controller.addMarker(
            routeOrigin,
            markerIcon: MarkerIcon(
              icon: Icon(
                retrieveIconFrom(route.mode),
                color: retrieveColorFromNumber(number),
                size: 20,
              ),
            ),
          );
            print("Distance: ${roadInfo.distance}");
            print("Duration: ${roadInfo.duration}");
            print("Intructions: ${roadInfo.instructions}");
          });
          number++;
        });

        await widget.controller.addMarker(
          destinationGeoPoint,
          markerIcon: MarkerIcon(
            icon: Icon(
              Icons.pin_drop,
              color: Colors.red,
              size: 32,
            ),
          ),
        );

        await widget.controller.drawRoad(
          originGeoPoint,
          destinationGeoPoint,
          roadType: RoadType.car,
          roadOption: RoadOption(
            roadWidth: 10,
            roadColor: Colors.grey,
            zoomInto: true,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: Card(
            color: Colors.white,
            elevation: 2,
            shape: StadiumBorder(),
            child: TextField(
              controller: originController,
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                filled: false,
                isDense: true,
                hintText: "Local de origem",
                prefixIcon: Icon(
                  Icons.location_on,
                  size: 22,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 48,
          child: Card(
            color: Colors.white,
            elevation: 2,
            shape: StadiumBorder(),
            child: TextField(
              controller: destinationController,
              onSubmitted: (value) => searchRoute(),
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                filled: false,
                isDense: true,
                hintText: "Local de destino",
                prefixIcon: Icon(
                  Icons.location_on,
                  size: 22,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DrawerMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'EcoTrip',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Mapa'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPageExample()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.pedal_bike),
            title: Text('Meus meios de transporte'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyTransportPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.energy_savings_leaf),
            title: Text('Eco Rank'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EcoRankPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Parceiros'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PartnersPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Prêmios e cupons de desconto'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RewardsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ZoomNavigation extends StatelessWidget {
  final MapController controller;

  const ZoomNavigation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          child: Icon(Icons.zoom_in),
          onPressed: () async {
            await controller.zoomIn();
          },
        ),
        SizedBox(height: 8),
        FloatingActionButton(
          child: Icon(Icons.zoom_out),
          onPressed: () async {
            await controller.zoomOut();
          },
        ),
      ],
    );
  }
}

class MapRotation extends StatelessWidget {
  final MapController controller;

  const MapRotation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.rotate_left),
      onPressed: () async {
        //await controller.rotateMap(90);
      },
    );
  }
}

class MainNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}

class ActivationUserLocation extends StatelessWidget {
  final MapController controller;
  final ValueNotifier<bool> trackingNotifier;
  final ValueNotifier<GeoPoint?> userLocation;
  final ValueNotifier<IconData> userLocationIcon;

  const ActivationUserLocation({
    required this.controller,
    required this.trackingNotifier,
    required this.userLocation,
    required this.userLocationIcon,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: ValueListenableBuilder<IconData>(
        valueListenable: userLocationIcon,
        builder: (context, icon, child) {
          return Icon(icon);
        },
      ),
      onPressed: () async {
        trackingNotifier.value = !trackingNotifier.value;
        if (trackingNotifier.value) {
          final userLocationValue = userLocation.value;
          if (userLocationValue != null) {
            await controller.moveTo(userLocationValue);
          }
        }
      },
    );
  }
}

class DirectionRouteLocation extends StatelessWidget {
  final MapController controller;

  const DirectionRouteLocation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.directions),
      onPressed: () {
        // Implement route calculation
      },
    );
  }
}

