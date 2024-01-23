import 'package:Package4U/style/common/theme_h.dart';
import 'package:flutter/material.dart';

class report_m extends StatefulWidget {
  final List<contentreport_m> dailyReports;

  report_m({required this.dailyReports});

  @override
  State<report_m> createState() => _report_mState();
}

class _report_mState extends State<report_m> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Reports'),
        backgroundColor: primarycolor,
      ),
      body: ListView.builder(
          itemCount: widget.dailyReports.length,
          itemBuilder: (context, index) {
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
                                text: "Month : ",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: "${widget.dailyReports[index].month}",
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
                              text:
                                  "Average number of drivers works in month : ",
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

class contentreport_m {
  final String month;
  final int r_moeny;
  final String d_package;
  final String r_package;
  final String w_drivers;

  contentreport_m({
    required this.month,
    required this.r_moeny,
    required this.d_package,
    required this.r_package,
    required this.w_drivers,
  });
}
