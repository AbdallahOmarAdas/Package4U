import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';

class call extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Call for Booking'),
          backgroundColor: primarycolor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'General Shipping',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.all(20),
                  height: 170,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.phonelink,
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          Text('02-22222-4567'),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.watch_later,
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          Text('MON - FRI'),
                          SizedBox(
                            width: 40,
                          ),
                          Text('08:30-17:30',
                              style: TextStyle(color: Colors.green)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 125,
                          ),
                          Text('SAT - SUN'),
                          SizedBox(
                            width: 40,
                          ),
                          Text(
                            'Closed',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
