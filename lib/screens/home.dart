import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      Marker(point: LatLng(51.5, -0.09), builder: (ctx) => const FlutterLogo(),),
    ];
    return FlutterMap(
      options: MapOptions(
          center: LatLng(51.509364, -0.128928),
          zoom: 9.2,
      ),
      nonRotatedChildren: [
          AttributionWidget.defaultWidget(
              source: 'OpenStreetMap contributors',
              onSourceTapped: null
          ),
      ],
      children: [
          TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.findmymarket',
          ),
      ],
    );
  }
}