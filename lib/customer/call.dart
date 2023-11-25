import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class call extends StatefulWidget {
  const call({super.key});

  @override
  State<call> createState() => _callState();
}

class _callState extends State<call> {
  String? phone1;
  String? phone2;
  String? email;
  String? facebook;
  String? openDay;
  String? openTime;
  String? closeDay;
  String? companyHead;
  String? companyManager;
  String? aboutCompany;

  Future<void> fetchData() async {
    var url = urlStarter + "/users/info";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        phone1 = data['phone1'];
        phone2 = data['phone2'];
        email = data['email'];
        facebook = data['facebook'];
        openDay = data['openDay'];
        openTime = data['openTime'];
        closeDay = data['closeDay'];
        companyHead = data['companyHead'];
        companyManager = data['companyManager'];
        aboutCompany = data['aboutCompany'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  TextStyle myTextStyle() {
    return TextStyle(fontSize: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Package4U Info'),
          backgroundColor: primarycolor,
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: primarycolor,
                      thickness: 2.5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Contact Information',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: primarycolor),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: primarycolor,
                      thickness: 2.5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.local_phone_outlined,
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Text(
                          phone1.toString(),
                          style: myTextStyle(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_android_sharp,
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Text(phone2.toString(), style: myTextStyle()),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Text(email.toString(), style: myTextStyle()),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.facebook_outlined,
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Text(facebook.toString(), style: myTextStyle()),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Text(openDay.toString(), style: myTextStyle()),
                        SizedBox(
                          width: 40,
                        ),
                        Text(openTime.toString(),
                            style: TextStyle(color: Colors.green)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 125,
                        ),
                        Text(closeDay.toString(), style: myTextStyle()),
                        SizedBox(
                          width: 40,
                        ),
                        Text(
                          'Closed',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Divider(
                      color: primarycolor,
                      thickness: 2.5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Company Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: primarycolor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: primarycolor,
                      thickness: 2.5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: Column(children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Row(
                              children: [
                                Text('Company Headquarters: ',
                                    style: TextStyle(fontSize: 20)),
                                Text(companyHead.toString(),
                                    style: myTextStyle())
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outlined,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Row(
                              children: [
                                Text('Company Manager: ',
                                    style: TextStyle(fontSize: 20)),
                                Text(companyManager.toString(),
                                    style: myTextStyle())
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('About Company:',
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    aboutCompany.toString(),
                                    style: myTextStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ]),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
