import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:Package4U/customer/set_location.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:Package4U/style/header/header.dart';
import 'package:Package4U/style/showDialogShared/show_dialog.dart';
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
  final String FromCity;
  final String ToCity;

  add_parcel({
    Key? key,
    required this.title,
    this.packageId = 0,
    this.rec_userName = '',
    this.name = '',
    this.phone = 0,
    this.distance = 0,
    this.email = '',
    this.FromCity = '',
    this.ToCity = '',
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
  late double longto = 0;
  double distance = 0;
  String? userName;
  double openingPrice = 5;
  double totalPrice = 0;
  double boxSizePrice = 0;
  double pricePerKm = 1.5;
  double bigPackagePrice = 4;
  String? rec_name;
  String? rec_userName = "";
  String? payment_method;
  String? rec_phone;
  String? rec_email;
  String? locationFromInfo;
  String? locationToInfo;
  String? package_price;
  String textFromChild = '';
  double distancePrice = 0;
  String? fromcity;
  String? tocity;
  GlobalKey<FormState> formState5 = GlobalKey();
  TextEditingController _textController = TextEditingController();
  TextEditingController myController = TextEditingController();
  TextEditingController _textController2 = TextEditingController();
  TextEditingController _textControllerName = TextEditingController();
  TextEditingController _textControllerphone = TextEditingController();
  //TextEditingController _textControllerRec_userName = TextEditingController();
  TextEditingController _textControllerEmail = TextEditingController();
  String selectedName = "";
  int discount = 0;
  String shippingType = "Document";
  String paySelectedValue = "The recipient";
  String accountSelectedValue = "Have";
  int selectedIdx = 0;
  List<dynamic> suggestions = [];
  List Locations = [];
  bool isSetLocationAllow = false;
  List payment = [
    'Card',
    'Paypal',
    'Cash delivery',
  ];
  List citylist = [
    'Nablus',
    'Tulkarm',
    'Ramallah',
    'Jenin',
    'Qalqilya',
    'Salfit',
    'Hebron'
  ];
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    calculatePackageSizeprice();

    fetchLocations();

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
      _textControllerEmail.text = widget.email;
      package_price = widget.price.toString();
      _textControllerName.text = widget.name == "null" ? '' : widget.name;
      selectedName = widget.name == "null" ? '' : widget.name;
      rec_userName = widget.rec_userName == "null" ? '' : widget.rec_userName;
      tocity = widget.ToCity;
      fromcity = widget.FromCity;
    }
    // = widget.accountSelectedValue == "Have" ? "Document" : widget.shipping;
    shippingType = widget.shipping == "Document" ? "Document" : widget.shipping;
    selectedIdx = widget.package_size == 0 ? 0 : widget.package_size;
    _textController2 = TextEditingController(
      text: widget.shippingto != '' ? widget.shippingto : null,
    );
    _textController = TextEditingController(
      text: widget.shippingfrom != '' ? widget.shippingfrom : null,
    );
    _textControllerName.text = widget.name != '' ? widget.name : '';
    _textControllerphone.text =
        widget.phone != 0 ? "0" + widget.phone.toString() : "";
    calculatePackageSizeprice();
    calaulateTotalPrice();
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

  void reCalculateDistance(
      double latFrom, double longFrom, double latTo, double longTo) async {
    if (latTo != 0 && longTo != 0) {
      distance = await calculateDistance(latFrom, longFrom, latTo, longTo);
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

  Future postSendPackageUser(String endPoint, String doneMsg) async {
    var url = urlStarter + endPoint;
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "customerUserName": customerUserName,
          "customerPassword": customerPassword,
          "rec_userName": rec_userName,
          "recName": selectedName,
          "recEmail": rec_email,
          "phoneNumber": rec_phone,
          "packagePrice": package_price,
          "shippingType": shippingType + selectedIdx.toString(),
          "whoWillPay": paySelectedValue,
          "distance": distance,
          "latTo": latto,
          "longTo": longto,
          "latFrom": latfrom,
          "longFrom": longfrom,
          "locationFromInfo": locationFromInfo,
          "locationToInfo": locationToInfo,
          "toCity": tocity,
          "fromCity": fromcity
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

  Future<void> fetchLocations() async {
    var url =
        urlStarter + "/customer/getMyLocations?userName=" + customerUserName;
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
                    SizedBox(height: 10),
                    Visibility(
                      visible: true,
                      child: SearchField(
                        controller: _textControllerName,
                        onSearchTextChanged: (query) {
                          rec_userName = '';
                          if (!query.isEmpty) {
                            final filter = suggestions
                                .where((element) => element['Fname']
                                    .toLowerCase()
                                    .startsWith(query.toLowerCase()))
                                .toList();
                            return filter
                                .map((e) => SearchFieldListItem<String>(
                                    e['userName'].toString(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ListTile(
                                        title: Text(e['Fname'] +
                                            " " +
                                            e['Lname'].toString()),
                                        trailing:
                                            Text(e['userName'].toString()),
                                      ),
                                    )))
                                .toList();
                          }
                          return null;
                        },
                        validator: (value) {
                          if (value!.isEmpty)
                            return "please enter the recipient's name";
                          return null;
                        },
                        onSaved: (newValue) {
                          selectedName = newValue.toString();
                          print(newValue);
                        },
                        scrollbarDecoration: ScrollbarDecoration(),
                        searchInputDecoration: theme_helper().text_form_style(
                            "The recipient's name",
                            "Enter The recipient's name",
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
                            selectedName = x.searchKey;
                            print(selectedName);
                            final filter = suggestions.where((element) {
                              return element['userName']
                                  .toLowerCase()
                                  .startsWith(selectedName.toLowerCase());
                            }).toList();
                            rec_name =
                                filter[0]['Fname'] + " " + filter[0]['Lname'];
                            rec_phone =
                                "0" + filter[0]['phoneNumber'].toString();
                            rec_email = filter[0]['email'];
                            selectedName = rec_name.toString();
                            _textControllerphone.text = rec_phone.toString();
                            _textControllerName.text = rec_name.toString();
                            _textControllerEmail.text = rec_email.toString();
                            rec_userName = filter[0]['userName'];
                            print(rec_userName);
                          });
                        },
                      ),
                    ),
                    // SizedBox(height: 10),
                    // TextFormField(
                    //   controller: _textControllerName,
                    //   decoration: theme_helper().text_form_style(
                    //       "The recipient's Username",
                    //       "Enter The recipient's Username",
                    //       Icons.abc),
                    //   validator: (value) {
                    //     if (value!.isEmpty) return "The recipient's Username";
                    //     return null;
                    //   },
                    //   onSaved: (newValue) {
                    //     rec_name = newValue;
                    //   },
                    // ),
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
                      visible: true, //accountSelectedValue == "Doesn't have",
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _textControllerEmail,
                            //initialValue: rec_email,
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
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
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
                          value: "The sender",
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
                                          image: AssetImage(
                                              items[index].img), // ),
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
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            value: fromcity,
                            isExpanded: true,
                            hint: Text('Shipping from city'),
                            validator: (value) {
                              if (value == null) {
                                return "Please select city";
                              }
                              return null;
                            },
                            decoration: theme_helper().text_form_style(
                              '',
                              '',
                              Icons.location_city,
                            ),
                            items: citylist.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                fromcity = (value as String?)!;
                                print(fromcity);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: DropdownButtonFormField(
                            value: tocity,
                            hint: Text('shipping to city'),
                            isExpanded: true,
                            items: citylist.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return "Please select city";
                              }
                              return null;
                            },
                            decoration: theme_helper().text_form_style(
                              '',
                              '',
                              Icons.location_city,
                            ),
                            onChanged: (value) {
                              setState(() {
                                tocity = (value as String?)!;
                                print(tocity);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField(
                      isExpanded: true,
                      hint: Text('Choose shipping from location',
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
                      value: payment_method,
                      decoration: theme_helper().text_form_style(
                        '',
                        '',
                        Icons.not_listed_location_outlined,
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (99999999 == value) {
                            isSetLocationAllow = true;
                          } else {
                            isSetLocationAllow = false;
                            Locations.map((value1) {
                              if (value == value1['id']) {
                                latfrom = value1['latTo'];
                                longfrom = value1['longTo'];
                                locationFromInfo = value1['location'];
                                _textController.text =
                                    locationFromInfo.toString();
                                reCalculateDistance(
                                    latfrom, longfrom, latto, longto);
                              }
                            }).toString();
                          }

                          print(isSetLocationAllow);
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please choose location";
                        }
                        return null;
                      },
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
                      enabled: isSetLocationAllow,
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
                              print("have");
                              postSendPackageUser(
                                  "/customer/editPackageUser?packageId=" +
                                      widget.packageId.toString(),
                                  "The package is edited successfully");
                            } else {
                              print("have");
                              postSendPackageUser("/customer/sendPackageUser",
                                  "The package is created successfully, now it is in review status you can edit it");
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
