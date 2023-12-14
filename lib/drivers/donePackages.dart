import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
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
    } else {
      throw Exception('Failed to load data');
    }
    return;
  }

  void _buildMy_deliverd_Orders() {
    for (int i = 0; i < deliverdList.length; i++) {
      int delivery_type = deliverdList[i]['status'] == "In Warehouse" ? 1 : 0;

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
            context: this.context,
            packageType: pktType,
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
            context: this.context,
            packageType: pktType,
          ),
        );
      }
    }
  }

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
            : Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: received_order,
                ),
              ),
        delivered_order.length == 0
            ? Center(
                child: Text(
                "You have not delivered any packages yet",
                style: TextStyle(fontSize: 20, color: primarycolor),
              ))
            : Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: delivered_order,
                ),
              ),
      ]),
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

  const content_delivered({
    super.key,
    required this.id,
    required this.name,
    required this.username,
    required this.context,
    required this.img,
    required this.delivered_price,
    required this.delivery_type,
    required this.packageType,
  });

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
                            visible: widget.delivery_type == 0,
                            child: Text.rich(TextSpan(
                                text: 'Delivery price : ',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text:
                                        '${widget.delivered_price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ])),
                          ),
                          SizedBox(height: 5),
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
