import 'package:Package4U/style/common/theme_h.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class prices extends StatefulWidget {
  @override
  State<prices> createState() => _pricesState();
}

class _pricesState extends State<prices> {
  double all_price = 0;

  String formatDate(DateTime dateTime) {
    // Format the DateTime object as a string in 'yyyy-MM-dd' format
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  List<dynamic> all_p = [];
  List<content_packgaes> packges = [];

  Future<void> fetchData_p() async {
    var url = urlStarter + "/manager/managerPackagePrices";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      all_p = data['GetPackagesMustPayForCompany'];
      print(all_p);
      setState(() {
        all_price = data['TotalPaiedPackagePrices'].toDouble();
        packges = buildMy_packges();
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<content_packgaes> buildMy_packges() {
    List<content_packgaes> orders = [];

    for (int i = 0; i < all_p.length; i++) {
      DateTime dateTime = DateTime.parse(all_p[i]['receiveDate']);
      String dateOnly = formatDate(dateTime);
      orders.add(
        content_packgaes(
          driver_name: all_p[i]['reciveDriver']['Fname'] +
              " " +
              all_p[i]['reciveDriver']['Lname'], //reciveDriver
          id: all_p[i]['pkt_packageId'],
          date: dateOnly,
          driver_username: all_p[i]['reciveDriver_userName'],
          price: all_p[i]['paidAmount'].toDouble(),
        ),
      );
    }

    return orders;
  }

  @override
  void initState() {
    fetchData_p();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Financial'),
        backgroundColor: primarycolor,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red, // You can set the color of the border
                  width: 2.0, // You can set the width of the border
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text.rich(TextSpan(
                    text: 'Unearned package prices : ',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    children: <InlineSpan>[
                      TextSpan(
                        text: '${all_price.toStringAsFixed(2)}\$',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ])),
              ),
            ),
          ),
          for (int i = 0; i < packges.length; i++)
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(TextSpan(
                                      text: 'Package ID: ',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: ' ${packges[i].id}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ])),
                                  Spacer(),
                                  Text.rich(TextSpan(
                                      text: 'Date : ',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: ' ${packges[i].date}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ])),
                                  Spacer(),
                                  Text.rich(TextSpan(
                                      text: 'By Driver name : ',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: ' ${packges[i].driver_name}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ])),
                                  Spacer(),
                                  Text.rich(TextSpan(
                                      text: 'Driver username : ',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:
                                              ' ${packges[i].driver_username}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ])),
                                  Spacer(),
                                  Text.rich(TextSpan(
                                      text: 'Package price: ',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:
                                              ' ${packges[i].price.toStringAsFixed(2)}\$',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ])),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
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
}

class content_packgaes {
  final String date;
  final int id;
  final String driver_name;
  final String driver_username;
  final double price;
  // final double all_amount;

  content_packgaes({
    required this.price,
    required this.date,
    required this.driver_name,
    required this.driver_username,
    // required this.all_amount,
    required this.id,
  });
}
