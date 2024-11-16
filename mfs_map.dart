// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

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

class _MFSmapState extends State<MFSmap> {
  @override
  void initState() {
    //
    super.initState();
    checkPermissions().then((permissionAccepted) {
      if (permissionAccepted) {
        Timer timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
          // Get
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
