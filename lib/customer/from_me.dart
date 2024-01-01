import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Package4U/customer/add_parcel.dart';
import 'package:Package4U/customer/main_page.dart';
import 'package:Package4U/manager/creat_employee.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:Package4U/style/showDialogShared/show_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class from_me extends StatefulWidget {
  @override
  State<from_me> createState() => _from_meState();
}

class _from_meState extends State<from_me> with TickerProviderStateMixin {
  late TabController _tabController;
  List<content> pending_orders = [];
  List<content> accepted_orders = [];
  String? userName;
  String? customerUserName;
  String? customerPassword;
  List<dynamic> pindingList = [];
  List<dynamic> AcceptedList = [];

  Future<void> fetchData() async {
    var url = urlStarter +
        "/customer/getPendingPackages?userName=" +
        userName.toString();
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        pindingList = data['result'];
      });
      pending_orders = _buildMy_p_Orders();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchDataAccepted() async {
    var url = urlStarter +
        "/customer/getNotPendingPackages?userName=" +
        userName.toString();
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        AcceptedList = data['result'];
        print(AcceptedList.length);
      });
      accepted_orders = _buildMy_a_Orders();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    String customerUserName = GetStorage().read('userName');
    String customerPassword = GetStorage().read('password');
    userName = GetStorage().read('userName');
    fetchData();
    fetchDataAccepted();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<content> _buildMy_p_Orders() {
    List<content> pending_orders = [];
    for (int i = 0; i < pindingList.length; i++) {
      String whoPay =
          pindingList[i]['rec_userName'] == null ? "Doesn't have" : "Have";
      int pktSize = 0;
      String pktType = '';
      switch (pindingList[i]['shippingType']) {
        case 'Package0':
          pktSize = 0;
          pktType = 'Package';
          break;
        case 'Package1':
          pktSize = 1;
          pktType = 'Package';
          break;
        case 'Package2':
          pktSize = 2;
          pktType = 'Package';
          break;
        case 'Document0':
          pktSize = 0;
          pktType = 'Document';
          break;
        default:
          pktSize = 0;
          pktType = 'Document';
          break;
      }
      String fromTxt = pindingList[i]['locationFromInfo'];
      List fromTxt2 = fromTxt.split(",");
      String toTxt = pindingList[i]['locationToInfo'];
      List toTxt2 = toTxt.split(",");
      double price = pindingList[i]['total'].toDouble();
      pending_orders.add(
        content(
          id: pindingList[i]['packageId'],
          name: pindingList[i]['recName'],
          price: price,
          phone: pindingList[i]['recPhone'],
          from: fromTxt2[0] + ", " + fromTxt2[1],
          to: toTxt2[0] + ", " + toTxt2[1],
          flag: false,
          context: this.context,
          btn_edit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => add_parcel(
                        title: 'Edit Package',
                        packageId: pindingList[i]['packageId'],
                        name: pindingList[i]['recName'],
                        phone: pindingList[i]['recPhone'],
                        rec_userName: pindingList[i]['rec_userName'].toString(),
                        email: pindingList[i]['recEmail'],
                        price: pindingList[i]['packagePrice'],
                        distance: pindingList[i]['distance'],
                        paySelectedValue: pindingList[i]['whoWillPay'],
                        accountSelectedValue: whoPay,
                        shipping: pktType, //package
                        package_size: pktSize, // meduim
                        shippingfrom: pindingList[i]['locationFromInfo'],
                        shippingto: pindingList[i]['locationToInfo'],
                        delv_price: 300,
                        total_price: pindingList[i]['total'],
                        latfrom: pindingList[i]['latFrom'],
                        latto: pindingList[i]['latTo'],
                        longfrom: pindingList[i]['longFrom'],
                        longto: pindingList[i]['longTo'],
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
    for (int i = 0; i < AcceptedList.length; i++) {
      String fromTxt = AcceptedList[i]['locationFromInfo'];
      List fromTxt2 = fromTxt.split(",");
      String toTxt = AcceptedList[i]['locationToInfo'];
      List toTxt2 = toTxt.split(",");
      accepted_orders.add(
        content(
          id: AcceptedList[i]['packageId'],
          name: AcceptedList[i]['recName'],
          price: AcceptedList[i]['total'],
          phone: AcceptedList[i]['recPhone'],
          from: fromTxt2[0] + ", " + fromTxt2[1],
          to: toTxt2[0] + ", " + toTxt2[1],
          flag: true,
          context: this.context,
          Status: AcceptedList[i]['status'],
          btn_edit: () {},
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
          indicatorColor: Colors.white,
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
  Future postDeletePackage(int packageId) async {
    var url = urlStarter + "/customer/deletePackage";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "customerUserName": GetStorage().read('userName'),
          "customerPassword": GetStorage().read('password'),
          "packageId": packageId
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    print(responceBody);
    if (responceBody['message'] == "failed") {
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().alartDialogPushNamed("Failed!",
                "failed to deleted the package", context, "customer");
          });
    }

    return responceBody;
  }

  final int id;
  final int phone;
  final double price;
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
                    text: 'Total Delivery Price :',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    children: <InlineSpan>[
                      TextSpan(
                        text: ' ${price.toStringAsFixed(2)}\$',
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
                                                postDeletePackage(this.id);
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
                  visible: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                          visible: flag,
                          child: Column(
                            children: [
                              Text.rich(TextSpan(
                                  text: 'Status:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                              )
                            ],
                          )),
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
                                              2.3,
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
                                              height: 10,
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
                                            SizedBox(height: 10),
                                            Text.rich(TextSpan(
                                                text: 'Total Delivery Price :',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text:
                                                        ' ${price.toStringAsFixed(2)}\$',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.red,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                ])),
                                            SizedBox(height: 10),
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
                                              height: 10,
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
                                              height: 10,
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
                                            SizedBox(height: 10),
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
                                              height: 10,
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
