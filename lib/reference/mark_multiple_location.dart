import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MarkMultipleLocationScreen extends StatefulWidget {
  const MarkMultipleLocationScreen({super.key});

  @override
  State<MarkMultipleLocationScreen> createState() =>
      _MarkMultipleLocationScreenState();
}

final LatLng london = LatLng(51.5, -0.09);
final LatLng paris = LatLng(48.8566, 2.3522);
final LatLng dublin = LatLng(53.3498, -6.2603);

class _MarkMultipleLocationScreenState
    extends State<MarkMultipleLocationScreen> {
  late MapController _mapController;
  double _rotation = 0;
  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: london,
        builder: (ctx) => Container(
          key: const Key('blue'),
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
          ),
        ),
      ),
      Marker(
        width: 80,
        height: 80,
        point: dublin,
        builder: (ctx) => Container(
          key: const Key('green'),
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
          ),
        ),
      ),
      Marker(
        width: 80,
        height: 80,
        point: paris,
        builder: (ctx) => Container(
          key: const Key('purple'),
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
          ),
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Location"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      _mapController.move(london, 18);
                    },
                    child: const Text('London'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _mapController.move(paris, 5);
                    },
                    child: const Text('Paris'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _mapController.move(dublin, 5);
                    },
                    child: const Text('Dublin'),
                  ),
                  CurrentLocationMarker(mapController: _mapController),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      final bounds = LatLngBounds();
                      bounds.extend(dublin);
                      bounds.extend(paris);
                      bounds.extend(london);
                      _mapController.fitBounds(
                        bounds,
                        options: const FitBoundsOptions(
                          padding: EdgeInsets.only(left: 15, right: 15),
                        ),
                      );
                    },
                    child: const Text('Fit Bounds'),
                  ),
                  Builder(builder: (BuildContext context) {
                    return MaterialButton(
                      onPressed: () {
                        final bounds = _mapController.bounds!;

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Map bounds: \n'
                            'E: ${bounds.east} \n'
                            'N: ${bounds.north} \n'
                            'W: ${bounds.west} \n'
                            'S: ${bounds.south}',
                          ),
                        ));
                      },
                      child: const Text('Get Bounds'),
                    );
                  }),
                  const Text('Rotation:'),
                  Expanded(
                    child: Slider(
                      value: _rotation,
                      min: 0,
                      max: 360,
                      onChanged: (degree) {
                        setState(() {
                          _rotation = degree;
                        });
                        _mapController.rotate(degree);
                      },
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 5,
                  maxZoom: 5,
                  minZoom: 3,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentLocationMarker extends StatefulWidget {
  const CurrentLocationMarker({super.key, required this.mapController});

  final MapController mapController;

  @override
  State<CurrentLocationMarker> createState() => _CurrentLocationMarkerState();
}

class _CurrentLocationMarkerState extends State<CurrentLocationMarker> {
  int _eventKey = 0;

  IconData icon = Icons.gps_not_fixed;
  late final StreamSubscription<MapEvent> mapEventSubscription;

  @override
  void initState() {
    super.initState();
    mapEventSubscription =
        widget.mapController.mapEventStream.listen(onMapEvent);
  }

  @override
  void dispose() {
    mapEventSubscription.cancel();
    super.dispose();
  }

  void setIcon(IconData newIcon) {
    if (newIcon != icon && mounted) {
      setState(() {
        icon = newIcon;
      });
    }
  }

  void onMapEvent(MapEvent mapEvent) {
    if (mapEvent is MapEventMove && mapEvent.id != _eventKey.toString()) {
      setIcon(Icons.gps_not_fixed);
    }
  }

  void _moveToCurrent() async {
    _eventKey++;
    final location = Location();

    try {
      final currentLocation = await location.getLocation();
      final moved = widget.mapController.move(
        LatLng(currentLocation.latitude!, currentLocation.longitude!),
        18,
        id: _eventKey.toString(),
      );

      setIcon(moved ? Icons.gps_fixed : Icons.gps_not_fixed);
    } catch (e) {
      setIcon(Icons.gps_off);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: _moveToCurrent,
    );
  }
}
