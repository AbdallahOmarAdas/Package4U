import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/customer/set_location.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_application_1/style/header/header.dart';
import 'package:flutter_application_1/style/showDialogShared/show_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:searchfield/searchfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class DataItem {
  final String name;
  // final String description;
  final String img;

  DataItem({
    required this.img,
    required this.name,
    // required this.description,
    // required this.price,
  });
}

class add_parcel extends StatefulWidget {
  final String title;
  final String name;
  final String rec_userName;
  final int phone;
  final int packageId;
  final String email;
  final int price;
  final double distance;
  final String accountSelectedValue;
  final String paySelectedValue;
  final String shipping; //1 doc, 2 package
  final int package_size; //0 small , 1 meduim ,2 large
  final String shippingfrom;
  final String shippingto;
  final int delv_price;
  final double total_price;
  final double latfrom;
  final double longfrom;
  final double latto;
  final double longto;

  add_parcel({
    Key? key,
    required this.title,
    this.packageId = 0,
    this.rec_userName = '',
    this.name = '',
    this.phone = 0,
    this.distance = 0,
    this.email = '',
    this.price = 0,
    this.accountSelectedValue = "Have",
    this.paySelectedValue = "The recipient",
    this.shipping = "Document",
    this.shippingfrom = '',
    this.shippingto = '',
    this.delv_price = 0,
    this.total_price = 0,
    this.package_size = 0,
    this.latfrom = 0,
    this.longfrom = 0,
    this.latto = 0,
    this.longto = 0,
  }) : super(key: key);

  @override
  State<add_parcel> createState() => _add_parcelState();
}

class _add_parcelState extends State<add_parcel> {
  late double latfrom = 0;
  late double longfrom;
  late double latto = 0;
  late double longto;
  late double distance = 0;
  String? userName;
  double openingPrice = 5;
  double totalPrice = 0;
  double boxSizePrice = 0;
  double pricePerKm = 1.5;
  double bigPackagePrice = 4;
  String? rec_name;
  String? payment_method;
  String? rec_phone;
  String? rec_email;
  String? locationFromInfo;
  String? locationToInfo;
  String? package_price;
  String textFromChild = '';
  double distancePrice = 0;
  GlobalKey<FormState> formState5 = GlobalKey();
  TextEditingController _textController = TextEditingController();
  TextEditingController myController = TextEditingController();
  TextEditingController _textController2 = TextEditingController();
  TextEditingController _textControllerName = TextEditingController();
  TextEditingController _textControllerphone = TextEditingController();
  TextEditingController _textControllerRec_userName = TextEditingController();
  String selectedUserName = "";
  int discount = 0;
  String shippingType = "Document";
  String paySelectedValue = "The recipient";
  String accountSelectedValue = "Have";
  int selectedIdx = 0;
  List<dynamic> suggestions = [];
  List payment = [
    'Card',
    'Paypal',
    'Cash delivery',
  ];
  late int selectedValue;
  @override
  void initState() {
    super.initState();
    calculatePackageSizeprice();
    userName = GetStorage().read('userName');
    fetchData();

    totalPrice = openingPrice;
    if (widget.title == "Edit Package") {
      accountSelectedValue = widget.accountSelectedValue;
      paySelectedValue = widget.paySelectedValue;
      distance = widget.distance;
      totalPrice = widget.total_price;
      longto = widget.longto;
      latto = widget.latto;
      longfrom = widget.longfrom;
      latfrom = widget.latfrom;
      rec_email = widget.email;
      package_price = widget.price.toString();
      _textControllerRec_userName.text =
          widget.rec_userName == "null" ? '' : widget.rec_userName;
      selectedUserName =
          widget.rec_userName == "null" ? '' : widget.rec_userName;
    }
    // = widget.accountSelectedValue == "Have" ? "Document" : widget.shipping;
    shippingType = widget.shipping == "Document" ? "Document" : widget.shipping;
    selectedIdx = widget.package_size == 0 ? 0 : widget.package_size;
    _textController = TextEditingController(
      text: widget.shippingto != '' ? widget.shippingto : null,
    );
    _textController2 = TextEditingController(
      text: widget.shippingfrom != '' ? widget.shippingfrom : null,
    );
    _textControllerName.text = widget.name != '' ? widget.name : '';
    _textControllerphone.text =
        widget.phone != 0 ? "0" + widget.phone.toString() : "";
    calculatePackageSizeprice();
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

  Future<void> fetchData() async {
    var url =
        urlStarter + "/users/showCustomers?userName=" + userName.toString();
    final response = await http.get(Uri.parse(url));
    List<dynamic> sug = [];
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      sug.clear();
      for (var item in data['users']) {
        print(item);
        sug.add(item);
      }
      setState(() {
        suggestions = sug;
        openingPrice = data['cost']['openingPrice'] + 0.0;
        bigPackagePrice = data['cost']['bigPackagePrice'] + 0.0;
        pricePerKm = data['cost']['pricePerKm'] + 0.0;
        discount = data['cost']['discount'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  String customerUserName = GetStorage().read('userName');
  String customerPassword = GetStorage().read('password');

  Future postSendPackageEmail(String endPoint, String doneMsg) async {
    var url = urlStarter + endPoint;
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "customerUserName": customerUserName,
          "customerPassword": customerPassword,
          "recName": rec_name,
          "recEmail": rec_email,
          "phoneNumber": rec_phone,
          "packagePrice": package_price,
          "shippingType": shippingType + selectedIdx.toString(),
          "whoWillPay": paySelectedValue == "The recipient"
              ? paySelectedValue
              : "The sender",
          "distance": distance,
          "latTo": latto,
          "longTo": longto,
          "latFrom": latfrom,
          "longFrom": longfrom,
          "locationFromInfo": locationFromInfo,
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
    if (responceBody['message'] == "done") {
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().alartDialogPushNamed(
                "Done!", doneMsg, context, GetStorage().read("userType"));
          });
    }

    return responceBody;
  }

  Future postSendPackageUser(String endPoint, String doneMsg) async {
    var url = urlStarter + endPoint;
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "customerUserName": customerUserName,
          "customerPassword": customerPassword,
          "rec_userName": selectedUserName,
          "recName": rec_name,
          "recEmail": rec_email,
          "phoneNumber": rec_phone,
          "packagePrice": package_price,
          "shippingType": shippingType + selectedIdx.toString(),
          "whoWillPay": paySelectedValue == "The recipient"
              ? paySelectedValue
              : "The sender",
          "distance": distance,
          "latTo": latto,
          "longTo": longto,
          "latFrom": latfrom,
          "longFrom": longfrom,
          "locationFromInfo": locationFromInfo,
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
    if (responceBody['message'] == "done") {
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().alartDialogPushNamed(
                "Done!", doneMsg, context, GetStorage().read("userType"));
          });
    }

    return responceBody;
  }

  Future<double> calculateDistance(
      double fromLat, double fromLong, double toLat, double toLong) async {
    return await Geolocator.distanceBetween(fromLat, fromLong, toLat, toLong) /
        1000;
  }

  List<DataItem> items = [
    DataItem(name: 'Small Package', img: "assets/small.jpeg"),
    DataItem(name: 'Meduim Package', img: "assets/meduim.jpeg"),
    DataItem(name: 'Large Package', img: "assets/large.jpeg"),
  ];
  @override
  Widget build(BuildContext context) {
    final focus = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: primarycolor,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 110,
            child: HeaderWidget(110),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Form(
                key: formState5,
                child: Column(
                  children: [
                    // SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Does the recipient have a Package4u account?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: primarycolor,
                          value: "Have",
                          groupValue: accountSelectedValue,
                          onChanged: (value) {
                            setState(() {
                              accountSelectedValue = value.toString();
                            });
                          },
                        ),
                        Text("Have"),
                        SizedBox(
                          width: 10,
                        ),
                        Radio(
                          activeColor: primarycolor,
                          value: "Doesn't have",
                          groupValue: accountSelectedValue,
                          onChanged: (value) {
                            setState(() {
                              accountSelectedValue = value.toString();
                            });
                          },
                        ),
                        Text("Doesn't have"),
                      ],
                    ),
                    Visibility(
                      visible: accountSelectedValue == "Have",
                      child: SearchField(
                        controller: _textControllerRec_userName,
                        onSearchTextChanged: (query) {
                          if (!query.isEmpty) {
                            final filter = suggestions
                                .where((element) => element['userName']
                                    .toLowerCase()
                                    .startsWith(query.toLowerCase()))
                                .toList();
                            return filter
                                .map((e) => SearchFieldListItem<String>(
                                    e['userName'].toString(),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(e['userName'].toString(),
                                          style: TextStyle(fontSize: 16)),
                                    )))
                                .toList();
                          }
                          return null;
                        },
                        validator: (value) {
                          if (value!.isEmpty)
                            return "please enter the recipient's username";
                          return null;
                        },
                        onSaved: (newValue) {
                          print(newValue);
                        },
                        scrollbarDecoration: ScrollbarDecoration(),
                        searchInputDecoration: theme_helper().text_form_style(
                            "The recipient's username",
                            "Enter The recipient's username",
                            Icons.person_outline_sharp),
                        itemHeight: 50,
                        suggestions: []
                            .map((e) => SearchFieldListItem<String>(e,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child:
                                      Text(e, style: TextStyle(fontSize: 16)),
                                )))
                            .toList(),
                        suggestionState: Suggestion.hidden,
                        focusNode: focus,
                        onSuggestionTap: (SearchFieldListItem<String> x) {
                          setState(() {
                            focus.unfocus();
                            selectedUserName = x.searchKey;
                            final filter = suggestions
                                .where((element) => element['userName']
                                    .toLowerCase()
                                    .startsWith(selectedUserName.toLowerCase()))
                                .toList();
                            rec_name =
                                filter[0]['Fname'] + " " + filter[0]['Lname'];
                            rec_phone =
                                "0" + filter[0]['phoneNumber'].toString();
                            _textControllerphone.text = rec_phone.toString();
                            _textControllerName.text = rec_name.toString();
                            rec_email = filter[0]['email'];
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _textControllerName,
                      //initialValue: widget.name != '' ? widget.name : null,
                      decoration: theme_helper().text_form_style(
                          "The recipient's name",
                          "Enter The recipient's name",
                          Icons.abc),
                      validator: (value) {
                        if (value!.isEmpty) return "The recipient's name";
                        return null;
                      },
                      onSaved: (newValue) {
                        rec_name = newValue;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _textControllerphone,
                      //initialValue: widget.phone != '' ? widget.phone : null,
                      keyboardType: TextInputType.phone,
                      decoration: theme_helper().text_form_style(
                          "The recipient's Phone",
                          "Enter The recipient's phone",
                          Icons.phone),
                      validator: (value) {
                        String res = isValidPhone(value.toString());
                        if (!res.isEmpty) {
                          return res;
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        rec_phone = newValue;
                      },
                    ),
                    Visibility(
                      visible: accountSelectedValue == "Doesn't have",
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          TextFormField(
                            initialValue: rec_email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: theme_helper().text_form_style(
                                "The recipient's email",
                                "Enter The recipient's email",
                                Icons.email),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter recipient's email";
                              }
                              if (!isValidEmail(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              rec_email = newValue;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: package_price,
                      keyboardType: TextInputType.phone,
                      decoration: theme_helper().text_form_style(
                          "package price(or enter 0 if payment done)",
                          "Enter The package price",
                          Icons.price_change),
                      validator: (value) {
                        if (value!.isEmpty) return "The package price";
                        return null;
                      },
                      onSaved: (newValue) {
                        package_price = newValue;
                      },
                    ),
                    SizedBox(height: 10),
                    // DropdownButtonFormField(
                    //   isExpanded: true,
                    //   hint: Text('Choose payment method',
                    //       style: TextStyle(color: Colors.grey)),
                    //   items: payment.map((value) {
                    //     return DropdownMenuItem(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    //   value: payment_method,
                    //   decoration: theme_helper().text_form_style(
                    //     '',
                    //     '',
                    //     Icons.location_city,
                    //   ),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       payment_method = value as String?;
                    //       print(payment_method);
                    //     });
                    //   },
                    //   validator: (value) {
                    //     if (value == null) {
                    //       return "Please select payment method";
                    //     }
                    //   },
                    // ),
                    // SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Who will pay the delivery costs?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: primarycolor,
                          value: "The recipient",
                          groupValue: paySelectedValue,
                          onChanged: (value) {
                            setState(() {
                              paySelectedValue = value.toString();
                            });
                          },
                        ),
                        Text("The recipient"),
                        SizedBox(
                          width: 10,
                        ),
                        Radio(
                          activeColor: primarycolor,
                          value: "I'll pay",
                          groupValue: paySelectedValue,
                          onChanged: (value) {
                            setState(() {
                              paySelectedValue = value.toString();
                            });
                          },
                        ),
                        Text("I'll pay"),
                      ],
                    ),
                    SizedBox(height: 10),
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
                                print('${items[index].name}');
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
                      onSaved: (val) {
                        locationFromInfo = val;
                      },
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
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2)),
                      ),
                    ),
                    TextFormField(
                      controller: _textController2,
                      style: TextStyle(fontSize: 12.0),
                      validator: (val) {
                        if (val!.isEmpty)
                          return 'Please set location shipping to';
                        return null;
                      },
                      readOnly: true,
                      onSaved: (val) {
                        locationToInfo = val;
                      },
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => set_location(
                                    onDataReceived: getlocationto))));
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
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2)),
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
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
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
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                )
                              : Text(
                                  '---',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                            Text('${discount}%',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Price:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
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
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        color: primarycolor,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            "Save Package",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          if (formState5.currentState!.validate()) {
                            formState5.currentState!.save();
                            if (widget.title == "Edit Package") {
                              print("Edit Package");
                              if (accountSelectedValue == "Have") {
                                print("have");
                                postSendPackageUser(
                                    "/customer/editPackageUser?packageId=" +
                                        widget.packageId.toString(),
                                    "The package is edited successfully");
                              } else {
                                postSendPackageEmail(
                                    "/customer/editPackageEmail?packageId=" +
                                        widget.packageId.toString(),
                                    "The package is edited successfully");
                              }
                            } else {
                              if (accountSelectedValue == "Have") {
                                print("have");
                                postSendPackageUser("/customer/sendPackageUser",
                                    "The package is created successfully, now it is in review status you can edit it");
                              } else {
                                postSendPackageEmail(
                                    "/customer/sendPackageEmail",
                                    "The package is created successfully, now it is in review status you can edit it");
                              }
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )),
          )
        ]),
      ),
    );
  }
}
