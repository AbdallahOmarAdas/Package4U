import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_application_1/style/header/header.dart';

class edit_profile extends StatefulWidget {
  @override
  State<edit_profile> createState() => _edit_profileState();
}

class _edit_profileState extends State<edit_profile> {
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  GlobalKey<FormState> formState4 = GlobalKey();

  String? fname = 'mohammad';
  String? lname = 'zaied';
  String username = "Mohammad123";
  String town = "anabta";
  String city = "Tulkarm";
  String email = "mohammad@gmail.com";
  String phone = "0598952644";
  List citylist = [
    'Nablus',
    'Tulkarm',
    'Ramallah',
    'Jenin',
    'Qalqilya',
    'Salfit',
    'Hebron'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Edit Profile'),
        backgroundColor: primarycolor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: SafeArea(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 120,
                          child: HeaderWidget(120),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(
                            child: Positioned(
                              bottom: 0,
                              left: 200,
                              top: 20,
                              child: Center(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 130,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  AssetImage('assets/f3.png'))),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: primarycolor,
                                          ),
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.edit),
                                            color: Colors.white,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(
                      height: 35,
                    ),
                    Form(
                        key: formState4,
                        child: Column(children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onSaved: (newValue) {
                                    fname = newValue!;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter First name";
                                    }
                                  },
                                  initialValue: fname,
                                  decoration: theme_helper().text_form_style(
                                    "First Name",
                                    "Enter  first name",
                                    Icons.person,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: TextFormField(
                                  onSaved: (newValue) {
                                    lname = newValue!;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter username";
                                    }
                                  },
                                  initialValue: lname,
                                  decoration: theme_helper().text_form_style(
                                    "Last Name",
                                    "Enter  last name",
                                    Icons.person,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            onSaved: (newValue) {
                              username = newValue!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter username";
                              }
                            },
                            initialValue: username,
                            decoration: theme_helper().text_form_style(
                              "Username",
                              "Enter  username",
                              Icons.person,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (newValue) {
                              email = newValue!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your email";
                              }
                              if (!isValidEmail(value)) {
                                return 'Please enter a valid email address';
                              }
                            },
                            initialValue: email,
                            decoration: theme_helper().text_form_style(
                              "E-mail",
                              "Enter your email",
                              Icons.email,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            onSaved: (newValue) {
                              phone = newValue!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your phone number";
                              }
                            },
                            initialValue: phone,
                            decoration: theme_helper().text_form_style(
                              "phone",
                              "Enter your phone number",
                              Icons.phone,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            child: DropdownButton(
                              isExpanded: true,
                              value: city,
                              items: citylist.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  city = (value as String?)!;
                                  print(city);
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue: town,
                            onSaved: (newValue) {
                              town = newValue!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter your town's location";
                              }
                            },
                            decoration: theme_helper().text_form_style(
                              'Twon , Street',
                              "Enter your town's location",
                              Icons.place,
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                        ])),

                    // Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //  children: [
                    // MaterialButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(22.0)),
                    //   color: Colors.grey,
                    //   child: Padding(
                    //     padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    //     child: Text(
                    //       "Cancel",
                    //       style: TextStyle(
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      color: primarycolor,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        if (formState4.currentState!.validate()) {
                          formState4.currentState!.save();
                        }
                      },
                    )
                    //],
                    //)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
