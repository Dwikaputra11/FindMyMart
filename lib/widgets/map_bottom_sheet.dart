import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

class MapBottomSheet extends StatelessWidget {
  final Place place;

  const MapBottomSheet({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final address = place.displayName
        .substring(place.displayName.indexOf(",") + 1, place.displayName.length)
        .trim();
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 200,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              place.address?["shop"] ?? "Null",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              address,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
