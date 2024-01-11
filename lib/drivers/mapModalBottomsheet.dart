import 'package:flutter/material.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapModalBottomSheet extends StatefulWidget {
  final double lat;
  final double long;
  MapModalBottomSheet({required this.lat, required this.long});
  @override
  State<MapModalBottomSheet> createState() => _MapModalBottomSheetState();
  // _MapModalBottomSheetState createState() => _MapModalBottomSheetState();
}

class _MapModalBottomSheetState extends State<MapModalBottomSheet> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text('Package Address'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(32.222668, 35.262146),
          zoom: 10.0,
        ),
        markers: <Marker>[
          Marker(
            markerId: MarkerId('Your Marker ID'),
            position: LatLng(widget.lat, widget.long),
            infoWindow: InfoWindow(
              title: 'Address',
              snippet: 'Your Marker Snippet',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(50),
          ),
        ].toSet(),
      ),
    );
  }
}
