import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Package4U/customer/add_parcel.dart';
import 'package:Package4U/customer/main_page.dart';
import 'package:Package4U/customer/set_location.dart';
import 'package:Package4U/manager/creat_employee.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:Package4U/style/showDialogShared/show_dialog.dart';
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
      pindingList = data['result'];
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
      setState(() {
        AcceptedList = data['result'];
        accepted_orders = _buildMy_d_Orders();
      });
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

  String PackageTypeToString(String packageType) {
    switch (packageType) {
      case 'Package0':
        return 'Small Package';
      case 'Package1':
        return 'Medium Package';
      case 'Package2':
        return 'Large Package';
      case 'Document0':
        return 'Document';
      default:
        return 'Document';
    }
  }

  List<content> _buildMy_p_Orders() {
    List<content> pending_orders = [];
    for (int i = 0; i < pindingList.length; i++) {
      String fromTxt = pindingList[i]['locationFromInfo'];
      List fromTxt2 = fromTxt.split(",");
      String toTxt = pindingList[i]['locationToInfo'];
      List toTxt2 = toTxt.split(",");
      String nameFull = pindingList[i]['send_user']['Fname'] +
          " " +
          pindingList[i]['send_user']['Lname'];
      pending_orders.add(
        content(
          id: pindingList[i]['packageId'],
          sender_name: nameFull,
          price: pindingList[i]['total'],
          sender_phone: pindingList[i]['send_user']['phoneNumber'],
          from: fromTxt2[0] + ", " + fromTxt2[1],
          to: toTxt2[0] + ", " + toTxt2[1],
          flag: false,
          packageType: PackageTypeToString(pindingList[i]['shippingType']),
          context: this.context,
          whoWillPay: pindingList[i]['whoWillPay'],
          btn_edit: () {},
          refreshData: () {
            fetchData();
            fetchDataAccepted();
          },
        ),
      );
    }
    filterdPindingPackages = pending_orders;
    return pending_orders;
  }

  List<content> _buildMy_d_Orders() {
    List<content> accepted_orders = [];
    for (int i = 0; i < AcceptedList.length; i++) {
      String fromTxt = AcceptedList[i]['locationFromInfo'];
      List fromTxt2 = fromTxt.split(",");
      String toTxt = AcceptedList[i]['locationToInfo'];
      List toTxt2 = toTxt.split(",");
      String nameFull = AcceptedList[i]['send_user']['Fname'] +
          " " +
          AcceptedList[i]['send_user']['Lname'];
      accepted_orders.add(
        content(
          id: AcceptedList[i]['packageId'],
          sender_name: nameFull,
          price: AcceptedList[i]['total'],
          sender_phone: AcceptedList[i]['send_user']['phoneNumber'],
          from: fromTxt2[0] + ", " + fromTxt2[1],
          to: toTxt2[0] + ", " + toTxt2[1],
          flag: true,
          context: this.context,
          whoWillPay: AcceptedList[i]['whoWillPay'],
          Status: AcceptedList[i]['status'],
          packageType: PackageTypeToString(AcceptedList[i]['shippingType']),
          btn_edit: () {},
          refreshData: () {
            fetchData();
            fetchDataAccepted();
          },
        ),
      );
    }
    filterdAcceptedPackages = accepted_orders;
    return accepted_orders;
  }

  TextEditingController _searchController = TextEditingController();
  late List<content> filterdPindingPackages = [];
  late List<content> filterdAcceptedPackages = [];
  String? searchText;
  String? filterBy = "Package Id";
  List<String> FilterBylist = ["Package Id", "Sender Name", "Size"];

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
          Column(
            children: [
              filter(pending_orders, "pinding"),
              Expanded(
                child: ListView(
                  children: filterdPindingPackages,
                ),
              ),
            ],
          ),
          Column(
            children: [
              filter(accepted_orders, "accepted"),
              Expanded(
                child: ListView(
                  children: filterdAcceptedPackages,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container filter(List<content> order, String listType) {
    return Container(
      padding: EdgeInsets.only(top: 10, right: 7, left: 7),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadiusDirectional.vertical(bottom: Radius.circular(20)),
        color: Colors.grey[100],
      ),
      height: 60,
      child: GridView.builder(
        itemCount: 2,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 25,
            mainAxisSpacing: 2,
            childAspectRatio: 3),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
                child: TextFormField(
              controller: _searchController,
              onChanged: (value) {
                List<content> filterd;
                filterd = order.where((element) {
                  switch (filterBy) {
                    case 'Package Id':
                      return element.id.toString().startsWith(value);
                    case 'Sender Name':
                      return element.sender_name
                          .toString()
                          .toLowerCase()
                          .startsWith(value.toLowerCase());
                    case 'Size':
                      return element.packageType
                          .toString()
                          .toLowerCase()
                          .startsWith(value.toLowerCase());
                    default:
                      return true;
                  }
                }).toList();
                setState(() {
                  if (listType == "pinding")
                    filterdPindingPackages = filterd;
                  else
                    filterdAcceptedPackages = filterd;
                });
              },
              decoration: theme_helper().text_form_style_search(
                'Search',
                'Enter ${filterBy}',
                Icons.search,
                _searchController,
                () {
                  _searchController.clear();
                  setState(() {
                    if (listType == "pinding")
                      filterdPindingPackages = pending_orders;
                    else
                      filterdAcceptedPackages = accepted_orders;
                  });
                },
              ),
            ));
          } else {
            return Container(
              child: DropdownButtonFormField(
                value: filterBy,
                isExpanded: true,
                hint: Text('Filter By'),
                decoration: theme_helper().text_form_style(
                  '',
                  '',
                  Icons.filter_alt,
                ),
                items: FilterBylist.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    filterBy = (value as String?)!;
                  });
                },
              ),
            );
          }
        },
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
  final String whoWillPay;
  final String packageType;
  final bool flag; // pendding or deliverd
  final String Status;
  final BuildContext context;
  final Function() btn_edit;
  final Function() refreshData;

  const content(
      {super.key,
      required this.btn_edit,
      required this.id,
      required this.sender_name,
      required this.sender_phone,
      required this.price,
      required this.from,
      required this.to,
      required this.whoWillPay,
      required this.packageType,
      required this.flag,
      required this.context,
      required this.refreshData,
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
    widget.refreshData();
    return responceBody;
  }

  Future<void> fetchLocations() async {
    var url = urlStarter +
        "/customer/getMyLocations?userName=" +
        GetStorage().read('userName').toString();
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        Locations = data['result'];
      });
    } else if (response.statusCode == 404) {
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
    Locations.add({
      "longTo": 35.297659,
      "latTo": 32.193192,
      "location":
          "residential: روجيب, suburb: إسكان الموظفين, village: روجيب, county: منطقة ب",
      "name": "Manually set Location",
      "id": 99999999
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLocations();
  }

  late double latto = 0;
  late double longto;
  late String location = '';
  List Locations = [];
  void getlocationto(String text, double lat, double long) async {
    String modifiedString = text.replaceAll("','", ",");
    postEditPackageLocationTo(widget.id, modifiedString, lat, long);
    setState(() {
      List list = modifiedString.split(',');
      location = list[0] + ", " + list[1];
      _to_meState().fetchData();
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
                        'Do you want to modify the delivery location?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: primarycolor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        isExpanded: true,
                        hint: Text('Edit delivery location',
                            style: TextStyle(color: Colors.grey)),
                        items: Locations.map((value) {
                          return DropdownMenuItem(
                            value: value['id'],
                            child: Text(
                              value['name'].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                        decoration: theme_helper().text_form_style(
                          '',
                          '',
                          Icons.edit,
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (99999999 == value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => set_location(
                                          onDataReceived: getlocationto))));
                            } else {
                              Locations.map((value1) {
                                if (value == value1['id']) {
                                  latto = value1['latTo'];
                                  longto = value1['longTo'];
                                  location = value1['location'];
                                  List modifiedString = location.split(',');
                                  location = modifiedString[0] +
                                      ", " +
                                      modifiedString[1];
                                  postEditPackageLocationTo(widget.id,
                                      value1['location'], latto, longto);
                                }
                              }).toString();
                            }
                          });
                        },
                      )
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
                                              1.9,
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
                                                    text: 'Package Type :',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                        text:
                                                            ' ${widget.packageType}',
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
                                                text: 'Total Delivery Price :',
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
                                                text: 'Who will pay :',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text:
                                                        ' ${widget.whoWillPay}',
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
