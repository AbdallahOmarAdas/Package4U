import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/customer/add_parcel.dart';
import 'package:flutter_application_1/customer/main_page.dart';
import 'package:flutter_application_1/manager/creat_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';

class from_me extends StatefulWidget {
  @override
  State<from_me> createState() => _from_meState();
}

class _from_meState extends State<from_me> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<content> pending_orders;
  late List<content> accepted_orders;

  @override
  void initState() {
    super.initState();
    pending_orders = _buildMy_p_Orders();
    accepted_orders = _buildMy_a_Orders();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<content> _buildMy_p_Orders() {
    List<content> pending_orders = [];
    for (int i = 1; i <= 5; i++) {
      pending_orders.add(
        content(
          id: 1234567382,
          name: 'mohammad',
          price: 75,
          phone: 0599224532,
          from: 'nablus',
          to: 'tulkarm',
          flag: false,
          context: this.context,
          btn_edit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => add_parcel(
                        title: 'Edit Package',
                        name: 'Mohammad',
                        phone: '888888888',
                        email: 'aa@gmail.com',
                        price: 200,
                        shipping: 2, //package
                        package_size: 1, // meduim
                        shippingfrom: 'tulkarm,......',
                        shippingto: 'nablus.........',
                        delv_price: 300,
                        total_price: 500,
                      )),
            );
          },
        ),
      );
    }

    return pending_orders;
  }

  List<content> _buildMy_a_Orders() {
    List<content> accepted_orders = [];
    for (int i = 1; i <= 5; i++) {
      accepted_orders.add(
        content(
          id: 1234567382,
          name: 'mohammad',
          price: 75,
          phone: 0599224532,
          from: 'nablus',
          to: 'tulkarm',
          flag: true,
          context: this.context,
          Status: 'Delivered',
          btn_edit: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => home_page_customer()),
            // );
          },
        ),
      );
    }

    return accepted_orders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text('List Packages'),
        bottom: TabBar(
          indicatorColor: Colors.red,
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending Orders'),
            Tab(text: 'Accepted Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: pending_orders,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: accepted_orders,
            ),
          ),
        ],
      ),
    );
  }
}

class content extends StatelessWidget {
  final int id;
  final int phone;
  final int price;
  final String from;
  final String to;
  final String name;
  final bool flag; // pendding or accepted
  final String Status;
  final BuildContext context;
  final Function() btn_edit;

  const content(
      {super.key,
      required this.btn_edit,
      required this.id,
      required this.name,
      required this.phone,
      required this.price,
      required this.from,
      required this.to,
      required this.flag,
      required this.context,
      this.Status = ''});

  @override
  Widget build(BuildContext) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: primarycolor.withOpacity(0.6),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 1), spreadRadius: 2, blurRadius: 5)
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text.rich(TextSpan(
                        text: 'Package ID :',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        children: <InlineSpan>[
                          TextSpan(
                            text: ' ${id}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontStyle: FontStyle.italic),
                          )
                        ])),
                    IconButton(
                      icon: Icon(Icons.copy),
                      color: Colors.green,
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: this.id.toString()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: primarycolor,
                            content: Text(
                              'Package ID copied to clipboard',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Text.rich(TextSpan(
                    text: 'Price :',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    children: <InlineSpan>[
                      TextSpan(
                        text: ' ${price}\$',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontStyle: FontStyle.italic),
                      )
                    ])),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: !flag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(
                          text: 'Recipient Name :',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' ${name}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontStyle: FontStyle.italic),
                            )
                          ])),
                      SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                          text: 'Recipient Phone:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' ${phone}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontStyle: FontStyle.italic),
                            )
                          ])),
                      SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                          text: 'Address:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' ${from}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontStyle: FontStyle.italic),
                            )
                          ])),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: primarycolor,
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: btn_edit,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: primarycolor,
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                // here delete package database
                                                // this.id
                                                Navigator.of(context).pop();
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          from_me()),
                                                );
                                              },
                                              child: Text(
                                                "Yes",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "No",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              )),
                                        ],
                                        title: Text("Delete Package"),
                                        content: Text(
                                            "Are you sure you want to delete Package?"),
                                        titleTextStyle: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                        contentTextStyle: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        backgroundColor: primarycolor,
                                      );
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: flag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(
                          text: 'Status:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' ${Status}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontStyle: FontStyle.italic),
                            )
                          ])),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0)),
                            color: primarycolor,
                            child: Text(
                              "Show Details",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(255, 236, 235, 235)),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40.0),
                                      topRight: Radius.circular(40.0),
                                    ),
                                  ),
                                  builder: (context) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Text(
                                                'Package Details',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blueGrey),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Text.rich(TextSpan(
                                                    text: 'Package ID :',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                        text: ' ${id}',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.red,
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      )
                                                    ])),
                                              ],
                                            ),
                                            SizedBox(height: 20),
                                            Text.rich(TextSpan(
                                                text: 'Price :',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text: ' ${price}\$',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.red,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                ])),
                                            SizedBox(height: 20),
                                            Text.rich(TextSpan(
                                                text: 'Recipient Name :',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text: ' ${name}',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.red,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                ])),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text.rich(TextSpan(
                                                text: 'Recipient Phone:',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text: ' ${phone}',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.red,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                ])),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text.rich(TextSpan(
                                                text: 'Shipping From:',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text: ' ${from}',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.red,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                ])),
                                            SizedBox(height: 20),
                                            Text.rich(TextSpan(
                                                text: 'shipping To:',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text: ' ${from}',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.red,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                ])),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text.rich(TextSpan(
                                                text: 'Status :',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text: ' ${Status}',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.red,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                ])),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
