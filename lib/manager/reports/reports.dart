import 'package:Package4U/manager/reports/report_d.dart';
import 'package:Package4U/manager/reports/report_m.dart';
import 'package:Package4U/manager/reports/report_y.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class reports extends StatefulWidget {
  @override
  State<reports> createState() => _reportsState();
}

class _reportsState extends State<reports> {
  void initState() {
    fetchData_today();
    super.initState();
  }

  late double r_moeny = 0;
  late int d_package = 0;
  late int r_package = 0;
  late int w_drivers = 0;
  late String comment = '';

  bool is_load = false;

  late double r_moeny_interval = 0;
  late String d_package_interval = '';
  late String r_package_interval = '';
  late String w_drivers_interval = '';

  String from = '';
  String to = '';

  List<dynamic> serverdata_ = [];

  List<contentreport_d> daily = [];
  List<contentreport_m> monthly = [];
  List<contentreport_y> yearly = [];

  Future<void> fetchData_today() async {
    var url = urlStarter + "/manager/todayWork";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        r_moeny = data['todayReports']['totalBalance'].toDouble();
        d_package = data['todayReports']['packageDeliveredNum'];
        r_package = data['todayReports']['packageReceivedNumber'];
        w_drivers = data['todayReports']['DriversWorkingToday'];
        comment = data['todayReports']['comment'];
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

//daily
/////////////////////////////
  Future<void> fetchData_daily() async {
    var url = urlStarter + "/manager/thisMonthDaysWork";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      serverdata_ = data;
      setState(() {
        daily = buildMy_daily();
        serverdata_ = [];
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<contentreport_d> buildMy_daily() {
    List<contentreport_d> d_report = [];
    for (int i = 0; i < serverdata_.length; i++) {
      d_report.add(contentreport_d(
        date: serverdata_[i]['date'],
        r_moeny: serverdata_[i]['totalBalance'].toDouble(),
        d_package: serverdata_[i]['packageDeliveredNum'],
        comment: serverdata_[i]['comment'],
        w_drivers: serverdata_[i]['DriversWorkingToday'],
        r_package: serverdata_[i]['packageReceivedNumber'],
      ));
    }

    return d_report;
  }
//////////////////////////

//monthly
////////////////////////
  Future<void> fetchData_monthly() async {
    var url = urlStarter + "/manager/monthlySummary";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      serverdata_ = data;
      setState(() {
        monthly = buildMy_monthly();
        serverdata_ = [];
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<contentreport_m> buildMy_monthly() {
    List<contentreport_m> m_report = [];
    for (int i = 0; i < serverdata_.length; i++) {
      String stringValue = serverdata_[i]['avgDriversWorkingToday'];
      double doubleValue = double.parse(stringValue);
      int intValue = doubleValue.toInt();
      m_report.add(contentreport_m(
        month: serverdata_[i]['monthYear'],
        r_moeny: serverdata_[i]['sumTotalBalance'].toDouble(),
        d_package: serverdata_[i]['sumPackageDeliveredNum'],
        w_drivers: intValue.toString(),
        r_package: serverdata_[i]['sumPackageReceivedNumber'],
      ));
    }

    return m_report;
  }
////////////////////////////////////////

//yearly
///////////////////////////////////////////
  Future<void> fetchData_yearly() async {
    var url = urlStarter + "/manager/yearlySummary";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      serverdata_ = data;
      setState(() {
        yearly = buildMy_yearly();
        serverdata_ = [];
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<contentreport_y> buildMy_yearly() {
    List<contentreport_y> y_report = [];
    for (int i = 0; i < serverdata_.length; i++) {
      String stringValue = serverdata_[i]['avgDriversWorkingToday'];
      double doubleValue = double.parse(stringValue);
      int intValue = doubleValue.toInt();
      y_report.add(contentreport_y(
        year: serverdata_[i]['year'].toString(),
        r_moeny: serverdata_[i]['sumTotalBalance'].toDouble(),
        d_package: serverdata_[i]['sumPackageDeliveredNum'],
        w_drivers: intValue.toString(),
        r_package: serverdata_[i]['sumPackageReceivedNumber'],
      ));
    }

    return y_report;
  }
//////////////////////////////////////////

///////interval
////////////////////////////////
  Future<void> fetchData_interval() async {
    var url = urlStarter +
        "/manager/dateRangeSummary?startDate=${from}&endDate=${to}";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      serverdata_ = data;
      String stringValue = serverdata_[0]['avgDriversWorkingToday'];
      double doubleValue = double.parse(stringValue);
      int intValue = doubleValue.toInt();
      setState(() {
        r_moeny_interval = serverdata_[0]['sumTotalBalance'].toDouble();
        d_package_interval = serverdata_[0]['sumPackageDeliveredNum'];
        r_package_interval = serverdata_[0]['sumPackageReceivedNumber'];
        w_drivers_interval = intValue.toString();
        is_load = true;
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

//////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: primarycolor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: primarycolor.withOpacity(0.6),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 1),
                          spreadRadius: 2,
                          blurRadius: 5)
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Today work',
                              style: TextStyle(
                                fontSize: 30,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text.rich(TextSpan(
                              text: "Total received money : ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: "${r_moeny}\$",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(
                            height: 20,
                          ),
                          Text.rich(TextSpan(
                              text: "Total delivered packages : ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${d_package}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(
                            height: 20,
                          ),
                          Text.rich(TextSpan(
                              text: "Total received packages : ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${r_package}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(
                            height: 20,
                          ),
                          Text.rich(TextSpan(
                              text: "Number of drivers works today : ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${w_drivers}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // Text.rich(TextSpan(
                          //     text: "Comment: ",
                          //     style:
                          //         TextStyle(fontSize: 18, color: Colors.grey),
                          //     children: <InlineSpan>[
                          //       TextSpan(
                          //         text: '${comment}',
                          //         style: TextStyle(
                          //           fontSize: 14,
                          //           color: Colors.black,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       )
                          //     ])),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 300,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: primarycolor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Daily",
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                onPressed: () {
                  fetchData_daily().then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              report_d(dailyReports: daily)))));
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 300,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: primarycolor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Monthly",
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                onPressed: () {
                  fetchData_monthly().then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              report_m(dailyReports: monthly)))));
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 300,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: primarycolor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Yearly",
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                onPressed: () {
                  fetchData_yearly().then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              report_y(dailyReports: yearly)))));
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 300,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: primarycolor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Interval",
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    from = '';
                    to = '';
                    is_load = false;
                  });

                  _showBottomSheet();
                },
              ),
            ),
          ],
        ),
      ),
    );
  } ///////

  Future<void> _showBottomSheet() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            height: 1000,
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Select interval',
                          style: TextStyle(
                            color: primarycolor,
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      'From: ${from}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                onPressed: () async {
                                  await _selectDate(context, 'from');
                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      'To:${to}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                onPressed: () async {
                                  await _selectDate(context, 'to');
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: (from.isNotEmpty && to.isNotEmpty)
                                ? primarycolor
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: primarycolor,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Show result",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: from.isNotEmpty && to.isNotEmpty
                                ? () async {
                                    await fetchData_interval();
                                    setState(() {});
                                  }
                                : null,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: is_load,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            Text.rich(TextSpan(
                                text: "Total received money : ",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: "${r_moeny_interval}\$",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ])),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            Text.rich(TextSpan(
                                text: "Total delivered packages : ",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '${d_package_interval}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ])),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            Text.rich(TextSpan(
                                text: "Total received packages : ",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '${r_package_interval}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ])),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            Text.rich(TextSpan(
                                text: "Number of drivers works today : ",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '${w_drivers_interval}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> _selectDate(BuildContext context, String who) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1, 2),
      lastDate: DateTime.now().add(Duration(days: 0)),
    );

    if (selectedDate != null) {
      setState(() {
        if (who == 'to') {
          if (from.isNotEmpty && selectedDate.isBefore(DateTime.parse(from))) {
            to = from;
          } else {
            to = DateFormat('yyyy-MM-dd').format(selectedDate);
          }
        } else {
          if (to.isNotEmpty && selectedDate.isAfter(DateTime.parse(to))) {
            from = to;
          } else {
            from = DateFormat('yyyy-MM-dd').format(selectedDate);
          }
        }
      });
    }
  }
}

class contentreport {
  final int r_moeny;
  final int d_package;
  final int r_package;
  final int w_drivers;

  contentreport({
    required this.r_moeny,
    required this.d_package,
    required this.r_package,
    required this.w_drivers,
  });
}
