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
  List Locations = [];
  String? userName;
  TextEditingController _textController2 = TextEditingController();
  String customerUserName = GetStorage().read('userName').toString();
  String customerPassword = GetStorage().read('password');
  bool flag = false;

  Future<void> fetchData() async {
    print(customerUserName);
    var url = urlStarter + "/customer/getTechnicalReports";
    final response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "customerUserName": customerUserName,
          "customerPassword": customerPassword
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        Locations.clear();
        Locations = data['result'];
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

  Future postDeleteLocation(int id) async {
    var url = urlStarter + "/customer/deleteLocation";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "customerUserName": customerUserName,
          "customerPassword": customerPassword,
          "id": id
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    if (responce.statusCode == 200) {
      fetchData();
    } else {
      throw Exception('Failed to load data');
    }
    return responceBody;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<String> savedRows = [];

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
              child: ListView.separated(
                itemCount: Locations.length,
                itemBuilder: (context, index) {
                  List<String> detials =
                      Locations[index]['location'].split(',');
                  return ListTile(
                      title: Text(
                        "${Locations[index]['name']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: primarycolor, fontSize: 28),
                      ),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                detials[0],
                                style: textcolumnstyle(),
                              ),
                              Text(detials[1], style: textcolumnstyle()),
                              Text(detials[2], style: textcolumnstyle()),
                              Text(detials[3], style: textcolumnstyle()),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.delete_sweep,
                                  size: 35,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  postDeleteLocation(Locations[index]['id']);
                                },
                              ),
                            ],
                          ),
                        ],
                      ));
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 2,
                    color: Colors.grey,
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
              )),
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SendTechnicalReport()));
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
