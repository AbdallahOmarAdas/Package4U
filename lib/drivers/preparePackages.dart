import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/drivers/mapModalBottomsheet.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class PreparePackages extends StatefulWidget {
  const PreparePackages({super.key});

  @override
  State<PreparePackages> createState() => _PreparePackagesState();
}

class _PreparePackagesState extends State<PreparePackages>
    with SingleTickerProviderStateMixin {
  late List<Content> deliver_order = [];
  late List<Content> receive_order = [];
  late List<Content> filterdReceive_order = [];
  late List<Content> filterdDelivered_order = [];
  TabController? myControler;
  List<dynamic> deliverdList = [];

  @override
  void initState() {
    super.initState();
    myControler = new TabController(length: 2, vsync: this, initialIndex: 1);
    postGetPreparePackage();
  }

  Future postGetPreparePackage() async {
    var url = urlStarter + "/driver/getPreparePackageDriver";
    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "driverUserName": GetStorage().read('userName'),
          "driverPassword": GetStorage().read('password')
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        deliverdList = data['result'];
        print("refresh" + deliverdList.length.toString());
        _buildMy_deliverd_Orders();
      });
    } else if (response.statusCode == 404) {
      setState(() {
        deliverdList = [];
        _buildMy_deliverd_Orders();
      });
    } else {
      throw Exception('Failed to load data');
    }
    return;
  }

  void _buildMy_deliverd_Orders() {
    deliver_order = [];
    receive_order = [];
    for (int i = 0; i < deliverdList.length; i++) {
      String delivery_type = deliverdList[i]['status'];

      String pktType = '';
      switch (deliverdList[i]['shippingType']) {
        case 'Package0':
          pktType = 'Small';
          break;
        case 'Package1':
          pktType = 'Medium';
          break;
        case 'Package2':
          pktType = 'Large';
          break;
        case 'Document0':
          pktType = 'Document';
          break;
        default:
          pktType = 'Document';
          break;
      }
      if (delivery_type == "In Warehouse") {
        deliver_order.add(
          Content(
            delivery_type: delivery_type,
            img: urlStarter +
                '/image/' +
                deliverdList[i]['rec_userName'] +
                deliverdList[i]['rec_user']['url'],
            name: deliverdList[i]['rec_user']['Fname'] +
                " " +
                deliverdList[i]['rec_user']['Lname'],
            delivered_price: deliverdList[i]['total'],
            id: deliverdList[i]['packageId'],
            username: deliverdList[i]['rec_userName'],
            context: this.context,
            packageType: pktType,
            phone: deliverdList[i]['rec_user']['phoneNumber'].toString(),
            lat: deliverdList[i]['latTo'],
            long: deliverdList[i]['longTo'],
            locationDescription:
                deliverdList[i]['locationToInfo'].toString().split(','),
            whoWillPay: deliverdList[i]['whoWillPay'],
            showDeliveryPrice:
                deliverdList[i]['whoWillPay'] == "The recipient" ? true : false,
            refreshData: () {
              postGetPreparePackage();
            },
          ),
        );
      } else {
        receive_order.add(
          Content(
            delivery_type: delivery_type,
            img: urlStarter +
                '/image/' +
                deliverdList[i]['send_userName'] +
                deliverdList[i]['send_user']['url'],
            name: deliverdList[i]['send_user']['Fname'] +
                " " +
                deliverdList[i]['send_user']['Lname'],
            delivered_price: deliverdList[i]['total'],
            id: deliverdList[i]['packageId'],
            username: deliverdList[i]['send_userName'],
            context: this.context,
            packageType: pktType,
            phone: deliverdList[i]['send_user']['phoneNumber'].toString(),
            lat: deliverdList[i]['latFrom'],
            long: deliverdList[i]['longFrom'],
            locationDescription:
                deliverdList[i]['locationFromInfo'].toString().split(','),
            whoWillPay: deliverdList[i]['whoWillPay'],
            showDeliveryPrice:
                deliverdList[i]['whoWillPay'] == "The sender" ? true : false,
            refreshData: () {
              setState(() {
                postGetPreparePackage();
              });
            },
          ),
        );
      }
      filterdDelivered_order = deliver_order;
      filterdReceive_order = receive_order;
    }
  }

  TextEditingController _searchController = TextEditingController();
  String? searchText;
  String? filterBy = "Package Id";
  List<String> FilterBylist = ["Package Id", "Name", "Username", "Size"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prepare today packages'),
        backgroundColor: primarycolor,
        bottom: TabBar(
            controller: myControler,
            indicatorWeight: 2,
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(
                text: "               Receiving                ",
                icon: Icon(Icons.call_received_sharp),
              ),
              Tab(
                text: "               Delivery               ",
                icon: Icon(Icons.call_made_sharp),
              )
            ]),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(controller: myControler, children: [
              receive_order.length == 0
                  ? Center(
                      child: Text(
                      "You don't have packages to receiver",
                      style: TextStyle(fontSize: 20, color: primarycolor),
                    ))
                  : Column(
                      children: [
                        filter(receive_order, 1),
                        Expanded(
                          child: ListView(
                            children: filterdReceive_order,
                          ),
                        ),
                      ],
                    ),
              deliver_order.length == 0
                  ? Center(
                      child: Text(
                      "You don't have packages to deliver",
                      style: TextStyle(fontSize: 20, color: primarycolor),
                    ))
                  : Column(
                      children: [
                        filter(deliver_order, 0),
                        Expanded(
                          child: ListView(
                            children: filterdDelivered_order,
                          ),
                        ),
                      ],
                    ),
            ]),
          ),
        ],
      ),
    );
  }

  Container filter(List<Content> receive_order, int type) {
    return Container(
      padding: EdgeInsets.only(top: 10, right: 7, left: 7),
      height: 60,
      color: Colors.grey[100],
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
                List<Content> filterd;
                filterd = receive_order.where((element) {
                  switch (filterBy) {
                    case 'Package Id':
                      return element.id.toString().startsWith(value);
                    case 'Name':
                      return element.name
                          .toString()
                          .toLowerCase()
                          .startsWith(value.toLowerCase());
                    case 'Username':
                      return element.username
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
                  if (type == 1) {
                    filterdReceive_order = filterd;
                  } else if (type == 0) {
                    filterdDelivered_order = filterd;
                  }
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
                    if (type == 1) {
                      filterdReceive_order = receive_order;
                    } else if (type == 0) {
                      filterdDelivered_order = deliver_order;
                    }
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

// ignore: must_be_immutable
class Content extends StatefulWidget {
  final int id;
  late String reason;
  final String phone;
  final String name;
  final String username;
  final String img;
  final double delivered_price;
  final String delivery_type; // 0 Delivery of a package , 1 Receiving a package
  final BuildContext context;
  final String packageType;
  final Function() refreshData;
  final double lat;
  final double long;
  final String whoWillPay;
  final List<String> locationDescription;
  final bool showDeliveryPrice;

  Content(
      {super.key,
      required this.id,
      required this.phone,
      required this.whoWillPay,
      this.reason = '',
      required this.locationDescription,
      required this.name,
      required this.username,
      required this.context,
      required this.img,
      required this.delivered_price,
      required this.delivery_type,
      required this.refreshData,
      required this.packageType,
      required this.showDeliveryPrice,
      required this.lat,
      required this.long});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final formGlobalKey = GlobalKey<FormState>();

  Future AcceptPreparePackageDriver() async {
    print("status: " + widget.delivery_type);
    var url = urlStarter + "/driver/AcceptPreparePackageDriver";
    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "driverUserName": GetStorage().read('userName'),
          "driverPassword": GetStorage().read('password'),
          "status": widget.delivery_type,
          "packageId": widget.id
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      setState(() {
        print("done");
      });
    } else {
      throw Exception('Failed to load data');
    }
    setState(() {
      widget.refreshData();
    });

    return;
  }

  Future RejectPreparePackageDriver() async {
    print("status: " + widget.delivery_type);
    var url = urlStarter + "/driver/RejectPreparePackageDriver";
    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "driverUserName": GetStorage().read('userName'),
          "driverPassword": GetStorage().read('password'),
          "status": widget.delivery_type,
          "packageId": widget.id,
          "comment": widget.reason
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      setState(() {
        print("done");

        widget.refreshData();
      });
    } else {
      throw Exception('Failed to load data');
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
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
                    Container(
                      height: 100,
                      width: 100,
                      child: CachedNetworkImage(
                        imageUrl: widget.img,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/default.jpg'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Package ID : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: ' ${widget.id}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                          Text.rich(TextSpan(
                              text: widget.delivery_type == "In Warehouse"
                                  ? 'Recipient Name : '
                                  : 'Sender Name : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: ' ${widget.name}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                          Text.rich(TextSpan(
                              text: widget.delivery_type == "In Warehouse"
                                  ? 'Recipient username : '
                                  : 'Sender username : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.username,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                          Text.rich(TextSpan(
                              text: "Package Size: ",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.packageType,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                          Text.rich(TextSpan(
                              text: 'Phone Number: ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${widget.phone}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 3,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(
                            text: 'Who Will Pay: ',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: ' ${widget.whoWillPay}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              )
                            ])),
                        Text.rich(TextSpan(
                            text: 'Total Delivery Price: ',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: widget.showDeliveryPrice
                                    ? '${widget.delivered_price.toStringAsFixed(2)}\$'
                                    : '--',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              )
                            ])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: primarycolor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.phone),
                            color: Colors.white,
                            onPressed: () async {
                              launch('tel:${widget.phone}');
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: primarycolor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.my_location),
                            color: Colors.white,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              27.0), // Adjust the radius as needed
                                        ),
                                        title: Text("Location Description"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(widget.locationDescription[0]),
                                            Text(widget.locationDescription[1]),
                                            Text(widget.locationDescription[2]),
                                            Text(widget.locationDescription[3]),
                                          ],
                                        ),
                                        titleTextStyle: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                        contentTextStyle: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        backgroundColor: primarycolor,
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              "Ok",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "View in map",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MapModalBottomSheet(
                                                              lat: widget.lat,
                                                              long: widget
                                                                  .long)));
                                            },
                                          ),
                                        ],
                                      ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 3,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        color: primarycolor,
                        child: Text(
                          "Accept",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        onPressed: () {
                          AcceptPreparePackageDriver();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        color: Colors.red,
                        child: Text(
                          "Reject",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        onPressed: () {
                          showDialog(
                              context: widget.context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    // Customize the border color
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          if (formGlobalKey.currentState!
                                              .validate()) {
                                            formGlobalKey.currentState!.save();
                                            Navigator.of(context).pop();
                                            print(widget.reason);
                                            RejectPreparePackageDriver();
                                          }
                                        },
                                        child: Text(
                                          "Reject Package",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )),
                                  ],
                                  title: Text("Reject Package"),
                                  content: Form(
                                    key: formGlobalKey,
                                    child: TextFormField(
                                      onSaved: (newValue) {
                                        widget.reason = newValue!;
                                      },
                                      maxLines: 5,
                                      validator: (val) {
                                        if (val!.isEmpty)
                                          return "Please Enter Reason";
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade400)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.red, width: 2)),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2)),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Enter the Reason'),
                                    ),
                                  ),
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
        ),
      ),
    );
  }
}
