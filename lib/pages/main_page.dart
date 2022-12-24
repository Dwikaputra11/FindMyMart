import 'package:findmymarket/pages/map_page.dart';
import 'package:findmymarket/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

const _mainColor = Color(0xFF1A4971);

class MainPageState extends State<MainPage> {
  List<Place>? searchPlaces;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appBar(),
        body: _mainBody(),
        drawer: _drawer(),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: _mainColor,
      title: const Text('Find My Mart'),
      titleTextStyle:
          const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      centerTitle: true,
      bottom: const TabBar(
        indicatorColor: Colors.white,
        indicatorWeight: 5,
        tabs: [
          Tab(icon: Icon(Icons.search_rounded)),
          Tab(icon: Icon(Icons.map_sharp)),
        ],
      ),
    );
  }

  Widget _mainBody() {
    return const TabBarView(
      children: [
        SearchLocation(),
        MapPage(),
      ],
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.all(15),
        color: _mainColor,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 35),
            buildMenuItem(
              text: 'Friends',
              icon: Icons.people_alt_rounded,
            ),
            buildMenuItem(
              text: 'Notification',
              icon: Icons.notifications,
            ),
            buildMenuItem(
              text: 'Wishlist',
              icon: Icons.favorite,
            ),
            buildMenuItem(
              text: 'Bookmark',
              icon: Icons.bookmark,
            ),
            buildMenuItem(
              text: 'History',
              icon: Icons.history,
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.white70),
            const SizedBox(height: 24),
            buildMenuItem(
              text: 'Settings',
              icon: Icons.settings,
            ),
            buildMenuItem(
              text: 'Logout',
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    const color = Colors.white;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      hoverColor: Colors.white,
      onTap: onClicked,
    );
  }
}
