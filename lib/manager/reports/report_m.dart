import 'package:Package4U/style/common/theme_h.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class report_m extends StatefulWidget {
  final List<contentreport_m> dailyReports;

  report_m({required this.dailyReports});

  @override
  State<report_m> createState() => _report_mState();
}

class _report_mState extends State<report_m> {
  String from = '';
  String to = '';
  List<contentreport_m> filteredReports = [];

  void initState() {
    super.initState();
  }

  List<contentreport_m> getFilteredReports() {
    if (from.isEmpty && to.isEmpty) {
      return widget.dailyReports;
    }

    DateTime fromDate =
        from.isNotEmpty ? DateTime.parse(from + '-01') : DateTime(0);
    DateTime toDate =
        to.isNotEmpty ? DateTime.parse(to + '-01') : DateTime.now();
    // print(fromDate);
    // print('from');
    // print(from);

    return widget.dailyReports.where((report) {
      String i = _convertDateFormat(report.month);
      DateTime reportDate = DateTime.parse(i + '-01');
      return (reportDate.isAfter(fromDate) ||
              reportDate.isAtSameMomentAs(fromDate)) &&
          (reportDate.isBefore(toDate) || reportDate.isAtSameMomentAs(toDate));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<contentreport_m> filteredReports = getFilteredReports();
    filteredReports.sort((a, b) =>
        DateTime.parse(_convertDateFormat(a.month) + '-01')
            .compareTo(DateTime.parse(_convertDateFormat(b.month) + '-01')));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text('Monthly Report'),
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
                                text: "Month : ",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: "${filteredReports[index].month}",
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
                            text: "Average number of drivers works in month : ",
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
    DateTime currentDate = DateTime.now();

    int selectedYear = currentDate.year;
    int selectedMonth = currentDate.month;

    DateTime? selectedDate = await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 300,
          child: Column(
            children: [
              ElevatedButton(
                child: Text('Save'),
                onPressed: () {
                  _saveDate(context, who, selectedYear, selectedMonth);
                },
              ),
              Container(
                height: 200.0,
                child: Row(
                  children: [
                    _buildYearPicker(
                      selectedYear,
                      (value) {
                        setState(() {
                          selectedYear = value;
                        });
                      },
                    ),
                    _buildMonthPicker(
                      selectedMonth,
                      (value) {
                        setState(() {
                          selectedMonth = value + 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveDate(BuildContext context, String who, int year, int month) {
    String formattedDate = DateFormat('yyyy-MM').format(
      DateTime(year, month),
    );

    if (who == 'to') {
      to = formattedDate;
    } else {
      from = formattedDate;
    }

    Navigator.pop(context); // Close the bottom sheet
  }

  String _convertDateFormat(String date) {
    // Assuming input date is in "MM-yyyy" format
    List<String> parts = date.split('-');
    return '${parts[1]}-${parts[0]}';
  }

  Widget _buildYearPicker(int value, void Function(int) onChanged) {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 40,
        onSelectedItemChanged: (int index) {
          onChanged(index + 2023); // Starting from 2023
        },
        children: List.generate(20, (index) => Text((2023 + index).toString())),
      ),
    );
  }

  Widget _buildMonthPicker(int value, void Function(int) onChanged) {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 40,
        onSelectedItemChanged: onChanged,
        children: List.generate(12, (index) => Text((index + 1).toString())),
      ),
    );
  }
}

class contentreport_m {
  final String month;
  final double? r_moeny;
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
