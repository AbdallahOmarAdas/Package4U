import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

class MapWorkOnPackage extends StatefulWidget {
  final double latTo;
  final double longTo;
  final String package_type;
  final String city_from;
  final String city_to;
  final String name;
  final int id;
  final double price;
  final String img;
  final double del_price;
  final String phone;
  final String packageType;
  final double longFrom_driver;
  final double pktdistance;
  final double latFrom_driver;
  final String whoWillPay;
  final double langfrom;
  final double latefrom;

  MapWorkOnPackage(
      {required this.latTo,
      required this.longTo,
      required this.pktdistance,
      required this.id,
      required this.name,
      required this.package_type,
      required this.whoWillPay,
      required this.price,
      required this.img,
      required this.del_price,
      required this.phone,
      required this.packageType,
      required this.longFrom_driver,
      required this.latFrom_driver,
      required this.city_from,
      required this.city_to,
      required this.langfrom,
      required this.latefrom});

  @override
  State<MapWorkOnPackage> createState() => _MapWorkOnPackageState();
}

class _MapWorkOnPackageState extends State<MapWorkOnPackage> {
  late double Lateto;
  late double langto;
  late String package_type;
  late String name;
  late int id;
  late double price;
  late double del_price;
  late String phone;
  late double langfrom_driver;
  late double latefrom_driver;
  late double langfrom;
  late double latefrom;
  late String city_from;
  late String city_to;

  final formGlobalKey = GlobalKey<FormState>();
  String? reason;
  double openingPrice = 5;
  double totalPrice = 0;
  double boxSizePrice = 0;
  double pricePerKm = 1.5;
  double distancePrice = 0;
  double bigPackagePrice = 8;
  int discount = 0;

  var showPriceDetiles = false;

  void calculatePackageSizeprice() {
    print('///////////////////////////////');
    print(widget.packageType);
    if (widget.packageType.toLowerCase() == "Document".toLowerCase()) {
      boxSizePrice = 0;
    } else if (widget.packageType.toLowerCase() == "Small".toLowerCase()) {
      boxSizePrice = 0;
    } else if (widget.packageType.toLowerCase() == "Medium".toLowerCase()) {
      boxSizePrice = bigPackagePrice / 2;
    } else if (widget.packageType.toLowerCase() == "Large".toLowerCase()) {
      boxSizePrice = bigPackagePrice;
    } else {
      boxSizePrice = bigPackagePrice;
    }

    setState(() {
      boxSizePrice;
    });
  }

  void calaulateTotalPrice() {
    calculatePackageSizeprice();
    distancePrice = (widget.pktdistance * pricePerKm);
    totalPrice = openingPrice + boxSizePrice + distancePrice;
    totalPrice *= (100 - discount) / 100.0;
    setState(() {
      totalPrice;
    });
  }

  Future<void> fetchData() async {
    var url = urlStarter + "/users/costs";
    final response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'ngrok-skip-browser-warning': 'true'
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        openingPrice = data['openingPrice'] + 0.0;
        bigPackagePrice = data['bigPackagePrice'] + 0.0;
        pricePerKm = data['pricePerKm'] + 0.0;
        discount = data['discount'];
      });
      calaulateTotalPrice();
      print(bigPackagePrice);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    fetchData();
    langto = widget.longTo;
    Lateto = widget.latTo;
    package_type = widget.package_type;
    name = widget.name;
    id = widget.id;
    price = widget.price;
    del_price = widget.del_price;
    phone = widget.phone;
    langfrom_driver = widget.longFrom_driver;
    latefrom_driver = widget.latFrom_driver;
    langfrom = widget.langfrom;
    latefrom = widget.latefrom;
    city_from = widget.city_from;
    city_to = widget.city_to;
    super.initState();

    _addMarker(LatLng(latefrom_driver, langfrom_driver), "My Location",
        BitmapDescriptor.defaultMarker);

    if (city_from.toLowerCase() == city_to.toLowerCase()) {
      print('/////////////////////');
      print(Lateto);
      print(langto);
      print(latefrom);
      print(langfrom);

      _addMarker(LatLng(Lateto, langto), "My Target",
          BitmapDescriptor.defaultMarkerWithHue(90));

      _addMarker(
          LatLng(latefrom, langfrom),
          "Deliver the package at this location",
          BitmapDescriptor.defaultMarkerWithHue(70));
    } else {
      _addMarker(LatLng(Lateto, langto), "Destination",
          BitmapDescriptor.defaultMarkerWithHue(90));
    }
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
          "packageId": widget.id,
          "total": widget.del_price,
          "whoWillPay": widget.whoWillPay
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              //height: package_type == "With Driver" ? 330 : 380,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 120,
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
                                Text.rich(TextSpan(
                                    text: "who Will Pay: ",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: widget.whoWillPay,
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
                                        height: 38,
                                        decoration: BoxDecoration(
                                            color: primarycolor,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: TextButton.icon(
                                            label: Text(
                                              'Call ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 19),
                                            ),
                                            icon: Icon(
                                              Icons.phone,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              launch('tel:${phone}');
                                            })),
                                    SizedBox(
                                      width: 17,
                                    ),
                                    Visibility(
                                      visible: ((widget.whoWillPay ==
                                                  "The sender") &&
                                              (package_type ==
                                                  "Wait Driver")) ||
                                          (((widget.whoWillPay ==
                                                  "The recipient") &&
                                              (package_type == "With Driver"))),
                                      child: Container(
                                        height: 38,
                                        decoration: BoxDecoration(
                                            color: primarycolor,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: TextButton.icon(
                                          label: Text(
                                            showPriceDetiles
                                                ? 'Hide  '
                                                : 'Show',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 19),
                                          ),
                                          icon: Icon(
                                            Icons.monetization_on,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showPriceDetiles =
                                                  !showPriceDetiles;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //SizedBox(height: 5),
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
                            'Package Price : ',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            '${price.toStringAsFixed(2)} \$',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: (((widget.whoWillPay == "The sender") &&
                                (package_type == "Wait Driver")) ||
                            (((widget.whoWillPay == "The recipient")) &&
                                (package_type == "With Driver"))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Price : ',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
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
                          ],
                        ),
                      ),
                      Visibility(
                          visible: showPriceDetiles,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '+ Opening price:',
                                      style: priceStyle(),
                                    ),
                                    Text(
                                      openingPrice.toString() + '\$',
                                      style: priceStyle(),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '+ Package size price:',
                                      style: priceStyle(),
                                    ),
                                    Text(
                                      boxSizePrice.toString() + '\$',
                                      style: priceStyle(),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '   Delivery Price/Km:',
                                      style: priceStyle(),
                                    ),
                                    Text(
                                      pricePerKm.toStringAsFixed(2),
                                      style: priceStyle(),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '   Distance:',
                                      style: priceStyle(),
                                    ),
                                    widget.pktdistance > 0
                                        ? Text(
                                            '${widget.pktdistance.toStringAsFixed(2)} km',
                                            style: priceStyle(),
                                          )
                                        : Text('---'),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '+ Distance delivery price:',
                                      style: priceStyle(),
                                    ),
                                    widget.pktdistance > 0
                                        ? Text(
                                            '${distancePrice.toStringAsFixed(2)}\$',
                                            style: priceStyle(),
                                          )
                                        : Text(
                                            '---',
                                            style: priceStyle(),
                                          ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: discount > 0,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '% Discount:',
                                        style: priceStyle(),
                                      ),
                                      Text('${discount}%', style: priceStyle()),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.attach_money_sharp),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Total Price:  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      ((totalPrice + price)
                                              .toStringAsFixed(2)) +
                                          "\$",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      content: Text(confirmMessage()),
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
                                          onPressed: () async {
                                            await postCompleatePackageDriver();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Colors.red,
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
                            visible: package_type.toLowerCase() ==
                                    "Wait Driver".toLowerCase() &&
                                (city_from.toLowerCase() ==
                                    city_to.toLowerCase()),
                            child: Container(
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
                                      ' Keep the package with me to deliver',
                                      style: TextStyle(
                                          fontSize: 18,
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
                                        title: Text("Complete deliver"),
                                        content: Text(confirmMessage() +
                                            " and you have completed the process to deliver the package ID's ${widget.id}?"),
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
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.red,
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
                                                      color: Colors.red,
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

  TextStyle priceStyle() {
    return TextStyle(color: Colors.grey, fontSize: 15);
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

  String confirmMessage() {
    if (((widget.whoWillPay == "The sender") &&
            (package_type == "Wait Driver")) ||
        ((widget.whoWillPay == "The recipient") &&
            (package_type == "With Driver")))
      return "You acknowledge that you received ${(widget.del_price + widget.price).toStringAsFixed(2)} \$ from the customer?";
    else if ((package_type == "Wait Driver"))
      return 'Do you acknowledge that you received the package from the customer?';
    else
      return 'Do you acknowledge that you deliver the package to the customer?';
  }
}
