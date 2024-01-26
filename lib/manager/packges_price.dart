import 'package:Package4U/style/common/theme_h.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class prices extends StatefulWidget {
  @override
  State<prices> createState() => _pricesState();
}

class _pricesState extends State<prices> {
  List<dynamic> all_p = [];
  List<content_packgaes> packges = [
    content_packgaes(
      driver_name: '1234',
      id: 55,
      date: '122232',
      driver_username: 'qqww',
      price: 43344,
    ),
  ];

  Future<void> fetchData_p() async {
    var url = urlStarter + "/employee/getNewOrders";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      all_p = data['result'];
      print(all_p);
      setState(() {
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
      orders.add(
        content_packgaes(
          driver_name: '1234',
          id: 55,
          date: '122232',
          driver_username: 'qqww',
          price: 43344,
        ),
      );
    }

    return orders;
  }

  @override
  void initState() {
    //fetchData_p();
    // setState(() {
    //   packges = buildMy_packges();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packages price'),
        backgroundColor: primarycolor,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text.rich(TextSpan(
                  text: 'Packges price : ',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  children: <InlineSpan>[
                    TextSpan(
                      text: '300\$',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ])),
            ),
          ),
          for (int i = 0; i < packges.length; i++)
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
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
                                          text: ' ${packges[i].price}\$',
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
