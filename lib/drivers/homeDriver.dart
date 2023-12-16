import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/Summary.dart';
import 'package:flutter_application_1/drivers/content_page_driver.dart';
import 'package:flutter_application_1/drivers/donePackages.dart';
import 'package:flutter_application_1/drivers/onGoing.dart';
import 'package:flutter_application_1/drivers/preparePackages.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
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
  late Timer _timer;
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
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
    final response = await http.get(Uri.parse(url));
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
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/test.jpg'),
          //     //fit: BoxFit.cover, // You can adjust the BoxFit property as needed
          //   ),
          // ),
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: primarycolor,
                ),
              ),
              Container(
                height: 300,
                // color: Colors.amber,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Summary of today's work",
                      style: TextStyle(
                          fontSize: 35,
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
              // SizedBox(
              //   height: 20,
              // ),
              // content(
              //   label: 'packages',
              //   btn: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: ((context) => content_page_driver())));
              //   },
              //   img: "assets/package-delivered-icon.png",
              // ),
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
                  // fontFamily:
                ),
              ),
              Expanded(
                child:
                    Container(), // This empty container takes up available space
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
