import 'package:flutter/material.dart';
import 'package:Package4U/customer/addLocations.dart';
import 'package:Package4U/customer/add_parcel.dart';
import 'package:Package4U/customer/call.dart';
import 'package:Package4U/customer/claculatePrice.dart';
import 'package:Package4U/customer/track_package.dart';
import 'package:Package4U/style/common/theme_h.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final FocusNode _textFieldFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                width: MediaQuery.of(context).size.width,
                //margin: EdgeInsets.all(0),
                height: 120,
                color: primarycolor,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                          "Enter your package number and see details about your parcel",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            focusNode: _textFieldFocus,
                            onTap: () {
                              _textFieldFocus.unfocus();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => track_p(
                                            isSearchBox: true,
                                            packageId: 0,
                                          ))));
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter 6 digits tracking number',
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2)),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          iconSize: 40,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 280,
                width: MediaQuery.of(context).size.width,
                child: Image(
                  image: AssetImage("assets/ff.png"),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              content(
                label: 'Send Package',
                btn: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => add_parcel(
                                title: 'Send Package',
                              ))));
                },
                img: "assets/add_package.png",
              ),
              content(
                label: 'Calculate Delivery Price',
                btn: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => calculatePrice())));
                },
                img: "assets/calculator.png",
              ),
              content(
                label: 'Contact Information',
                btn: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => call())));
                },
                img: "assets/help.png",
              ),
              content(
                label: 'My Favorite locations',
                btn: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => AddLocation())));
                },
                img: "assets/favorite_locations.png",
              ),
            ],
          ),
        ));
  }
}

class content extends StatelessWidget {
  final String label;
  final img;
  final Function() btn;

  const content(
      {super.key, required this.label, required this.img, required this.btn});

  @override
  Widget build(BuildContext) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: primarycolor.withOpacity(0.6),
        onTap: btn,
        child: Ink(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 1), spreadRadius: 2, blurRadius: 5)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image(
                  image: AssetImage(img),
                  height: 40,
                  width: 40,
                ),
              ),
              SizedBox(width: 10),
              Text(
                '${label}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // fontFamily:
                ),
              ),
              Expanded(
                child:
                    Container(), // This empty container takes up available space
              ),
              Icon(
                Icons.east,
                size: 35,
                color: primarycolor,
              ),
            ],
          ),
        ),
        //),
      ),
    );
  }
}
