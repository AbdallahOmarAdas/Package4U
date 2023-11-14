import 'package:flutter/material.dart';
import 'package:flutter_application_1/sign_in_up_pages/sign_in.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_application_1/style/header/header.dart';
import 'package:flutter_application_1/style/showDialogShared/show_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class registration extends StatefulWidget {
  @override
  //bool passwordVisible = false;
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasPasswordOneCapitalchar = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final numericRegex1 = RegExp(r'[A-Z]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) _isPasswordEightCharacters = true;

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordOneNumber = true;

      _hasPasswordOneCapitalchar = false;
      if (numericRegex1.hasMatch(password)) _hasPasswordOneCapitalchar = true;
    });
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  GlobalKey<FormState> formState1 = GlobalKey();
  String errormsg = "";
  List citylist = [
    'Nablus',
    'Tulkarm',
    'Ramallah',
    'Jenin',
    'Qalqilya',
    'Salfit',
    'Hebron'
  ];

  String isValidPhone(String input) {
    bool isnum = RegExp(r'^[0-9]+$').hasMatch(input);
    if (input.isEmpty)
      return "Please enter number phone";
    else if (input.length != 10) {
      return 'Phone number must have exactly 10 digits';
    } else if (!isnum) {
      return "Phone number must have numbers only";
    } else {
      return "";
    }
  }

  String? _emailError;
  void setCustomError(String errorMessage) {
    setState(() {
      _emailError = errorMessage;
    });
  }

  void clearError() {
    setState(() {
      _emailError = null;
    });
  }

  bool passwordVisible = false;

  String? fname;
  String? lname;
  String? username;

  String? city;

  String? email;

  String? password;

  String? town;
  String? street;
  String? phone;

  Future postUsersAddUser() async {
    var url = urlStarter + "/users/addUser";
    print("000000000" + town.toString());
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "userName": username,
          "password": password,
          "Fname": fname,
          "Lname": lname,
          "email": email,
          "phoneNumber": phone,
          "userType": "customer",
          "city": city,
          "town": town,
          "street": street,
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
                "Done!",
                "Thank you for creating account in Package4U,\nNow please sign in to your new account.",
                context,
                "signIn");
          });
    }
    return responceBody;
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text("Sign up"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 110,
              child: HeaderWidget(110),
            ),
            SafeArea(
                child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                      key: formState1,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onSaved: (newValue) {
                                    fname = newValue;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter First Name";
                                    }
                                  },
                                  decoration: theme_helper().text_form_style(
                                    'First Name',
                                    'Enter First Name',
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
                                    lname = newValue;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter Last Name";
                                    }
                                  },
                                  decoration: theme_helper().text_form_style(
                                    'Last Name',
                                    'Enter Last Name',
                                    Icons.person,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            onSaved: (newValue) {
                              username = newValue;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter username";
                              }
                            },
                            decoration: theme_helper().text_form_style(
                              'Username',
                              'Enter  username',
                              Icons.person,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            onSaved: (newValue) {
                              email = newValue;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter email";
                              }

                              if (!isValidEmail(value)) {
                                return 'Please enter a valid email address';
                              }
                            },
                            decoration: theme_helper().text_form_style(
                              'email',
                              'Enter your email',
                              Icons.email,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            onSaved: (newValue) {
                              phone = newValue;
                            },
                            validator: (value) {
                              String res = isValidPhone(value.toString());
                              if (!res.isEmpty) {
                                return res;
                              }
                            },
                            decoration: theme_helper().text_form_style(
                              'Phone number',
                              'Enter phone number',
                              Icons.phone,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField(
                            isExpanded: true,
                            hint: Text('Select City',
                                style: TextStyle(color: Colors.grey)),
                            items: citylist.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: city,
                            decoration: theme_helper().text_form_style(
                              '',
                              '',
                              Icons.location_city,
                            ),
                            onChanged: (value) {
                              setState(() {
                                city = value as String?;
                                print(city);
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Please select city";
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            onSaved: (newValue) {
                              town = newValue;
                              if (newValue != null) {
                                print(newValue.split(",").length);
                                town = newValue.split(",")[0];
                                street = newValue.split(",")[1];
                                print(town);
                                print("street:");
                                print(street);
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty ||
                                  value.split(",").length != 2) {
                                return "Enter your town's and street location";
                              }
                            },
                            decoration: theme_helper().text_form_style(
                              'Twon , Street',
                              "Enter your town's location",
                              Icons.place,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            onChanged: (value) => onPasswordChanged(value),
                            onSaved: (newValue) {
                              password = newValue;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter password";
                              }
                              if (!_isPasswordEightCharacters ||
                                  !_hasPasswordOneNumber ||
                                  !_hasPasswordOneCapitalchar)
                                return "Please follow the password writing rules";
                            },
                            obscureText: !passwordVisible,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey),
                                onPressed: () {
                                  setState(
                                    () {
                                      passwordVisible = !passwordVisible;
                                    },
                                  );
                                },
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: primarycolor,
                              ),
                              labelText: 'Password',
                              hintText: 'Enter Password',
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.grey),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 10, 20, 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2)),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              AnimatedContainer(
                                margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                duration: Duration(milliseconds: 500),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: _isPasswordEightCharacters
                                        ? Colors.green
                                        : Colors.transparent,
                                    border: _isPasswordEightCharacters
                                        ? Border.all(color: Colors.transparent)
                                        : Border.all(
                                            color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Contains at least 8 characters")
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              AnimatedContainer(
                                margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                duration: Duration(milliseconds: 500),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: _hasPasswordOneNumber
                                        ? Colors.green
                                        : Colors.transparent,
                                    border: _hasPasswordOneNumber
                                        ? Border.all(color: Colors.transparent)
                                        : Border.all(
                                            color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Contains at least 1 number")
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              AnimatedContainer(
                                margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                duration: Duration(milliseconds: 500),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: _hasPasswordOneCapitalchar
                                        ? Colors.green
                                        : Colors.transparent,
                                    border: _hasPasswordOneCapitalchar
                                        ? Border.all(color: Colors.transparent)
                                        : Border.all(
                                            color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Contains at least 1 capital character")
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: primarycolor,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                if (formState1.currentState!.validate()) {
                                  formState1.currentState!.save();
                                  postUsersAddUser();
                                }
                              },
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
