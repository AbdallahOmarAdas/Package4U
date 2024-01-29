import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class service extends StatefulWidget {
  @override
  State<service> createState() => _serviceState();
}

class _serviceState extends State<service> {
  GoogleMapController? _controller;

  List<Marker> markers = [
    // Marker(
    //     markerId: MarkerId("tulkarm"), position: LatLng(32.319199, 35.064320)),
    Marker(
        markerId: MarkerId("Company Headquarters"),
        position: LatLng(32.222668, 35.262146)),
    // Marker(markerId: MarkerId("jenin"), position: LatLng(32.464634, 35.293858))
  ];
  CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(32.222668, 35.262146), zoom: 9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: 1000,
          child: GoogleMap(
            markers: markers.toSet(),
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (controller) {
              _controller = controller;
            },
          )),
    );
  }
}
