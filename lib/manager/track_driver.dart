import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Package4U/Models/DriverTrack.dart';
import 'package:Package4U/manager/TrackDriverLocation.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Track_driver extends StatefulWidget {
  Track_driverState createState() => Track_driverState();
}

class Track_driverState extends State<Track_driver> {
  List<Driver> driverList = [];
  List<Driver> filterd = [];
  TextEditingController _searchController = new TextEditingController();
  late Timer _timer;
  bool online = false;
  Future<void> fetchDrivers() async {
    var url = urlStarter + "/driver/driverListManager";
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        driverList = (data as List)
            .map((driverData) => Driver.fromJson(driverData))
            .toList();
        filterd = driverList;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void search(String query) {
    filterd = driverList.where((element) {
      return element.name
          .toString()
          .toLowerCase()
          .startsWith(query.toLowerCase());
    }).toList();
    setState(() {
      filterd;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDrivers();
    try {
      _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
        setState(() {
          fetchDrivers();
        });
      });
      throw Exception('Some error occurred');
    } catch (e) {}
    //print('////////////////////////////////');
  }

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Drivers"),
        backgroundColor: primarycolor,
      ),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  TextFormField(
                      controller: _searchController,
                      onChanged: search,
                      decoration: theme_helper().text_form_style_search(
                          'Search',
                          'Enter Driver Name',
                          Icons.search,
                          _searchController, () {
                        _searchController.clear();
                        search("");
                      })),
                ],
              ),
            ),
            _listView(filterd)
          ]),
    );
  }

  Widget _listView(List<Driver> filterdDrivers) {
    return Expanded(
      child: ListView.builder(
          itemCount: filterdDrivers.length,
          itemBuilder: (context, index) {
            // isWithinMinutesOfCurrentTime(
            //     DateTime.parse(filterdDrivers[index].date));
            return InkWell(
              borderRadius: BorderRadius.circular(30),
              splashColor: Colors.grey.withOpacity(0.6),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrackDriverLocation(
                            name: filterdDrivers[index].name,
                            userName: filterdDrivers[index].username,
                            Late: filterdDrivers[index].late,
                            long: filterdDrivers[index].long
                            //da
                            )));
              },
              child: ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: primarycolor,
                      backgroundImage: filterdDrivers[index].img == ""
                          ? null
                          : NetworkImage(urlStarter +
                              '/image/' +
                              filterdDrivers[index].img),
                      child: filterdDrivers[index].img == ""
                          ? Text(
                              filterdDrivers[index]
                                  .name[0]
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isWithinMinutesOfCurrentTime(
                                  DateTime.parse(filterdDrivers[index].date))
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(filterdDrivers[index].name),
                subtitle: Text(filterdDrivers[index].username),
              ),
            );
          }),
    );
  }

  bool isWithinMinutesOfCurrentTime(DateTime targetDateTime) {
    targetDateTime = targetDateTime.add(Duration(hours: 2));
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(targetDateTime);
    DateTime dateTime = DateTime.parse(formattedDateTime);
    DateTime currentDateTime = DateTime.now();

    Duration difference = dateTime.difference(currentDateTime);

    return difference.inSeconds.abs() < 60;
  }
}
