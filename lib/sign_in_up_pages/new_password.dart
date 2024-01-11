import 'package:flutter/material.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:Package4U/style/header/header.dart';
import 'package:Package4U/sign_in_up_pages/sign_in.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewPass extends StatefulWidget {
  @override
  State<NewPass> createState() => _NewPassState();
}

class _NewPassState extends State<NewPass> {
  bool passwordVisible = false;
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

  final formState3 = GlobalKey<FormState>();

  String? pass;
  var responceBody;
  String? test;
  Future postForgotSetPass() async {
    var email = GetStorage().read("email");
    var url = urlStarter + "/users/forgotSetPass";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({"email": email, "password": pass}),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    responceBody = jsonDecode(responce.body);
    print(responceBody);
    if (responceBody['message'] == "done") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      GetStorage().remove("email");
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => sign_in()));
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ],
              title: Text("Password Changed"),
              content: Text("The password has been changed successfully"),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
              contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
              backgroundColor: primarycolor,
            );
          });
    } else {
      List errors = responceBody['error']['errors'];
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ],
              title: Text("Validation Error"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Text("*${errors[index]['msg']}"),
                      margin: EdgeInsets.only(bottom: 20),
                    );
                  },
                  itemCount: errors.length,
                ),
              ),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
              contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
              backgroundColor: primarycolor,
            );
          });
    }
    return responceBody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 120,
            child: HeaderWidget(120),
          ),
          SafeArea(
            child: Container(
              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Reset Password',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Form(
                              key: formState3,
                              child: Column(
                                children: [
                                  TextFormField(
                                    onChanged: (password) =>
                                        onPasswordChanged(password),
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
                                    obscureText: !passwordVisible,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(
                                            () {
                                              passwordVisible =
                                                  !passwordVisible;
                                            },
                                          );
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.password,
                                        color: primarycolor,
                                      ),
                                      labelText: 'Password',
                                      hintText: 'Enter your user Password',
                                      fillColor: Colors.white,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade400)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2)),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    obscureText: true,
                                    decoration: theme_helper().text_form_style(
                                        "confirm password",
                                        "Enter confirm password",
                                        Icons.password),
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return "Enter confirm password";

                                      if (test != value)
                                        return "dosen\'t match";
                                    },
                                  ),
                                  SizedBox(height: 30.0),
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
                                                ? Border.all(
                                                    color: Colors.transparent)
                                                : Border.all(
                                                    color:
                                                        Colors.grey.shade400),
                                            borderRadius:
                                                BorderRadius.circular(50)),
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
                                                ? Border.all(
                                                    color: Colors.transparent)
                                                : Border.all(
                                                    color:
                                                        Colors.grey.shade400),
                                            borderRadius:
                                                BorderRadius.circular(50)),
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
                                                ? Border.all(
                                                    color: Colors.transparent)
                                                : Border.all(
                                                    color:
                                                        Colors.grey.shade400),
                                            borderRadius:
                                                BorderRadius.circular(50)),
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
                                      Text(
                                          "Contains at least 1 capital character")
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Container(
                                    child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(22.0)),
                                        color: primarycolor,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              40, 10, 40, 10),
                                          child: Text(
                                            "Reset",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (formState3.currentState!
                                              .validate()) {
                                            formState3.currentState!.save();
                                            postForgotSetPass();
                                          }
                                        }),
                                  ),
                                ],
                              )

                              //
                              ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
