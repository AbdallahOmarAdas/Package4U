import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DonePackages extends StatefulWidget {
  const DonePackages({super.key});

  @override
  State<DonePackages> createState() => _DonePackagesState();
}

class _DonePackagesState extends State<DonePackages>
    with SingleTickerProviderStateMixin {
  late List<content_delivered> delivered_order = [];
  late List<content_delivered> received_order = [];
  late List<content_delivered> filterdReceived_order = [];
  late List<content_delivered> filterdDelivered_order = [];
  TabController? myControler;
  List<dynamic> deliverdList = [];
  var payment_type = 0;
  var package_type = 0;
  var id = 123123123;

  var name = "abdallah";
  @override
  void initState() {
    super.initState();
    myControler = new TabController(length: 2, vsync: this, initialIndex: 1);
    postGetDeliverd();
  }

  Future postGetDeliverd() async {
    var url = urlStarter + "/driver/getDeliverdDriver";
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
        _buildMy_deliverd_Orders();
      });
    } else if (response.statusCode == 404) {
      deliverdList = [];
      _buildMy_deliverd_Orders();
    } else {
      throw Exception('Failed to load data');
    }
    return;
  }

  void _buildMy_deliverd_Orders() {
    delivered_order = [];
    received_order = [];
    for (int i = 0; i < deliverdList.length; i++) {
      int delivery_type =
          deliverdList[i]['status'] == "Complete Receive" ? 1 : 0;

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
      if (delivery_type != 1) {
        delivered_order.add(
          content_delivered(
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
            whoWillPay: deliverdList[i]['whoWillPay'],
            context: this.context,
            packageType: pktType,
            showDeliveryPrice:
                deliverdList[i]['whoWillPay'] == "The recipient" ? true : false,
          ),
        );
      } else {
        received_order.add(
          content_delivered(
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
            whoWillPay: deliverdList[i]['whoWillPay'],
            context: this.context,
            packageType: pktType,
            showDeliveryPrice:
                deliverdList[i]['whoWillPay'] == "The sender" ? true : false,
          ),
        );
      }
    }
    filterdDelivered_order = delivered_order;
    filterdReceived_order = received_order;
  }

  TextEditingController _searchController = TextEditingController();
  String? searchText;
  String? filterBy = "Package Id";
  List<String> FilterBylist = ["Package Id", "Name", "Username", "Size"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete packages'),
        backgroundColor: primarycolor,
        bottom: TabBar(
            controller: myControler,
            indicatorWeight: 2,
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(
                text: "               Received                ",
                icon: Icon(Icons.call_received_sharp),
              ),
              Tab(
                text: "               Delivered               ",
                icon: Icon(Icons.call_made_sharp),
              )
            ]),
      ),
      body: TabBarView(controller: myControler, children: [
        received_order.length == 0
            ? Center(
                child: Text(
                "You have not received any package yet",
                style: TextStyle(fontSize: 20, color: primarycolor),
              ))
            : Column(children: [
                filter(received_order, 1),
                Expanded(
                  child: ListView(
                    children: filterdReceived_order,
                  ),
                )
              ]),
        delivered_order.length == 0
            ? Center(
                child: Text(
                "You have not delivered any packages yet",
                style: TextStyle(fontSize: 20, color: primarycolor),
              ))
            : Column(children: [
                filter(delivered_order, 0),
                Expanded(
                  child: ListView(
                    children: filterdDelivered_order,
                  ),
                )
              ])
      ]),
    );
  }

  Container filter(List<content_delivered> receive_order, int type) {
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
                //  List<String> FilterBylist = ["Package Id", "Name", "Username", "Size"];
                List<content_delivered> filterd;
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
                    filterdReceived_order = filterd;
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
                      filterdReceived_order = receive_order;
                    } else if (type == 0) {
                      filterdDelivered_order = delivered_order;
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

class content_delivered extends StatefulWidget {
  final int id;
  final String name;
  final String username;
  final String img;
  final double delivered_price;
  final int delivery_type; // 0 Delivery of a package , 1 Receiving a package
  final BuildContext context;
  final String packageType;
  final String whoWillPay;
  final bool showDeliveryPrice;

  const content_delivered(
      {super.key,
      required this.id,
      required this.name,
      required this.username,
      required this.context,
      required this.img,
      required this.delivered_price,
      required this.delivery_type,
      required this.packageType,
      required this.showDeliveryPrice,
      required this.whoWillPay});

  @override
  State<content_delivered> createState() => _content_deliveredState();
}

class _content_deliveredState extends State<content_delivered> {
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
                              text: widget.delivery_type == 0
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
                              text: widget.delivery_type == 0
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
                          Visibility(
                            visible: widget.showDeliveryPrice,
                            child: Text.rich(TextSpan(
                                text: 'Delivery price : ',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text:
                                        '${widget.delivered_price.toStringAsFixed(2)}\$',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ])),
                          ),
                          SizedBox(height: 5),
                          Visibility(
                            visible: widget.showDeliveryPrice,
                            child: Text.rich(TextSpan(
                                text: 'who paid: ',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '${widget.whoWillPay}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ])),
                          ),
                        ],
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
