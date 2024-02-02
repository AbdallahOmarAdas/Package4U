import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Package4U/drivers/mapModalBottomsheet.dart';
import 'package:Package4U/drivers/workOnPackage.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class OnGoingPackages extends StatefulWidget {
  const OnGoingPackages({super.key});

  @override
  State<OnGoingPackages> createState() => _OnGoingPackagesState();
}

class _OnGoingPackagesState extends State<OnGoingPackages> {
  late List<Content> OnGoingOrders = [];
  late List<Content> filterdOnGoingOrders = [];
  bool isEmptyList = false;
  TabController? myControler;
  List<dynamic> packagesList = [];
  Position? curruentPosition;
  @override
  void initState() {
    super.initState();
    postGetOnGoingPackages();
  }

  Future<Position> onGetCurrentLocationPressed() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    } catch (e) {
      print('Exception while requesting location permission: $e');
    }

    Position p = await Geolocator.getCurrentPosition();

    return p;
  }

  Future<double> calc_distance(double lat, double lang) async {
    double Disstance = await Geolocator.distanceBetween(
            curruentPosition!.latitude,
            curruentPosition!.longitude,
            lat,
            lang) /
        1000;
    return Disstance;
  }

  Future postGetOnGoingPackages() async {
    var url = urlStarter + "/driver/onGoingPackagesDriver";
    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "driverUserName": GetStorage().read('userName'),
          "driverPassword": GetStorage().read('password')
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        isEmptyList = false;
        packagesList = data['result'];
        _buildMy_deliverd_Packages();
      });
    } else if (response.statusCode == 404) {
      setState(() {
        isEmptyList = true;
        packagesList = [];
        _buildMy_deliverd_Packages();
      });
    } else {
      throw Exception('Failed to load data');
    }
    return;
  }

  Future<void> _buildMy_deliverd_Packages() async {
    //Future<void> getlocation_and_distance() async {
    Position curruent = await onGetCurrentLocationPressed();
    setState(() {
      curruentPosition = curruent;
    });
    OnGoingOrders = [];
    for (int i = 0; i < packagesList.length; i++) {
      String delivery_type = packagesList[i]['status'];
      double lat = delivery_type == "With Driver"
          ? packagesList[i]['latTo']
          : packagesList[i]['latFrom'];
      double long = delivery_type == "With Driver"
          ? packagesList[i]['longTo']
          : packagesList[i]['longFrom'];

      double distance = await calc_distance(lat, long);
      String pktType = '';
      switch (packagesList[i]['shippingType']) {
        case 'Package0':
          pktType = 'Small';
          break;
        case 'Package1':
          pktType = 'Medium';
          break;
        case 'Package2':
          pktType = 'Large';
          break;
        case 'Document0':
          pktType = 'Document';
          break;
        default:
          pktType = 'Document';
          break;
      }
      if (delivery_type == "Wait Driver")
        OnGoingOrders.add(
          Content(
            delivery_type: delivery_type,
            img: urlStarter +
                '/image/' +
                packagesList[i]['send_userName'] +
                packagesList[i]['send_user']['url'],
            name: packagesList[i]['send_user']['Fname'] +
                " " +
                packagesList[i]['send_user']['Lname'],
            delivered_price: packagesList[i]['total'],
            whoWillPay: packagesList[i]['whoWillPay'],
            pktdistance: packagesList[i]['distance'],
            package_price: packagesList[i]['packagePrice'].toDouble(),
            distance: distance,
            id: packagesList[i]['packageId'],
            username: packagesList[i]['send_userName'],
            context: this.context,
            packageType: pktType,
            phone: packagesList[i]['send_user']['phoneNumber'].toString(),
            lat: packagesList[i]['latFrom'],
            long: packagesList[i]['longFrom'],
            locationDescription:
                packagesList[i]['locationFromInfo'].toString().split(','),
            driverPosition: curruent,
            refreshData: () {
              postGetOnGoingPackages();
            },
          ),
        );
      else {
        OnGoingOrders.add(
          Content(
            delivery_type: delivery_type,
            img: urlStarter +
                '/image/' +
                packagesList[i]['rec_userName'] +
                packagesList[i]['rec_user']['url'],
            name: packagesList[i]['rec_user']['Fname'] +
                " " +
                packagesList[i]['rec_user']['Lname'],
            delivered_price: packagesList[i]['total'],
            whoWillPay: packagesList[i]['whoWillPay'],
            distance: distance,
            pktdistance: packagesList[i]['distance'],
            id: packagesList[i]['packageId'],
            package_price: packagesList[i]['packagePrice'].toDouble(),
            username: packagesList[i]['rec_userName'],
            context: this.context,
            packageType: pktType,
            phone: packagesList[i]['rec_user']['phoneNumber'].toString(),
            lat: packagesList[i]['latTo'],
            long: packagesList[i]['longTo'],
            locationDescription:
                packagesList[i]['locationToInfo'].toString().split(','),
            driverPosition: curruent,
            refreshData: () {
              postGetOnGoingPackages();
            },
          ),
        );
      }
    }
    OnGoingOrders.sort((a, b) => a.distance.compareTo(b.distance));
    filterdOnGoingOrders = OnGoingOrders;
    return;
  }

  TextEditingController _searchController = TextEditingController();
  String? searchText;
  String? filterBy = "Package Id";
  List<String> FilterBylist = ["Package Id", "Name", "Username", "Size"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My packages for today'),
          backgroundColor: primarycolor,
        ),
        body: Container(
            child: isEmptyList == true
                ? Center(
                    child: Text(
                    "You don't have packages to work on",
                    style: TextStyle(fontSize: 20, color: primarycolor),
                  ))
                : Container(
                    child: OnGoingOrders.length != 0
                        ? Column(
                            children: [
                              filter(OnGoingOrders),
                              Expanded(
                                child: ListView(
                                  children: filterdOnGoingOrders,
                                ),
                              )
                            ],
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  )));
  }

  Container filter(List<Content> order) {
    return Container(
      padding: EdgeInsets.only(top: 10, right: 7, left: 7),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadiusDirectional.vertical(bottom: Radius.circular(20)),
        color: Colors.grey[100],
      ),
      height: 60,
      child: GridView.builder(
        itemCount: 2,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 25,
            mainAxisSpacing: 2,
            childAspectRatio: 3),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
                child: TextFormField(
              controller: _searchController,
              onChanged: (value) {
                List<Content> filterd;
                filterd = order.where((element) {
                  switch (filterBy) {
                    case 'Package Id':
                      return element.id.toString().startsWith(value);
                    case 'Name':
                      return element.name
                          .toString()
                          .toLowerCase()
                          .startsWith(value.toLowerCase());
                    case 'Username':
                      return element.username
                          .toString()
                          .toLowerCase()
                          .startsWith(value.toLowerCase());
                    case 'Size':
                      return element.packageType
                          .toString()
                          .toLowerCase()
                          .startsWith(value.toLowerCase());
                    default:
                      return true;
                  }
                }).toList();
                setState(() {
                  filterdOnGoingOrders = filterd;
                  filterdOnGoingOrders
                      .sort((a, b) => a.distance.compareTo(b.distance));
                });
              },
              decoration: theme_helper().text_form_style_search(
                'Search',
                'Enter ${filterBy}',
                Icons.search,
                _searchController,
                () {
                  _searchController.clear();
                  setState(() {
                    filterdOnGoingOrders = OnGoingOrders;
                    filterdOnGoingOrders
                        .sort((a, b) => a.distance.compareTo(b.distance));
                  });
                },
              ),
            ));
          } else {
            return Container(
              child: DropdownButtonFormField(
                value: filterBy,
                isExpanded: true,
                hint: Text('Filter By'),
                decoration: theme_helper().text_form_style(
                  '',
                  '',
                  Icons.filter_alt,
                ),
                items: FilterBylist.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    filterBy = (value as String?)!;
                  });
                },
              ),
            );
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class Content extends StatefulWidget {
  // final String city_from;
  // final String city_to;
  // final String late_from;
  // final String long_from;
  final int id;
  late String reason;
  final String phone;
  final String whoWillPay;
  final Position driverPosition;
  final String name;
  final String username;
  final String img;
  final double pktdistance;
  final double delivered_price;
  final double package_price;
  final double distance;
  final String delivery_type; // 0 Delivery of a package , 1 Receiving a package
  final BuildContext context;
  final String packageType;
  final Function() refreshData;
  final double lat;
  final double long;
  final List<String> locationDescription;

  Content(
      {super.key,
      required this.id,
      required this.driverPosition,
      required this.distance,
      required this.phone,
      required this.pktdistance,
      required this.whoWillPay,
      this.reason = '',
      required this.locationDescription,
      required this.name,
      required this.username,
      required this.context,
      required this.img,
      required this.package_price,
      required this.delivered_price,
      required this.delivery_type,
      required this.refreshData,
      required this.packageType,
      required this.lat,
      required this.long});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final formGlobalKey = GlobalKey<FormState>();

  Future cancelOnGoingPackageDriver() async {
    print("status: " + widget.delivery_type);
    var url = urlStarter + "/driver/cancelOnGoingPackageDriver";
    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "driverUserName": GetStorage().read('userName'),
          "driverPassword": GetStorage().read('password'),
          "status": widget.delivery_type,
          "packageId": widget.id
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      setState(() {
        widget.refreshData();
      });
    } else {
      throw Exception('Failed to load data');
    }
    return;
  }

  void RefreshPage() {
    widget.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: primarycolor.withOpacity(0.6),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 1), spreadRadius: 2, blurRadius: 5)
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                        imageBuilder: (context, imageProvider) => Container(
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Package ID : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: ' ${widget.id}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                          Text.rich(TextSpan(
                              text: widget.delivery_type == "With Driver"
                                  ? 'Recipient Name : '
                                  : 'Sender Name : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: ' ${widget.name}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                          Text.rich(TextSpan(
                              text: widget.delivery_type == "With Driver"
                                  ? 'Recipient username : '
                                  : 'Sender username : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.username,
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
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
                              text: 'Phone Number: ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${widget.phone}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 3,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(
                            text: 'Package Type: ',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: widget.delivery_type == "With Driver"
                                    ? 'Deliver'
                                    : 'Receive',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              )
                            ])),
                        SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                            text: 'who Will Pay: ',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: widget.whoWillPay,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              )
                            ])),
                        SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                            text: 'Distance: ',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text:
                                    ' ${widget.distance.toStringAsFixed(1)} Km',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              )
                            ])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: primarycolor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.phone),
                            color: Colors.white,
                            onPressed: () async {
                              launch('tel:${widget.phone}');
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: primarycolor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.my_location),
                            color: Colors.white,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              27.0), // Adjust the radius as needed
                                        ),
                                        title: Text("Location Description"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(widget.locationDescription[0]),
                                            Text(widget.locationDescription[1]),
                                            Text(widget.locationDescription[2]),
                                            Text(widget.locationDescription[3]),
                                          ],
                                        ),
                                        titleTextStyle: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                        contentTextStyle: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        backgroundColor: primarycolor,
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              "Ok",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "View in map",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MapModalBottomSheet(
                                                              lat: widget.lat,
                                                              long: widget
                                                                  .long))).then(
                                                  (value) => RefreshPage());
                                            },
                                          ),
                                        ],
                                      ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 3,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        color: primarycolor,
                        child: Text(
                          "Work on it",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapWorkOnPackage(
                                        longFrom_driver:
                                            widget.driverPosition.longitude,
                                        latFrom_driver:
                                            widget.driverPosition.latitude,
                                        phone: widget.phone,
                                        id: widget.id,
                                        pktdistance: widget.pktdistance,
                                        img: widget.img,
                                        longTo: widget.long,
                                        whoWillPay: widget.whoWillPay,
                                        latTo: widget.lat,
                                        packageType: widget.packageType,
                                        name: widget.name,
                                        package_type: widget.delivery_type,
                                        del_price: widget.delivered_price,
                                        price: widget.package_price,
                                      ))).then((value) => widget.refreshData());
                        },
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        color: Colors.red,
                        child: Text(
                          widget.delivery_type == "With Driver"
                              ? 'Not delivered'
                              : 'Not received',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        onPressed: () {
                          showDialog(
                              context: widget.context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        27.0), // Adjust the radius as needed
                                  ),
                                  title: Text("Confirm the operation"),
                                  content: Text(
                                    widget.delivery_type == "With Driver"
                                        ? 'Are you sure you want to return this package to the warehouse?'
                                        : 'Are you sure you want to postpone receiving this package until tomorrow?',
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
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      onPressed: () {
                                        cancelOnGoingPackageDriver();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
