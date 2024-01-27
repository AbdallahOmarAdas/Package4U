import 'package:Package4U/style/common/theme_h.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class report_d extends StatefulWidget {
  final List<contentreport_d> dailyReports;

  report_d({required this.dailyReports});

  @override
  State<report_d> createState() => _report_dState();
}

class _report_dState extends State<report_d> {
  String from = '';
  String to = '';
  void initState() {
    super.initState();
  }

  List<contentreport_d> getFilteredReports() {
    if (from.isEmpty && to.isEmpty) {
      return widget.dailyReports;
    }

    DateTime fromDate = from.isNotEmpty ? DateTime.parse(from) : DateTime(0);
    DateTime toDate = to.isNotEmpty ? DateTime.parse(to) : DateTime.now();
    print(fromDate);
    print('from');
    print(from);
    return widget.dailyReports.where((report) {
      DateTime reportDate = DateTime.parse(report.date);
      return (reportDate.isAfter(fromDate) ||
              reportDate.isAtSameMomentAs(fromDate)) &&
          (reportDate.isBefore(toDate) || reportDate.isAtSameMomentAs(toDate));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<contentreport_d> filteredReports = getFilteredReports();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text('Daily Report'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary:
                          Colors.grey.shade600, // Set your desired color here
                    ),
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
                    style: ElevatedButton.styleFrom(
                      primary:
                          Colors.grey.shade600, // Set your desired color here
                    ),
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
          ),
          for (int index = 0; index < filteredReports.length; index++)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: Colors.blue.withOpacity(0.6),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        spreadRadius: 2,
                        blurRadius: 5,
                      )
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
                            child: Text.rich(TextSpan(
                              text: "Date : ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: "${filteredReports[index].date}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text.rich(TextSpan(
                            text: "Day : ",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: DateFormat('EEEE').format(
                                  DateFormat('yyyy-MM-dd')
                                      .parse(filteredReports[index].date),
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Text.rich(TextSpan(
                            text: "Total deilvery money : ",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: filteredReports[index].r_moeny != null
                                    ? "${filteredReports[index].r_moeny!.toStringAsFixed(2)}\$"
                                    : "${filteredReports[index].r_moeny}\$",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Text.rich(TextSpan(
                              text: "Total receive packages price : ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: filteredReports[index]
                                              .total_r_p_price !=
                                          null
                                      ? "${filteredReports[index].total_r_p_price!.toStringAsFixed(2)}\$"
                                      : "${filteredReports[index].total_r_p_price}\$",
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
                              text: "Total paid packages price : ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: filteredReports[index]
                                              .total_p_p_price !=
                                          null
                                      ? "${filteredReports[index].total_p_p_price!.toStringAsFixed(2)}\$"
                                      : "${filteredReports[index].total_p_p_price}\$",
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
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: '${filteredReports[index].d_package}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Text.rich(TextSpan(
                            text: "Total received packages : ",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: '${filteredReports[index].r_package}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Text.rich(TextSpan(
                            text: "Number of drivers works today : ",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: '${filteredReports[index].w_drivers}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // Text.rich(TextSpan(
                          //   text: "Comment : ",
                          //   style: TextStyle(fontSize: 18, color: Colors.grey),
                          //   children: <InlineSpan>[
                          //     TextSpan(
                          //       text: '${filteredReports[index].comment}',
                          //       style: TextStyle(
                          //         fontSize: 14,
                          //         color: Colors.black,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ],
                          // )),
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
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String who) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023, 12, 31),
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

class contentreport_d {
  final String date;
  final double? r_moeny;
  final double? total_r_p_price;
  final double? total_p_p_price;
  final int d_package;
  final int r_package;
  final int w_drivers;
  final String comment;

  contentreport_d({
    required this.total_r_p_price,
    required this.total_p_p_price,
    required this.comment,
    required this.date,
    required this.r_moeny,
    required this.d_package,
    required this.r_package,
    required this.w_drivers,
  });
}
