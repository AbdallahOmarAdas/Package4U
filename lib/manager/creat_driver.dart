import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:day_picker/day_picker.dart';
import 'package:flutter_application_1/style/header/header.dart';

class creat_driver extends StatefulWidget {
  @override
  State<creat_driver> createState() => _creat_driverState();
}

class _creat_driverState extends State<creat_driver> {
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  List<DayInWeek> _days = [
    DayInWeek(
      "Sun",
      dayKey: 'Sunday',
    ),
    DayInWeek(
      "Mon",
      dayKey: 'Monday',
    ),
    DayInWeek("Tue", dayKey: 'Tuesday'),
    DayInWeek(
      "Wed",
      dayKey: 'Wednesday',
    ),
    DayInWeek(
      "Thu",
      dayKey: 'Thursday',
    ),
    DayInWeek(
      "Fri",
      dayKey: 'Friday',
    ),
    DayInWeek(
      "Sat",
      dayKey: 'Saturday',
    ),
  ];
  GlobalKey<FormState> formState4 = GlobalKey();

  String? fromcity;
  String? tocity;
  String? vehicle_n;
  String? workingday;
  String? fname;
  String? lname;
  String? username;
  String? email;
  String? phone;
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
        title: Text('Create New Driver'),
        backgroundColor: primarycolor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      height: 110,
                      child: HeaderWidget(110),
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
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: Colors.grey.shade400)),
                                  child: DropdownButton(
                                    value: fromcity,
                                    isExpanded: true,
                                    hint: Text('From City'),
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
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: Colors.grey.shade400)),
                                  child: DropdownButton(
                                    value: tocity,
                                    hint: Text('To City'),
                                    isExpanded: true,
                                    items: citylist.map((value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        tocity = (value as String?)!;
                                        print(tocity);
                                      });
                                    },
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
                              vehicle_n = newValue!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter vehicle number";
                              }
                            },
                            decoration: theme_helper().text_form_style(
                              'vehicle number',
                              "Enter vehicle number",
                              Icons.car_rental,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                              height: 20,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  colors: [
                                    primarycolor.withOpacity(0.5),
                                    Colors.green.shade300
                                  ],
                                  tileMode: TileMode
                                      .repeated, // repeats the gradient over the canvas
                                ),
                              ),
                              child: Center(child: Text('Working days'))),
                          SizedBox(
                            height: 10,
                          ),
                          SelectWeekDays(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            days: _days,
                            border: false,
                            boxDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                colors: [
                                  primarycolor.withOpacity(0.5),
                                  Colors.green.shade300
                                ],
                                tileMode: TileMode
                                    .repeated, // repeats the gradient over the canvas
                              ),
                            ),
                            onSelect: (values) {
                              print(values);
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ])),

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
