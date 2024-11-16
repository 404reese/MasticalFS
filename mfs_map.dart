// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MFSmap extends StatefulWidget {
  const MFSmap({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<MFSmap> createState() => _MFSmapState();
}

class _MFSmapState extends State<MFSmap> {
  LatLng? currentLocation;
  final List<ll.LatLng> route = [];
  bool clearRoute = false;
  final MapController mapController = MapController();
  Timer? timer

  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are denied');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location services are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location services are denied forever');
    }
    return true;
  }

  void getCurrentLocation() async {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 3 // 3 meter user radius
          ),
    ).listen((Position position) {
      ll.LatLng newPosition = ll.LatLng(position.latitude, position.longitude);
      if (mounted) {
        setState(() => currentLocation = newPosition);
        if (FFAppState().activityStarted) {
          if (clearRoute) {
            setState(() {
              route.clear();
              clearRoute = false;
            });
          }
          setState(() {
            route.add(newPosition);
          });
          _mapController.move(newPosition,13);
        } else {
          if (!clearRoute) {
            setState(() {
              clearRoute = true;
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    //
    super.initState();
    checkPermissions().then((permissionAccepted) {
      if (permissionAccepted) {
        timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
          // Get user position
          getCurrentLocation();
        });
      }
    });
  }

@override
void dispose(){
  //
  super.dispose();
  timer?.cancel();
}



  @override
  Widget build(BuildContext context) {
    return currentLocation == null ? Center(child: CircularProgressIndicator()): FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: currentLocation!,
        initialZoom: 13,
      )
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.titl.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80,
              height: 80,
              point: currentLocation!,
              child: Icon(Icons.circle_rounded, size: 30, color: Colors.blue,),
            )
          ]
        ),
        PolylineLayer(
          polylines: [
            points: route,
            storkeWidth:8,
            color: Colors.red,
          ],
        )
      ]
    );
  }
}
