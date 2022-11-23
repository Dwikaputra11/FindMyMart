import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  List<Place>? searchPlaces;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Location"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: searchLocation,
            child: const Text("Search"),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: searchPlaces?.length ?? 0,
              itemBuilder: (context, index) =>
                  Text(searchPlaces?[index].displayName ?? ""),
            ),
          )
        ],
      ),
    );
  }

  Future<void> searchLocation() async {
    await Nominatim.searchByName(
      street: 'indomaret',
      city: 'yogyakarta',
      addressDetails: true,
      extraTags: true,
      nameDetails: true,
    ).then(
      (value) => setState(
        () => {searchPlaces = value},
      ),
    );
  }
}
