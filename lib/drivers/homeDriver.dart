import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Package4U/Models/Summary.dart';
import 'package:Package4U/drivers/donePackages.dart';
import 'package:Package4U/drivers/onGoing.dart';
import 'package:Package4U/drivers/preparePackages.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeDriver extends StatefulWidget {
  @override
  State<HomeDriver> createState() => _HomeDriverState();
}

class _HomeDriverState extends State<HomeDriver> {
  late String _currentDate;
  late String _currentTime;
  late double late;
  late double long;
  late Timer _timer;
  late Timer _LocationTimer;
  Summary summary = Summary(
      balance: 0, deliverd: 0, notDeliverd: 0, notReceived: 0, received: 0);
  @override
  void initState() {
    super.initState();
    fetchData();
    _updateDateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _updateDateTime();
    });
    _LocationTimer = Timer.periodic(Duration(minutes: 1), (Timer timer) async {
      await _getCurrentLocation();
      PostEditLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      late = position.latitude;
      long = position.longitude;
    });
  }

  Future PostEditLocation() async {
    var url = urlStarter + "/driver/EditLocation";
    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "driverUserName": GetStorage().read('userName'),
          "driverPassword": GetStorage().read('password'),
          "longitude": long,
          "latitude": late,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode != 200) throw Exception('Failed to load data');

    return;
  }

  @override
  void dispose() {
    _timer.cancel();
    _LocationTimer.cancel();
    super.dispose();
  }

  void _updateDateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final formattedTime = DateFormat('HH:mm:ss').format(now);
    setState(() {
      _currentDate = formattedDate;
      _currentTime = formattedTime;
    });
  }

  Future<void> fetchData() async {
    var url = urlStarter +
        "/driver/summary?driverUserName=" +
        GetStorage().read("userName");
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        summary = Summary.fromJson(data);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void RefreshPage() {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                    color: primarycolor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
              ),
              Container(
                height: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Summary of today's work",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          _currentDate,
                          style:
                              TextStyle(fontSize: 25, color: Colors.grey[700]),
                        ),
                        Text(
                          _currentTime,
                          style:
                              TextStyle(fontSize: 25, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    Divider(
                      endIndent: 12,
                      indent: 12,
                      thickness: 3,
                      height: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          "Today Balance",
                          style: TextStyle(
                              fontSize: 25,
                              color: primarycolor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          summary.balance.toStringAsFixed(2),
                          style: TextStyle(fontSize: 25, color: primarycolor),
                        )
                      ],
                    ),
                    Divider(
                      endIndent: 100,
                      indent: 100,
                      thickness: 3,
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Delivered",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.green[800]),
                            ),
                            Text(
                              summary.deliverd.toString(),
                              style: TextStyle(
                                  fontSize: 25, color: Colors.green[400]),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Not Delivered",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.red[800]),
                            ),
                            Text(
                              summary.notDeliverd.toString(),
                              style: TextStyle(
                                  fontSize: 25, color: Colors.red[300]),
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      endIndent: 50,
                      indent: 50,
                      thickness: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Received",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.green[800]),
                            ),
                            Text(
                              summary.received.toString(),
                              style: TextStyle(
                                  fontSize: 25, color: Colors.green[400]),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Not Received",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.red[800]),
                            ),
                            Text(
                              summary.notReceived.toString(),
                              style: TextStyle(
                                  fontSize: 25, color: Colors.red[400]),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                endIndent: 12,
                indent: 12,
                thickness: 3,
                height: 20,
              ),
              content(
                label: 'My packages for today',
                btn: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => OnGoingPackages())))
                      .then((value) => RefreshPage());
                },
                img: "assets/onGoing.png",
              ),
              SizedBox(
                height: 20,
              ),
              content(
                label: 'Prepare today packages',
                btn: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => PreparePackages())))
                      .then((value) => RefreshPage());
                },
                img: "assets/box.png",
              ),
              SizedBox(
                height: 20,
              ),
              content(
                label: 'Completed packages',
                btn: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => DonePackages())))
                      .then((value) => RefreshPage());
                },
                img: "assets/package-delivered-icon.png",
              ),
            ],
          ),
        ));
  }
}

class content extends StatelessWidget {
  final String label;
  final img;
  final Function() btn;

  const content(
      {super.key, required this.label, required this.img, required this.btn});

  @override
  Widget build(BuildContext) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: primarycolor.withOpacity(0.6),
        onTap: btn,
        child: Ink(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 1), spreadRadius: 2, blurRadius: 5)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image(
                  image: AssetImage(img),
                  height: 40,
                  width: 40,
                ),
              ),
              SizedBox(width: 10),
              Text(
                '${label}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Icon(
                Icons.east,
                size: 35,
                color: primarycolor,
              ),
            ],
          ),
        ),
        //),
      ),
    );
  }
}
