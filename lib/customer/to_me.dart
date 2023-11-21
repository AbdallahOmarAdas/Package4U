import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/customer/add_parcel.dart';
import 'package:flutter_application_1/customer/main_page.dart';
import 'package:flutter_application_1/customer/set_location.dart';
import 'package:flutter_application_1/manager/creat_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';

class to_me extends StatefulWidget {
  @override
  State<to_me> createState() => _to_meState();
}

class _to_meState extends State<to_me> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<content> pending_orders;
  late List<content> deliverd_orders;

  @override
  void initState() {
    super.initState();
    pending_orders = _buildMy_p_Orders();
    deliverd_orders = _buildMy_d_Orders();
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
          sender_name: 'mohammad',
          price: 75,
          sender_phone: 0599224532,
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

  List<content> _buildMy_d_Orders() {
    List<content> deliverd_orders = [];
    for (int i = 1; i <= 5; i++) {
      deliverd_orders.add(
        content(
          id: 1234567382,
          sender_name: 'mohammad',
          price: 75,
          sender_phone: 0599224532,
          from: 'nablus',
          to: 'tulkarm',
          flag: true,
          context: this.context,
          Status: 'Delivered',
          btn_edit: () {},
        ),
      );
    }

    return deliverd_orders;
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
            Tab(text: 'Deliverd Orders'),
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
              children: deliverd_orders,
            ),
          ),
        ],
      ),
    );
  }
}

class content extends StatefulWidget {
  final int id;
  final int sender_phone;
  final int price;
  final String from;
  final String to;
  final String sender_name;
  final bool flag; // pendding or deliverd
  final String Status;
  final BuildContext context;
  final Function() btn_edit;

  const content(
      {super.key,
      required this.btn_edit,
      required this.id,
      required this.sender_name,
      required this.sender_phone,
      required this.price,
      required this.from,
      required this.to,
      required this.flag,
      required this.context,
      this.Status = ''});

  @override
  State<content> createState() => _contentState();
}

class _contentState extends State<content> {
  late double latto = 0;
  late double longto;
  late String location = '';
  void getlocationto(String text, double lat, double long) async {
    setState(() {
      int startIndex = 0;
      int colonIndex;
      int commaIndex;
      String extractedText = '';
      while (true) {
        colonIndex = text.indexOf(':', startIndex);
        commaIndex = text.indexOf(',', colonIndex + 1);

        if (colonIndex == -1 || commaIndex == -1) {
          break;
        }
        extractedText +=
            text.substring(colonIndex + 1, commaIndex - 1).trim() + ' , ';

        startIndex = commaIndex + 1;
      }
      location = extractedText;
      latto = lat;
      longto = long;
    });
  }

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
                            text: ' ${widget.id}',
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
                            ClipboardData(text: this.widget.id.toString()));
                        ScaffoldMessenger.of(widget.context).showSnackBar(
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
                        text: ' ${widget.price}\$',
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
                  visible: !widget.flag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(
                          text: 'Sender Name :',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' ${widget.sender_name}',
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
                          text: 'Sender Phone:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' ${widget.sender_phone}',
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
                          text: 'Delivery location: ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          children: <InlineSpan>[
                            TextSpan(
                              text: location == '' ? ' ${widget.to}' : location,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontStyle: FontStyle.italic),
                            )
                          ])),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Do you want to modify the access location?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: primarycolor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0)),
                          color: primarycolor,
                          child: Text(
                            "Edit Delivery location",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                widget.context,
                                MaterialPageRoute(
                                    builder: ((context) => set_location(
                                        onDataReceived: getlocationto))));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.flag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(
                          text: 'Status:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' ${widget.Status}',
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
                                  context: widget.context,
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
                                                        text: ' ${widget.id}',
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
                                                    text: ' ${widget.price}\$',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.red,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                ])),
                                            SizedBox(height: 20),
                                            Text.rich(TextSpan(
                                                text: 'Sender Name :',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text:
                                                        ' ${widget.sender_name}',
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
                                                text: 'Sender Phone:',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text:
                                                        ' ${widget.sender_phone}',
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
                                                    text: ' ${widget.from}',
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
                                                    text: ' ${widget.from}',
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
                                                    text: ' ${widget.Status}',
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
