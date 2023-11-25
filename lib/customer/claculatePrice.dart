import 'package:flutter/material.dart';
import 'package:flutter_application_1/customer/set_location.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataItem {
  final String name;
  final String img;

  DataItem({required this.img, required this.name});
}

List<DataItem> items = [
  DataItem(name: 'Small Package', img: "assets/small.jpeg"),
  DataItem(name: 'Meduim Package', img: "assets/meduim.jpeg"),
  DataItem(name: 'Large Package', img: "assets/large.jpeg"),
];

class calculatePrice extends StatefulWidget {
  const calculatePrice({super.key});

  @override
  State<calculatePrice> createState() => _calculatePriceState();
}

class _calculatePriceState extends State<calculatePrice> {
  String shippingType = "Document";
  int selectedIdx = 0;
  late double latfrom = 0;
  late double longfrom;
  late double latto = 0;
  late double longto;
  late double distance = 0;
  double openingPrice = 5;
  double totalPrice = 0;
  double boxSizePrice = 0;
  double pricePerKm = 1.5;
  double distancePrice = 0;
  double bigPackagePrice = 4;
  int discount = 0;
  TextEditingController _textController2 = TextEditingController();
  TextEditingController _textController = TextEditingController();
  GlobalKey<FormState> formState5 = GlobalKey();

  Future<void> fetchData() async {
    var url = urlStarter + "/users/cost";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        openingPrice = data['openingPrice'] + 0.0;
        bigPackagePrice = data['bigPackagePrice'] + 0.0;
        pricePerKm = data['pricePerKm'] + 0.0;
        discount = data['discount'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void calculatePackageSizeprice() {
    if (shippingType == "Package") {
      if (selectedIdx == 0) {
        boxSizePrice = 0;
      } else if (selectedIdx == 1) {
        boxSizePrice = bigPackagePrice / 2;
      } else {
        boxSizePrice = bigPackagePrice;
      }
    } else {
      boxSizePrice = 0;
    }
    setState(() {
      boxSizePrice;
    });
  }

  void calaulateTotalPrice() {
    calculatePackageSizeprice();
    distancePrice = (distance * pricePerKm);
    totalPrice = openingPrice + boxSizePrice + distancePrice;
    totalPrice *= (100 - discount) / 100.0;
    setState(() {
      totalPrice;
    });
  }

  Future<double> calculateDistance(
      double fromLat, double fromLong, double toLat, double toLong) async {
    return await Geolocator.distanceBetween(fromLat, fromLong, toLat, toLong) /
        1000;
  }

  void getlocationfrom(String text, double lat, double long) async {
    setState(() {
      String modifiedString = text.replaceAll("','", ",");
      _textController.text = modifiedString;
      latfrom = lat;
      longfrom = long;
    });
    if (latto != 0) {
      distance = await calculateDistance(latfrom, longfrom, latto, longto);
      setState(() {
        distance;
        calaulateTotalPrice();
      });
    }
  }

  void getlocationto(String text, double lat, double long) async {
    setState(() {
      String modifiedString = text.replaceAll("','", ",");
      _textController2.text = modifiedString;
      latto = lat;
      longto = long;
    });
    if (latfrom != 0) {
      distance = await calculateDistance(latfrom, longfrom, lat, long);
      setState(() {
        distance;
        calaulateTotalPrice();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Calculate Delivery Price'),
          backgroundColor: primarycolor,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formState5,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'What are you shipping ?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Radio(
                      activeColor: primarycolor,
                      value: "Document",
                      groupValue: shippingType,
                      onChanged: (value) {
                        setState(() {
                          shippingType = value.toString();
                          calaulateTotalPrice();
                        });
                      },
                    ),
                    Text('Document'),
                    SizedBox(
                      width: 10,
                    ),
                    Radio(
                      activeColor: primarycolor,
                      value: "Package",
                      groupValue: shippingType,
                      onChanged: (value) {
                        setState(() {
                          shippingType = value.toString();
                        });
                      },
                    ),
                    Text('Package'),
                  ],
                ),
                Visibility(
                  visible: shippingType == "Package",
                  child: Container(
                    height: 200.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIdx = index;
                              calaulateTotalPrice();
                            });
                            //print('${items[index].name}');
                          },
                          child: Card(
                            margin: EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: selectedIdx == index
                                    ? primarycolor
                                    : Colors.transparent,
                                width: 5.0,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Center(
                              child: Container(
                                width: 150,
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image(
                                      height: 140,
                                      image: AssetImage(items[index].img),
                                      // items[index].img,
                                      // style: TextStyle(
                                      //   color: Colors.black,
                                      // ),
                                    ),
                                    Text('${items[index].name}')
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _textController,
                  style: TextStyle(fontSize: 12.0),
                  validator: (val) {
                    if (val!.isEmpty)
                      return 'Please set location shipping from';
                    return null;
                  },
                  readOnly: true,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => set_location(
                                onDataReceived: getlocationfrom))));
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on, color: Colors.red),
                    hintText: 'Set Location Shipping From',
                    hintStyle: TextStyle(fontSize: 16.0),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                  ),
                ),
                TextFormField(
                  controller: _textController2,
                  style: TextStyle(fontSize: 12.0),
                  validator: (val) {
                    if (val!.isEmpty) return 'Please set location shipping to';
                    return null;
                  },
                  readOnly: true,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                set_location(onDataReceived: getlocationto))));
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on, color: Colors.red),
                    hintText: 'Set Location Shipping To',
                    hintStyle: TextStyle(fontSize: 16.0),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '+ Opening price:',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      Text(
                        openingPrice.toString() + '\$',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '+ Package size price:',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      Text(
                        boxSizePrice.toString() + '\$',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '   Delivery Price/Km:',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      Text(
                        // widget.delv_price != ''
                        //     ? '${widget.delv_price}\$'
                        //     : '1000\$'
                        pricePerKm.toStringAsFixed(2),
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '   Distance:',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      distance > 0
                          ? Text(
                              '${distance.toStringAsFixed(2)} km',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            )
                          : Text('---'),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '+ Distance delivery price:',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      distance > 0
                          ? Text(
                              '${distancePrice.toStringAsFixed(2)}\$',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            )
                          : Text(
                              '---',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                    ],
                  ),
                ),
                Visibility(
                  visible: discount > 0,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '% Discount:',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                        Text('${discount}%',
                            style: TextStyle(color: Colors.grey, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: primarycolor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.attach_money_sharp),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Total Price:  ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
                          ),
                        ],
                      ),
                      Text(
                        totalPrice.toStringAsFixed(2) + "\$",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
