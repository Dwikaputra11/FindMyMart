import 'package:findmymarket/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

TextEditingController _cityController = TextEditingController();

const _mainColor = Color(0xFF1A4971);
const _secondaryColor = Color(0xFFA9D4F5);

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  List<Place>? searchPlaces;
  String selectedValue = "Indomaret";
  // String cityText = _cityController.text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.center,
            height: 60,
            width: 300,
            child: DropdownButtonFormField(
              hint: const Text('Pilih Market'),
              value: selectedValue,
              items: dropdownItems,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _mainColor, width: 3),
                ),
                filled: true,
                fillColor: _mainColor,
                focusColor: _mainColor,
              ),
              dropdownColor: _mainColor,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              iconEnabledColor: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          _cityField(),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A4971),
            ),
            onPressed: (() {
              searchLocation(selectedValue, _cityController.text);
            }),
            child: const Text("Search"),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: searchPlaces?.length ?? 0,
              itemBuilder: (context, index) => Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: _mainColor,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.white,
                        blurRadius: 3,
                        spreadRadius: 1,
                        offset: Offset(7, 5)),
                  ],
                ),
                child: ListTile(
                  enabled: true,
                  leading: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Lihat',
                      style: TextStyle(
                        color: _mainColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  title: Text(
                    searchPlaces?[index].displayName ?? "",
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ),
              physics: const BouncingScrollPhysics(),
            ),
          ),
          // Text(_cityController.text),
          // Text('text value : $selectedValue'),
        ],
      ),
    );
  }

  Widget _cityField() {
    return Container(
      alignment: Alignment.center,
      height: 60,
      width: 300,
      child: TextField(
        enabled: true,
        controller: _cityController,
        style: const TextStyle(
          color: _mainColor,
        ),
        cursorColor: const Color.fromRGBO(255, 163, 26, 1),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 3,
              color: _mainColor,
            ),
          ),
          focusColor: Colors.white,
          filled: true,
          fillColor: _secondaryColor,
          labelText: 'Kota',
          labelStyle: const TextStyle(
            color: _mainColor,
          ),
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Future<void> searchLocation(String st, String city) async {
    await Nominatim.searchByName(
      street: st,
      city: city,
      addressDetails: true,
      extraTags: true,
      nameDetails: true,
    ).then(
      (value) => setState(
        () => {searchPlaces = value},
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        value: "Indomaret",
        child: Text("Indomaret"),
      ),
      const DropdownMenuItem(
        value: "Alfamart",
        child: Text("Alfamart"),
      ),
      const DropdownMenuItem(
        value: "Circle K",
        child: Text("Circle K"),
      ),
      const DropdownMenuItem(
        value: "Manna Kampus",
        child: Text("Manna Kampus"),
      ),
    ];
    return menuItems;
  }
}
