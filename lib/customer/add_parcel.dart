import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/customer/set_location.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:geolocator/geolocator.dart';

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
  final String phone;
  final String email;
  final int price;
  final int shipping; //1 doc, 2 package
  final int package_size; //0 small , 1 meduim ,2 large
  final String shippingfrom;
  final String shippingto;
  final int delv_price;
  final int total_price;

  add_parcel({
    Key? key,
    required this.title,
    this.name = '',
    this.phone = '',
    this.email = '',
    this.price = 0,
    this.shipping = 0,
    this.shippingfrom = '',
    this.shippingto = '',
    this.delv_price = 0,
    this.total_price = 0,
    this.package_size = 0,
  }) : super(key: key);

  @override
  State<add_parcel> createState() => _add_parcelState();
}

class _add_parcelState extends State<add_parcel> {
  late double latfrom;
  late double longfrom;
  late double latto = 0;
  late double longto;
  late double distance = 0;
  String? rec_name;
  String? payment_method;
  String? rec_phone;
  String? rec_email;
  String? package_price;
  String textFromChild = '';
  GlobalKey<FormState> formState5 = GlobalKey();
  TextEditingController _textController = TextEditingController();
  TextEditingController _textController2 = TextEditingController();
  late int selectedValue;
  late int selectedIdx;
  @override
  void initState() {
    super.initState();
    selectedValue = widget.shipping == 0 ? 1 : widget.shipping;
    selectedIdx = widget.package_size == 0 ? 0 : widget.package_size;
    _textController = TextEditingController(
      text: widget.shippingto != '' ? widget.shippingto : null,
    );
    _textController2 = TextEditingController(
      text: widget.shippingfrom != '' ? widget.shippingfrom : null,
    );
  }

  List payment = [
    'Card',
    'Paypal',
    'Cash delivery',
  ];
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
    distance = await calculateDistance(latfrom, longfrom, lat, long);
    setState(() {
      distance;
    });
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

    //DataItem(name: 'Item 5', img: 'Description 2'),
    // Add more items as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: primarycolor,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Form(
                key: formState5,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: widget.name != '' ? widget.name : null,
                      decoration: theme_helper().text_form_style(
                          "The recipient's name",
                          "Enter The recipient's name",
                          Icons.receipt_long),
                      validator: (value) {
                        if (value!.isEmpty) return "The recipient's name";
                      },
                      onSaved: (newValue) {
                        rec_name = newValue;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: widget.phone != '' ? widget.phone : null,
                      keyboardType: TextInputType.phone,
                      decoration: theme_helper().text_form_style(
                          "The recipient's Phone",
                          "Enter The recipient's phone",
                          Icons.phone),
                      validator: (value) {
                        if (value!.isEmpty) return "The recipient's phone";
                      },
                      onSaved: (newValue) {
                        rec_phone = newValue;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: widget.email != '' ? widget.email : null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: theme_helper().text_form_style(
                          "The recipient's email",
                          "Enter The recipient's email",
                          Icons.email),
                      validator: (value) {
                        if (value!.isEmpty) return "The recipient's email";
                      },
                      onSaved: (newValue) {
                        rec_email = newValue;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: widget.phone != 0 ? widget.phone : null,
                      keyboardType: TextInputType.phone,
                      decoration: theme_helper().text_form_style(
                          "package price(or enter 0 if payment done)",
                          "Enter The package price",
                          Icons.price_change),
                      validator: (value) {
                        if (value!.isEmpty) return "The package price";
                      },
                      onSaved: (newValue) {
                        package_price = newValue;
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField(
                      isExpanded: true,
                      hint: Text('Choose payment method',
                          style: TextStyle(color: Colors.grey)),
                      items: payment.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: payment_method,
                      decoration: theme_helper().text_form_style(
                        '',
                        '',
                        Icons.location_city,
                      ),
                      onChanged: (value) {
                        setState(() {
                          payment_method = value as String?;
                          print(payment_method);
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please select payment method";
                        }
                      },
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
                          value: 1,
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                        Text('Document'),
                        SizedBox(
                          width: 10,
                        ),
                        Radio(
                          activeColor: primarycolor,
                          value: 2,
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                        Text('Package'),
                      ],
                    ),
                    Visibility(
                      visible: selectedValue == 2,
                      child: Container(
                        height: 200.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                // Handle press for the specific item
                                setState(() {
                                  selectedIdx = index;
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
                                    width:
                                        5.0, // Adjust the border width as needed
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
                      },
                      readOnly: true,
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
                            'Delivery Price:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
                          ),
                          Text(
                            widget.delv_price != ''
                                ? '${widget.delv_price}\$'
                                : '1000\$',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
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
                            'Distance:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
                          ),
                          distance > 0
                              ? Text(
                                  '${distance.toStringAsFixed(2)} km',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
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
                            'Total Price:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
                          ),
                          Text(
                            widget.total_price != ''
                                ? '${widget.total_price}\$'
                                : '1000\$',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
                          ),
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
