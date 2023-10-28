import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
            width: MediaQuery.of(context).size.width,
            //margin: EdgeInsets.all(0),
            height: 140,
            color: primarycolor,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Track your package shipment",
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter 10 digits tracking number',
                    //hoverColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: primarycolor,
                      ),
                      // Icons.search,
                      color: Colors.blue,
                      onPressed: () {},
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                  ),
                ),
              ],
            ),
          ),
          //  Expanded(
          //padding: const EdgeInsets.all(8.0),
          Container(
            //height: 250,
            //margin: EdgeInsets.only(top: 50),
            child: Image(
              image: AssetImage("assets/ff.png"),
              fit: BoxFit.cover,
            ),
          ),
          // ),
          // SafeArea(
          //   child: Container(
          //     child: Text('welcome'),
          //     // margin: EdgeInsets.fromLTRB(30, top, right, bottom),
          //   ),
          // )
        ],
      ),
    ));
  }
}
