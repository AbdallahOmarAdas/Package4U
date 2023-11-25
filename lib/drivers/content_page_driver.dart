import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';

class content_page_driver extends StatefulWidget {
  @override
  State<content_page_driver> createState() => _content_page_driverState();
}

class _content_page_driverState extends State<content_page_driver>
    with TickerProviderStateMixin {
  // int _currentIndex = 0;
  late TabController _tabController;
  late List<content_new> new_order;
  late List<content_ongoing> ongoing_order;
  late List<content_delivered> delivered_order;
  // String type_p = 'All Packages';

  // List type_package = [
  //   'All Packages',
  //   'Delivery Package',
  //   'Received Package',
  // ];

  Future<Position> onGetCurrentLocationPressed() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    } catch (e) {
      print('Exception while requesting location permission: $e');
    }

    Position p = await Geolocator.getCurrentPosition();

    return p;
  }

  @override
  void initState() {
    new_order = _buildMy_new_Orders();
    ongoing_order = _buildMy_ongoing_Orders();
    delivered_order = _buildMy_deliverd_Orders();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    //_tabController.addListener(_handleTabSelection);
  }

  // void _handleTabSelection() {
  //   setState(() {
  //     _currentIndex = _tabController.index;
  //   });
  // }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<content_new> _buildMy_new_Orders() {
    List<content_new> new_order = [];

    //Future<void> wait() async {
    for (int i = 1; i <= 5; i++) {
      new_order.add(
        content_new(
          package_type: i - 1,
          img: "assets/f3.png",
          name: 'Mohammad',
          payment_type: 'Cash',
          delivered_price: 25,
          id: 1234567382,
          price: 200,
          phone: '0599224532',
          from: 'nablus',
          to: 'tulkarm',
          context: this.context,
        ),
      );
    }
    //  }

    // wait();
    return new_order;
  }

/////////////
  List<content_ongoing> _buildMy_ongoing_Orders() {
    List<content_ongoing> ongoing_orders = [];
    Future<void> getlocation_and_distance() async {
      Position curruent = await onGetCurrentLocationPressed();

      Future<double> calc_distance(double lat, double lang) async {
        double Disstance = await Geolocator.distanceBetween(
                curruent.latitude, curruent.longitude, lat, lang) /
            1000;
        setState(() {
          ongoing_orders;
        });
        print(Disstance);
        return Disstance;
      }

      //  for (int i = 1; i <= 5; i++) {
      double oo = await calc_distance(31.974231, 35.262922);
      ongoing_orders.add(
        content_ongoing(
          late: 31.974231,
          lang: 35.262922,
          dist: oo,
          package_type: 1,
          img: "assets/f3.png",
          name: 'Mohammad',
          payment_type: 'Cash',
          delivered_price: 25,
          id: 1234567382,
          price: 200,
          phone: '0599224532',
          from: 'nablus',
          to: 'tulkarm',
          context: this.context,
        ),
      );

      double a = await calc_distance(32.139794, 35.287315);
      ongoing_orders.add(
        content_ongoing(
          late: 32.139794,
          lang: 35.287315,
          dist: a,
          package_type: 0,
          img: "assets/f3.png",
          name: 'Maram',
          payment_type: 'Cash',
          delivered_price: 25,
          id: 9878654663,
          price: 200,
          phone: '0599224532',
          from: 'nablus',
          to: 'tulkarm',
          context: this.context,
        ),
      );

      double f = await calc_distance(32.247584, 35.271168);
      ongoing_orders.add(
        content_ongoing(
          late: 32.247584,
          lang: 35.271168,
          dist: f,
          package_type: 1,
          img: "assets/f3.png",
          name: 'Ahmad',
          payment_type: 'Cash',
          delivered_price: 100,
          id: 32323433,
          price: 200,
          phone: '0599224532',
          from: 'nablus',
          to: 'tulkarm',
          context: this.context,
        ),
      );
      // }
    }

    getlocation_and_distance();

    return ongoing_orders;
  }

  List<content_delivered> _buildMy_deliverd_Orders() {
    List<content_delivered> deliverd_orders = [];

    for (int i = 1; i <= 10; i++) {
      deliverd_orders.add(
        content_delivered(
          package_type: i - 1,
          payment_type: "Cash",
          img: "assets/f3.png",
          name: 'Mohammad',
          delivered_price: 25,
          id: 1234567382,
          price: 200,
          phone: '0599224532',
          from: 'nablus',
          to: 'tulkarm',
          context: this.context,
        ),
      );
    }

    return deliverd_orders;
  }

  @override
  Widget build(BuildContext context) {
    ongoing_order.sort((a, b) => a.dist.compareTo(b.dist));

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25.0)),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                      color: primarycolor,
                      borderRadius: BorderRadius.circular(25.0)),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: 'New Orders',
                    ),
                    Tab(
                      text: 'On Going',
                    ),
                    Tab(
                      text: 'Delivered',
                    ),
                  ],
                ),
              ),
              // Visibility(
              //     visible: _currentIndex == 0,
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Container(
              //         //  alignment: ,
              //         height: 50,
              //         width: 250,
              //         child: DropdownButtonFormField(
              //           hint: Text('', style: TextStyle(color: Colors.grey)),
              //           items: type_package.map((value) {
              //             return DropdownMenuItem(
              //               value: value,
              //               child: Text(value),
              //             );
              //           }).toList(),
              //           value: type_p,
              //           decoration: theme_helper().text_form_style(
              //             '',
              //             '',
              //             null,
              //           ),
              //           onChanged: (value) {
              //             setState(() {
              //               type_p = (value as String?)!;
              //               print(type_p);
              //             });
              //           },
              //         ),
              //       ),
              //     )),
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: RefreshIndicator(
                      color: primarycolor,
                      onRefresh: () async {
                        await Future.delayed(Duration(milliseconds: 1000));
                        setState(() {
                          new_order;
                        });
                      },
                      child: ListView.builder(
                        itemCount: new_order.length,
                        itemBuilder: (context, index) {
                          return (new_order[index]);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: RefreshIndicator(
                      color: primarycolor,
                      onRefresh: () async {
                        await Future.delayed(Duration(milliseconds: 1000));
                        setState(() {
                          ongoing_order;
                        });
                      },
                      child: ListView.builder(
                        itemCount: ongoing_order.length,
                        itemBuilder: (context, index) {
                          return (ongoing_order[index]);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: delivered_order,
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class content_new extends StatefulWidget {
  final int id;
  late String reason;
  final String name;
  final String phone;
  final String img;
  final int price;
  final int delivered_price;
  final String from;
  final String to;
  final int package_type; // 0 Delivery of a package , 1 Receiving a package
  final String payment_type;
  final BuildContext context;

  content_new({
    super.key,
    required this.id,
    required this.phone,
    required this.price,
    required this.from,
    required this.to,
    required this.context,
    required this.payment_type,
    required this.delivered_price,
    required this.name,
    required this.img,
    required this.package_type,
    this.reason = '',
  });

  @override
  State<content_new> createState() => _content_newState();
}

class _content_newState extends State<content_new> {
  final formGlobalKey = GlobalKey<FormState>();

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
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/f3.png'))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Package Type : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.package_type == 0
                                      ? 'Package Delivery '
                                      : 'Package Received ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
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
                              text: widget.package_type == 0
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
                              text: 'Payment type : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${widget.payment_type}',
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
                    Text.rich(TextSpan(
                        text: 'Order Price: ',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: ' ${widget.price}\$',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                            ),
                          )
                        ])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                primarycolor, // Set the background color here
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: IconButton(
                            //onPressed: () => _makePhoneCall(phone),
                            icon: Icon(Icons.phone),
                            color: Colors.white,
                            onPressed: () async {
                              //setState(() {
                              launch('tel:${widget.phone}');

                              //});
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color:
                                primarycolor, // Set the background color here
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: IconButton(
                            //onPressed: () => _makePhoneCall(phone),
                            icon: Icon(Icons.my_location),
                            color: Colors.white,

                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MapModalBottomSheet()));
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
                        onPressed: () {},
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

///////////////////////
class content_ongoing extends StatefulWidget {
  final int id;
  final double late;
  final double lang;
  final int package_type;
  final String name;
  final String phone;
  final String img;
  final int price;
  final double dist;
  final int delivered_price;
  final String from;
  final String to;
  final String payment_type;
  final BuildContext context;

  const content_ongoing(
      {super.key,
      required this.id,
      required this.name,
      required this.phone,
      required this.price,
      required this.from,
      required this.to,
      required this.context,
      required this.img,
      required this.dist,
      required this.delivered_price,
      required this.payment_type,
      required this.package_type,
      required this.late,
      required this.lang});

  @override
  State<content_ongoing> createState() => _content_ongoingState();
}

class _content_ongoingState extends State<content_ongoing> {
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
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/f3.png'))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Package Type : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.package_type == 0
                                      ? 'Package Delivery '
                                      : 'Package Received ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
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
                              text: widget.package_type == 0
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
                              text: 'Payment type : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${widget.payment_type}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                          Text.rich(TextSpan(
                              text: 'Distance : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${widget.dist.toStringAsFixed(2)} Km',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        color: primarycolor,
                        child: Text(
                          "Start",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => map_(
                                        phone: widget.phone,
                                        id: widget.id,
                                        langto: widget.lang,
                                        Lateto: widget.late,
                                        name: widget.name,
                                        package_type: widget.package_type,
                                        payment_type: widget.payment_type,
                                        del_price: widget.delivered_price,
                                        price: widget.price,
                                      )));
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
                          "End",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        onPressed: () {},
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

///////////////////
class content_delivered extends StatefulWidget {
  final int id;
  final String name;
  final String phone;
  final String img;
  final int price;
  final int delivered_price;
  final String from;
  final String to;
  final int package_type; // 0 Delivery of a package , 1 Receiving a package
  final String payment_type;
  final BuildContext context;

  const content_delivered({
    super.key,
    required this.id,
    required this.name,
    required this.phone,
    required this.price,
    required this.from,
    required this.to,
    required this.context,
    required this.img,
    required this.delivered_price,
    required this.package_type,
    required this.payment_type,
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
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/f3.png'))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Package Type : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.package_type == 0
                                      ? 'Package Delivery '
                                      : 'Package Received ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
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
                              text: widget.package_type == 0
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
                              text: 'Payment type : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${widget.payment_type}',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////
class MapModalBottomSheet extends StatefulWidget {
  @override
  _MapModalBottomSheetState createState() => _MapModalBottomSheetState();
}

class _MapModalBottomSheetState extends State<MapModalBottomSheet> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text('Package Address'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: (controller) {
          // ظظsetState(() {
          mapController = controller;
          // });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(32.222668, 35.262146),
          zoom: 10.0,
        ),
        markers: <Marker>[
          Marker(
            markerId: MarkerId('Your Marker ID'),
            position: LatLng(32.222668, 35.262146),
            infoWindow: InfoWindow(
              title: 'Address',
              snippet: 'Your Marker Snippet',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(50),
          ),
        ].toSet(),
      ),
    );
  }
}

class map_ extends StatefulWidget {
  @override
  final double Lateto;
  final double langto;
  final int package_type;
  final String name;
  final int id;
  final String payment_type;
  final int price;
  final int del_price;
  final String phone;

  map_(
      {required this.Lateto,
      required this.langto,
      required this.id,
      required this.name,
      required this.package_type,
      required this.payment_type,
      required this.price,
      required this.del_price,
      required this.phone});

  State<map_> createState() => _map_State();
  //set_location({required this.onDataReceived});
  //_getPolyline
}

class _map_State extends State<map_> {
  late double Lateto;
  late double langto;
  late int package_type;
  late String name;
  late int id;
  late String payment_type;
  late int price;
  late int del_price;
  late String phone;

  @override
  void initState() {
    langto = widget.langto;
    Lateto = widget.Lateto;
    package_type = widget.package_type;
    name = widget.name;
    id = widget.id;
    payment_type = widget.payment_type;
    price = widget.price;
    del_price = widget.del_price;
    phone = widget.phone;
    super.initState();

    _addMarker(
        LatLng(32.204059, 35.288683), "origin", BitmapDescriptor.defaultMarker);
    // destination marker
    _addMarker(LatLng(Lateto, langto), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));

    //_getPolyline();
  }

  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyB9ipQehNyA6U_SXPLcwTq0x201dcJxKoQ";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text('Package Address'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(Lateto, langto),
              zoom: 12.0,
            ),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            //polylines: Set<Polyline>.of(polylines.values),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: Container(
              height: 320,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/f3.png'))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(TextSpan(
                                    text: 'Package Type : ',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: package_type == 0
                                            ? 'Package Delivery '
                                            : 'Package Received ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ])),
                                SizedBox(height: 5),
                                Text.rich(TextSpan(
                                    text: 'Package ID : ',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: ' ${id}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ])),
                                SizedBox(height: 5),
                                Text.rich(TextSpan(
                                    text: package_type == 0
                                        ? 'Recipient Name : '
                                        : 'Sender Name : ',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: ' ${name}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ])),
                                SizedBox(height: 5),
                                Text.rich(TextSpan(
                                    text: 'Payment type : ',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: '${payment_type}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ])),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                        color: primarycolor,
                                        child: Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          launch('tel:${phone}');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Expanded(
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //           color:
                                //               primarycolor, // Set the background color here
                                //           borderRadius:
                                //               BorderRadius.circular(30.0),
                                //         ),
                                //         child: IconButton(
                                //           //onPressed: () => _makePhoneCall(phone),
                                //           icon: Icon(Icons.phone),
                                //           color: Colors.white,
                                //           onPressed: () async {
                                //             //setState(() {
                                //             launch('tel:${phone}');

                                //             //});
                                //           },
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Cost : ',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            '${del_price} \$',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Item Cost : ',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            '${price} \$',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Total Cost : ',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${del_price + price} \$',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                                color: primarycolor,
                                child: Text(
                                  "Start Navigation",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  _openGoogleMaps(Lateto, langto);
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) async {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        infoWindow: InfoWindow(title: id),
        icon: descriptor,
        position: position);
    markers[markerId] = marker;
  }

  // _getPolyline() async {
  //   polylineCoordinates.add(LatLng(32.204059, 35.288683));
  //   polylineCoordinates.add(LatLng(32.141870, 35.286622));

  //   _addPolyLine();
  // }

  // _addPolyLine() async {
  //   PolylineId id = PolylineId("poly");
  //   Polyline polyline = Polyline(
  //       polylineId: id,
  //       color: Colors.red,
  //       points: polylineCoordinates,
  //       width: 1);
  //   setState(() {
  //     polylines[id] = polyline;
  //   });
  // }

  void _openGoogleMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      // Launch the URL
      await launch(url);
    } else {
      // Handle the case where the URL can't be launched
      throw 'Could not launch $url';
    }
  }
}
