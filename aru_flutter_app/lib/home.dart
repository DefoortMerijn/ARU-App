import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:h3_flutter/h3_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_android/geolocator_android.dart';

import './widgets/map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> data = {};
  BigInt h3Location = BigInt.from(0);
  String h3Index = '';
  final h3 = const H3Factory().load();
  late LocationSettings locationSettings;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  double lat = 0;
  double lon = 0;

  @override
  void initState() {
    fetchDataH3();
    // Create test record
    checkGps();
    Timer timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      _getCurrentLocation();
      _checkH3();
      print(DateTime.now());
    });
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        _getCurrentLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
  }

  Future<void> _getCurrentLocation() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    lat = position.latitude;
    lon = position.longitude;

    print("lat: $lat, lon: $lon");
    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
          forceLocationManager: true,
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (Platform.isIOS || Platform.isMacOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType: ActivityType.fitness,
        distanceFilter: 1,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1,
      );
    }
    // StreamSubscription<Position> positionStream =
    //     Geolocator.getPositionStream(locationSettings: locationSettings)
    //         .listen((Position? position) {
    //   if (position != null) {
    //     print(position.latitude);
    //     print(position.longitude);
    //   }
    // });
  }

  Future<void> _checkH3() async {
    h3Location = h3.geoToH3(GeoCoord(lon: lon, lat: lat), 11);
    h3Index = h3Location.toRadixString(16);
    print(h3Index);
    if (data.containsValue(h3Index)) {
      print('found');
    } else {
      print('not found');
    }
  }

  void fetchDataH3() async {
    print('fetching data');
    final url = Uri.parse(
        'https://cits-staging.be-mobile.io/traffic-light-events/beta/v1/intersections/zone');
    final headers = {
      'be-mobile-api-key': '2M8rPOm0xHkujHMxxK9Mrrl8oa7',
      'Accept': 'application/h3',
    };
    final response = await http.get(url, headers: headers);
    print('response: ${response.statusCode}');
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      data.forEach((key, value) {
        if (value == h3Index) {
          print('found');
        } else {
          print('not found');
        }
      });

      // process the data here
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.9, child: HomeMap()),
        Container(
            height: MediaQuery.of(context).size.height * 0.1,
            color: Colors.red,
            child: const Text('data')),
      ],
    );
  }
}
