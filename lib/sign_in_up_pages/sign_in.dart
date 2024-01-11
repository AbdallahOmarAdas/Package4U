import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Package4U/customer/main_page.dart';
import 'package:Package4U/drivers/home_page_driver.dart';
import 'package:Package4U/employee/main_page.dart';
import 'package:Package4U/manager/main_page.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:Package4U/sign_in_up_pages/forget_pass.dart';
import 'package:Package4U/sign_in_up_pages/regstration.dart';
import 'package:Package4U/style/header/header.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class sign_in extends StatefulWidget {
  @override
  State<sign_in> createState() => _sign_inState();
}

class _sign_inState extends State<sign_in> {
  bool passwordVisible = false;
  String? _token;
  var _firebaseMessaging = FirebaseMessaging.instance;
  GlobalKey<FormState> formState = GlobalKey();
  var responceBody;
  String? userName;

  String? password;
  bool isLoginFaild = false;
  Future postSignin() async {
    print(_token);
    var url = urlStarter + "/users/signin";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode(
            {"userName": userName, "password": password, "token": _token}),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    responceBody = jsonDecode(responce.body);
    print(responceBody);
    if (responceBody['result'] != "user not found") {
      print(responceBody['user']['userName']);
      GetStorage().write("Fname", responceBody['user']['Fname']);
      GetStorage().write("password", responceBody['user']['password']);
      GetStorage().write("Lname", responceBody['user']['Lname']);
      GetStorage().write("userName", responceBody['user']['userName']);
      GetStorage().write("email", responceBody['user']['email']);
      GetStorage().write("phoneNumber", responceBody['user']['phoneNumber']);
      GetStorage().write("userType", responceBody['user']['userType']);
      GetStorage().write("city", responceBody['user']['city']);
      GetStorage().write("town", responceBody['user']['town']);
      GetStorage().write("street", responceBody['user']['street']);
      GetStorage().write("url", responceBody['user']['url']);
      GetStorage().write("notificationCount", 0);
      if (responceBody['user']['userType'] == "customer")
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => home_page_customer()));
      if (responceBody['user']['userType'] == "manager")
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => home_page_manager()));
      if (responceBody['user']['userType'] == "employee")
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => home_page_employee()));
      if (responceBody['user']['userType'] == "driver")
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => home_page_driver()));
    } else {
      setState(() {
        isLoginFaild = true;
      });

      formState.currentState!.validate();
      showValidationMessage("Incorrect username or password");
      print("user not found");
    }
    return responceBody;
  }

  void showValidationMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    GetStorage().erase();
    _firebaseMessaging.getToken().then((token) {
      print("=================================================");
      _token = token;
      print(token);
      print("=================================================");
    });
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 120,
              child: HeaderWidget(120),
            ),
            Container(
              height: 250,
              //margin: EdgeInsets.only(top: 50),
              child: Image(
                image: AssetImage("assets/fff.png"),
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: primarycolor),
                      ),
                      Text(
                        "Log In to your account",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Form(
                          key: formState,
                          child: Column(
                            children: [
                              TextFormField(
                                onSaved: (newValue) {
                                  userName = newValue;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please the enter username";
                                  }
                                  if (isLoginFaild) {
                                    return "Incorrect username or password";
                                  }
                                  return null;
                                },
                                decoration: theme_helper().text_form_style(
                                  'Username',
                                  'Enter your username',
                                  Icons.person,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 30),
                              TextFormField(
                                onSaved: (newValue) {
                                  password = newValue;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter password";
                                  }

                                  if (isLoginFaild) {
                                    return "Incorrect username or password";
                                  }
                                  return null;
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
                                          passwordVisible = !passwordVisible;
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
                                  labelStyle: TextStyle(color: Colors.grey),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2)),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  child: Text("Forgot your password?"),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                ForgetPassword())));
                                  },
                                ),
                              ),
                              Container(
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(22.0)),
                                  color: primarycolor,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      "Log in",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () {
                                    isLoginFaild = false;
                                    if (formState.currentState!.validate()) {
                                      formState.currentState!.save();
                                      postSignin();
                                    }
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                child: Text.rich(
                                  TextSpan(children: [
                                    TextSpan(text: "Don\'t have an account?"),
                                    TextSpan(
                                      text: " Create",
                                      style: TextStyle(
                                          color: primarycolor, fontSize: 18),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      registration())));
                                        },
                                    ),
                                  ]),
                                ),
                                // 'Don\'t have an account? Creat'
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
