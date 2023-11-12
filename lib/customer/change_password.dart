import 'package:flutter/material.dart';
import 'package:flutter_application_1/customer/main_page.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_application_1/style/header/header.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_application_1/style/showDialogShared/show_dialog.dart';

class chang_pass extends StatefulWidget {
  @override
  State<chang_pass> createState() => _chang_passState();
}

class _chang_passState extends State<chang_pass> {
  bool passwordVisible1 = false;
  bool passwordVisible2 = false;
  bool passwordVisible3 = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasPasswordOneCapitalchar = false;
  var responceBody;
  String? pass;
  String? oldPass;

  Future postchangePassword() async {
    var userName = GetStorage().read("userName");
    var url = urlStarter + "/users/changePassword";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode(
            {"userName": userName, "oldPassword": oldPass, "password": pass}),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    responceBody = jsonDecode(responce.body);
    print(responceBody);
    if (responceBody['message'] == "done") {
      showDialog(
          context: context,
          builder: (context) {
            String userType = GetStorage().read("userType");
            return show_dialog().alartDialogPushNamed(
              "Changed!",
              "The password has been changed successfully.",
              context,userType
            );
          });
    } else if (responceBody['message'] ==
        "The old password is incorrect, please verify it.") {
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().alartDialog("Failed!",
                "The old password is incorrect, please verify it.", context);
          });
    } else if (responceBody['message'] ==
        "please choose a different password.") {
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().alartDialog(
                "Failed!", "please choose a different password.", context);
          });
    } else {
      List errors = responceBody['error']['errors'];
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().aboutDialogErrors(errors, context);
          });
    }
    return responceBody;
  }

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

  final formState5 = GlobalKey<FormState>();

  String? test;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Change Password'),
        backgroundColor: primarycolor,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 120,
            child: HeaderWidget(120),
          ),
          Form(
              key: formState5,
              child: Column(
                children: [
                  SizedBox(height: 80),
                  TextFormField(
                    obscureText: !passwordVisible1,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible1
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisible1 = !passwordVisible1;
                            },
                          );
                        },
                      ),
                      prefixIcon: Icon(Icons.lock, color: primarycolor),
                      labelText: 'Old Password',
                      hintText: 'Enter Old Password',
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return "Enter  old password";

                      // if (test != value) return "dosen\'t match";
                    },
                    onSaved: (newvalue) {
                      oldPass = newvalue;
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    onChanged: (password) => onPasswordChanged(password),
                    validator: (value) {
                      if (value!.isEmpty)
                        return "Enter password";
                      else
                        test = value;

                      if (!_isPasswordEightCharacters ||
                          !_hasPasswordOneNumber ||
                          !_hasPasswordOneCapitalchar)
                        return "Please follow the password writing rules";
                    },
                    onSaved: (newvalue) {
                      pass = newvalue;
                    },
                    obscureText: !passwordVisible2,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible2
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisible2 = !passwordVisible2;
                            },
                          );
                        },
                      ),
                      prefixIcon: Icon(Icons.lock, color: primarycolor),
                      labelText: 'New Password',
                      hintText: 'Enter new Password',
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    obscureText: !passwordVisible3,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible3
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisible3 = !passwordVisible3;
                            },
                          );
                        },
                      ),
                      prefixIcon: Icon(Icons.lock, color: primarycolor),
                      labelText: 'confirm password',
                      hintText: 'Enter confirm password',
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return "Enter confirm password";

                      if (test != value) return "dosen\'t match";
                    },
                  ),
                  SizedBox(height: 30.0),
                  Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              AnimatedContainer(
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
                        ],
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        color: primarycolor,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            "Reset",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          if (formState5.currentState!.validate()) {
                            formState5.currentState!.save();
                            postchangePassword();
                          }
                        }),
                  ),
                ],
              )

              //
              ),
        ]),
      ),
    );
  }
}
