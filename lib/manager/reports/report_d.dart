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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Reports'),
        backgroundColor: primarycolor,
      ),
      body: ListView.builder(
          itemCount: widget.dailyReports.length,
          itemBuilder: (context, index) {
            DateTime dateObject =
                DateFormat('yyyy-MM-dd').parse(widget.dailyReports[index].date);
            String dayOfWeek = DateFormat(
              'EEEE',
            ).format(dateObject);
            return Padding(
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
                            child: Text.rich(TextSpan(
                                text: "Date : ",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: "${widget.dailyReports[index].date}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ])),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text.rich(TextSpan(
                              text: "Day : ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: "${dayOfWeek}",
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
                              text: "Total received money : ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text:
                                      "${widget.dailyReports[index].r_moeny}\$",
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
                                  text:
                                      '${widget.dailyReports[index].d_package}',
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
                                  text:
                                      '${widget.dailyReports[index].r_package}',
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
                                  text:
                                      '${widget.dailyReports[index].w_drivers}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class contentreport_d {
  final String date;

  final int r_moeny;
  final int d_package;
  final int r_package;
  final int w_drivers;

  contentreport_d({
    required this.date,
    required this.r_moeny,
    required this.d_package,
    required this.r_package,
    required this.w_drivers,
  });
}
