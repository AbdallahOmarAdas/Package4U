import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/customer/add_parcel.dart';
import 'package:flutter_application_1/customer/main_page.dart';
import 'package:flutter_application_1/customer/set_location.dart';
import 'package:flutter_application_1/manager/creat_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_application_1/style/showDialogShared/show_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class to_me extends StatefulWidget {
  @override
  State<to_me> createState() => _to_meState();
}

class _to_meState extends State<to_me> with TickerProviderStateMixin {
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
        "/customer/getPendingPackagesToMe?userName=" +
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
        "/customer/getNotPendingPackagesToMe?userName=" +
        userName.toString();
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      AcceptedList = data['result'];
      print(AcceptedList.length);
      accepted_orders = _buildMy_d_Orders();
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
      String nameFull = pindingList[i]['user']['Fname'] +
          " " +
          pindingList[i]['user']['Lname'];
      pending_orders.add(
        content(
          id: pindingList[i]['packageId'],
          sender_name: nameFull,
          price: pindingList[i]['total'],
          sender_phone: pindingList[i]['user']['phoneNumber'],
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
                        name: nameFull,
                        phone: pindingList[i]['user']['phoneNumber'],
                        email: pindingList[i]['user']['email'],
                        price: pindingList[i]['total'],
                        shipping: pktType, //package
                        package_size: pktSize,
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

  List<content> _buildMy_d_Orders() {
    List<content> accepted_orders = [];
    for (int i = 0; i < AcceptedList.length; i++) {
      String fromTxt = AcceptedList[i]['locationFromInfo'];
      List fromTxt2 = fromTxt.split(",");
      String toTxt = AcceptedList[i]['locationToInfo'];
      List toTxt2 = toTxt.split(",");
      String nameFull = AcceptedList[i]['user']['Fname'] +
          " " +
          AcceptedList[i]['user']['Lname'];
      accepted_orders.add(
        content(
          id: AcceptedList[i]['packageId'],
          sender_name: nameFull,
          price: AcceptedList[i]['total'],
          sender_phone: AcceptedList[i]['user']['phoneNumber'],
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
              children: accepted_orders,
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
  final double price;
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
  Future postEditPackageLocationTo(
      int packageId, String locationToInfo, double latto, double longto) async {
    var url = urlStarter + "/customer/editPackageLocationTo";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "customerUserName": GetStorage().read('userName'),
          "customerPassword": GetStorage().read('password'),
          "packageId": packageId,
          "latTo": latto,
          "longTo": longto,
          "locationToInfo": locationToInfo
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    print(responceBody);
    if (responceBody['message'] == "failed") {
      List errors = responceBody['error']['errors'];
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().aboutDialogErrors(errors, context);
          });
    }
    if (responceBody['message'] == "failed1") {
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().alartDialogPushNamed(
                "Failed!",
                "There is an error happend while update location, please try latter ",
                context,
                GetStorage().read("userType"));
          });
    }

    return responceBody;
  }

  late double latto = 0;
  late double longto;
  late String location = '';
  void getlocationto(String text, double lat, double long) async {
    String modifiedString = text.replaceAll("','", ",");
    postEditPackageLocationTo(widget.id, modifiedString, lat, long);
    setState(() {
      // int startIndex = 0;
      // int colonIndex;
      // int commaIndex;
      // String extractedText = '';
      // while (true) {
      //   colonIndex = text.indexOf(':', startIndex);
      //   commaIndex = text.indexOf(',', colonIndex + 1);

      //   if (colonIndex == -1 || commaIndex == -1) {
      //     break;
      //   }
      //   extractedText +=
      //       text.substring(colonIndex + 1, commaIndex - 1).trim() + ' , ';

      //   startIndex = commaIndex + 1;
      // }
      location = modifiedString;
      _to_meState().fetchDataAccepted();
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
                    text: 'Total Delivery Price :',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    children: <InlineSpan>[
                      TextSpan(
                        text: ' ${widget.price.toStringAsFixed(2)}\$',
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
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadiusDirectional.circular(22.0),
                            color: primarycolor),
                        child: TextButton.icon(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          label: Text(
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
                                                text:
                                                    'Total Delivery Price : :',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text:
                                                        ' ${widget.price.toStringAsFixed(2)}\$',
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
