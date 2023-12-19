import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackDriverLocation extends StatefulWidget {
  final double Late;
  final double long;
  final String name;
  final String userName;

  TrackDriverLocation(
      {required this.Late,
      required this.long,
      required this.name,
      required this.userName});

  @override
  State<TrackDriverLocation> createState() => _TrackDriverLocationState();
}

class _TrackDriverLocationState extends State<TrackDriverLocation> {
  late double late;
  late double long;
  late String name;
  late String username;
  GoogleMapController? mapController;
  late Timer timer;
  List<Marker> markers = [];

  Future<void> fetchLocation() async {
    var url = urlStarter + "/driver/driverLocation?driverUserName=" + username;
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        late = data['late'];
        long = data['long'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void initState() {
    long = widget.long;
    late = widget.Late;
    name = widget.name;
    username = widget.userName;
    _addMarker(LatLng(late, long), name);

    initial();
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) async {
      await fetchLocation();
      setState(() {
        _addMarker(LatLng(late, long), name);
        mapController!
            .animateCamera(CameraUpdate.newLatLng(LatLng(late, long)));
      });
    });
  }

  void dispose() {
    super.dispose();
    timer.cancel();
  }

  initial() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('service location not enabled');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission denied');
      }
    }
  }

  _addMarker(LatLng position, String desc) {
    MarkerId markerId = MarkerId(desc);
    Marker marker = Marker(
        markerId: markerId,
        infoWindow: InfoWindow(title: desc),
        position: position);
    markers.add(marker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${name} Location'),
        backgroundColor: primarycolor,
      ),
      body: Container(
          child: GoogleMap(
        markers: markers.toSet(),
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(late, long),
          zoom: 14.0,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
      )),
    );
  }
}
