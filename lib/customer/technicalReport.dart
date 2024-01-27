import 'package:Package4U/customer/technicalReportDetails.dart';
import 'package:flutter/material.dart';
import 'package:Package4U/customer/sendTechnicalReport.dart';
import 'package:Package4U/customer/set_location.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TechnicalReport extends StatefulWidget {
  @override
  _TechnicalReportState createState() => _TechnicalReportState();
}

class _TechnicalReportState extends State<TechnicalReport> {
  List reports = [];
  String? userName;
  TextEditingController _textController2 = TextEditingController();
  String customerUserName = GetStorage().read('userName').toString();
  String customerPassword = GetStorage().read('password');
  bool flag = false;

  Future<void> fetchData() async {
    print(customerUserName);
    var url = urlStarter +
        "/admin/getUserTechnicalReports?userName=${customerUserName}";
    final response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'ngrok-skip-browser-warning': 'true'
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        reports.clear();
        reports = data['result'];
        flag = false;
      });
    } else if (response.statusCode == 404) {
      setState(() {
        flag = true;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future postDeleteReport(int id) async {
    var url = urlStarter + "/admin/deleteTechnicalReport/${id}";
    var responce = await http.delete(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
    });
    if (responce.statusCode == 200) {
      fetchData();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  //ist<String>  = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Technical Reports'),
        backgroundColor: primarycolor,
      ),
      body: Column(
        children: [
          Visibility(
            visible: !flag,
            child: Expanded(
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to details page here
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            TechnicalReportDetails(id: reports[index]['id']),
                      ));
                    },
                    child: Card(
                      color: Colors.grey[300],
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${reports[index]['Title']}",
                                    style: TextStyle(
                                        color: primarycolor, fontSize: 28),
                                  ),
                                  SizedBox(height: 10),
                                  Text.rich(
                                    TextSpan(
                                      text: "${reports[index]['message']}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                    overflow:
                                        TextOverflow.visible, // Add this line
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Date: ${reports[index]['createdAt'].toString().split('T')[0]}",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_sweep,
                                size: 35,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                postDeleteReport(reports[index]['id']);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Visibility(
            visible: flag,
            child: Column(
              children: [
                Text(
                  "There are no reports sent",
                  style: TextStyle(color: primarycolor, fontSize: 25),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: TextButton.icon(
              label: Text(
                'Send New Report',
                style: TextStyle(
                  color: primarycolor,
                  fontSize: 28,
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => SendTechnicalReport()))
                    .then((value) => fetchData());
              },
              icon: Icon(
                Icons.bug_report_outlined,
                size: 40,
                color: primarycolor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle textcolumnstyle() {
  return TextStyle(
    fontSize: 15,
  );
}
