import 'package:flutter/widgets.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

class MapItem {
  final String marketName;
  final String cityName;
  List<Place>? place;

  MapItem({required this.marketName, required this.cityName, this.place});
}

class MapProvider with ChangeNotifier {
  MapItem _mapItem = MapItem(marketName: '', cityName: '', place: null);

  MapItem get mapItem => _mapItem;

  set setMapItem(MapItem mapItem) => _mapItem = mapItem;

  void setPlaceList(List<Place> list) {
    _mapItem.place = list;
  }

  List<Place> get mapPlaces {
    return [..._mapItem.place!];
  }

  Future<void> searchLocation(name, city) async {
    await Nominatim.searchByName(
      street: name,
      city: city,
      limit: 30,
      addressDetails: true,
      extraTags: true,
      nameDetails: true,
    ).then(
      (value) => {
        _mapItem = MapItem(marketName: name, cityName: city, place: value),
        notifyListeners()
      },
    );
  }
}
