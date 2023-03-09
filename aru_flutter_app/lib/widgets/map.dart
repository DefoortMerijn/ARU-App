import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong2.dart';

class HomeMap extends StatefulWidget {
  const HomeMap();

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  MapController mapController = MapController();

  @override
  void initState() {
    // Create test record

    // _getCurrentLocation();
    super.initState();
  }

  // final hexagon = h3.polyfill(coordinates: [GeoCoord( lat: lati, lon: long)], resolution: 5);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Map'),
    );
  }
}
