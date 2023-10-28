import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/customer/main_page.dart';
import 'package:flutter_application_1/manager/main_page.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_application_1/sign_in_up_pages/forget_pass.dart';
import 'package:flutter_application_1/sign_in_up_pages/regstration.dart';
import 'package:flutter_application_1/style/header/header.dart';

class sign_in extends StatefulWidget {
  @override
  State<sign_in> createState() => _sign_inState();
}

class _sign_inState extends State<sign_in> {
  bool passwordVisible = false;
  GlobalKey<FormState> formState = GlobalKey();

  String? email;

  String? password;

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
                      "Sign into your account",
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
                                    borderSide: BorderSide(color: Colors.grey)),
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
                                child: Text("Forget your password?"),
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
                                    borderRadius: BorderRadius.circular(22.0)),
                                color: primarycolor,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  if (formState.currentState!.validate()) {
                                    formState.currentState!.save();
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) =>
                                                // home_page_customer()
                                                home_page_manager()));
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
          ],
        ),
      ),
    );
  }
}
