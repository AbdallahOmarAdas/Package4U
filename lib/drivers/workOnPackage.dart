import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/drivers/homeDriver.dart';
import 'package:flutter_application_1/drivers/onGoing.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

class MapWorkOnPackage extends StatefulWidget {
  @override
  final double latTo;
  final double longTo;
  final String package_type;
  final String name;
  final int id;
  final int price;
  final String img;
  final double del_price;
  final String phone;
  final String packageType;
  final double longFrom;
  final double latFrom;

  MapWorkOnPackage(
      {required this.latTo,
      required this.longTo,
      required this.id,
      required this.name,
      required this.package_type,
      required this.price,
      required this.img,
      required this.del_price,
      required this.phone,
      required this.packageType,
      required this.longFrom,
      required this.latFrom});

  State<MapWorkOnPackage> createState() => _MapWorkOnPackageState();
}

class _MapWorkOnPackageState extends State<MapWorkOnPackage> {
  late double Lateto;
  late double langto;
  late String package_type;
  late String name;
  late int id;
  late int price;
  late double del_price;
  late String phone;
  late double langfrom;
  late double latefrom;

  final formGlobalKey = GlobalKey<FormState>();
  String? reason;

  @override
  void initState() {
    langto = widget.longTo;
    Lateto = widget.latTo;
    package_type = widget.package_type;
    name = widget.name;
    id = widget.id;
    price = widget.price;
    del_price = widget.del_price;
    phone = widget.phone;
    langfrom = widget.longFrom;
    latefrom = widget.latFrom;
    super.initState();

    _addMarker(
        LatLng(latefrom, langfrom), "origin", BitmapDescriptor.defaultMarker);
    // destination marker
    _addMarker(LatLng(Lateto, langto), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));

    //_getPolyline();
  }

  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyB9ipQehNyA6U_SXPLcwTq0x201dcJxKoQ";

  Future postCompleatePackageDriver() async {
    var url = urlStarter + "/driver/compleatePackageDriver";
    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "driverUserName": GetStorage().read('userName'),
          "driverPassword": GetStorage().read('password'),
          "status": widget.package_type,
          "packageId": widget.id
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      print("compleated");
    } else {
      throw Exception('Failed to load data');
    }
    return;
  }

  Future RejectWorkOnPackageDriver() async {
    var url = urlStarter + "/driver/RejectWorkOnPackageDriver";
    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "driverUserName": GetStorage().read('userName'),
          "driverPassword": GetStorage().read('password'),
          "packageId": widget.id,
          "comment": reason
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      print("done12");
    } else {
      throw Exception('Failed to load data');
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text('Package Address'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(Lateto, langto),
              zoom: 12.0,
            ),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            //polylines: Set<Polyline>.of(polylines.values),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: Container(
              height: package_type == "With Driver" ? 330 : 360,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              height: 100,
                              width: 100,
                              child: CachedNetworkImage(
                                imageUrl: widget.img,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/default.jpg'),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(TextSpan(
                                    text: 'Package Type : ',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: package_type == "With Driver"
                                            ? 'Package Delivery '
                                            : 'Package Receive ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ])),
                                SizedBox(height: 5),
                                Text.rich(TextSpan(
                                    text: 'Package ID : ',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: ' ${id}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ])),
                                SizedBox(height: 5),
                                Text.rich(TextSpan(
                                    text: package_type == "With Driver"
                                        ? 'Recipient Name : '
                                        : 'Sender Name : ',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: ' ${name}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ])),
                                SizedBox(height: 5),
                                Text.rich(TextSpan(
                                    text: "Package Size: ",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: widget.packageType,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ])),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                        color: primarycolor,
                                        child: Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          launch('tel:${phone}');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Price : ',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            '${del_price.toStringAsFixed(2)} \$',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Container(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)),
                              color: primarycolor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.directions,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    " Start Navigation on Google Maps",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                _openGoogleMaps(Lateto, langto);
                              },
                            ),
                          ),
                          Container(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)),
                              color: primarycolor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.done_all_rounded,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    package_type == "With Driver"
                                        ? ' Complete deliver the package'
                                        : ' Complete receive the package',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            27.0), // Adjust the radius as needed
                                      ),
                                      title: Text("Confirm the operation"),
                                      content: Text(
                                        widget.package_type == "With Driver"
                                            ? 'You acknowledge that you received ${widget.del_price.toStringAsFixed(2)} \$ from the customer?'
                                            : 'Do you acknowledge that you received the package from the customer?',
                                      ),
                                      titleTextStyle: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                      contentTextStyle: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      backgroundColor: primarycolor,
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          onPressed: () {
                                            postCompleatePackageDriver();
                                            Navigator.of(context).pop();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeDriver(),
                                                ));
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Visibility(
                            visible: package_type != "With Driver",
                            child: Container(
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                                color: Colors.red,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Reject receive the package",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  if (formGlobalKey
                                                      .currentState!
                                                      .validate()) {
                                                    formGlobalKey.currentState!
                                                        .save();

                                                    print(reason);
                                                    await RejectWorkOnPackageDriver();
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: Text(
                                                  "Reject Package",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )),
                                          ],
                                          title: Text("Reject Package"),
                                          content: Form(
                                            key: formGlobalKey,
                                            child: TextFormField(
                                              onSaved: (newValue) {
                                                reason = newValue!;
                                              },
                                              maxLines: 5,
                                              validator: (val) {
                                                if (val!.isEmpty)
                                                  return "Please Enter Reason";
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                          color: Colors.grey)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade400)),
                                                  errorBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                          color: Colors.red,
                                                          width: 2)),
                                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.red, width: 2)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  hintText: 'Enter the Reason'),
                                            ),
                                          ),
                                          titleTextStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                          contentTextStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                          backgroundColor: primarycolor,
                                        );
                                      });
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) async {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        infoWindow: InfoWindow(title: id),
        icon: descriptor,
        position: position);
    markers[markerId] = marker;
  }

  void _openGoogleMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      // Launch the URL
      await launch(url);
    } else {
      // Handle the case where the URL can't be launched
      throw 'Could not launch $url';
    }
  }
}
