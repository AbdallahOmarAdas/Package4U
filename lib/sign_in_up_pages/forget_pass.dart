import 'package:flutter/material.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:Package4U/style/header/header.dart';
import 'package:flutter/gestures.dart';
import 'package:Package4U/sign_in_up_pages/sign_in.dart';
import 'package:Package4U/sign_in_up_pages/verification.dart';
import 'package:Package4U/style/showDialogShared/show_dialog.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgetPassword extends StatelessWidget {
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  final formState2 = GlobalKey<FormState>();
  String? email;
  var responceBody;
  @override
  Widget build(BuildContext context) {
    Future postForgot() async {
      var url = urlStarter + "/users/forgot";
      var responce = await http.post(Uri.parse(url),
          body: jsonEncode({
            "email": email,
          }),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          });
      responceBody = jsonDecode(responce.body);
      print(responceBody);
      if (responceBody['message'] == "done") {
        GetStorage().write("email", email);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Verification()));
      } else if (responceBody['message'] == "email not found") {
        showDialog(
            context: context,
            builder: (context) {
              return show_dialog().alartDialog(
                  "Email not found!",
                  "We could not find this email. Please check the email you entered.",
                  context);
            });
        print("Email not found");
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

    //double _headerHeight = 120;
    return Scaffold(
        appBar: AppBar(
          title: Text("Forget password"),
          backgroundColor: primarycolor,
        ),
        backgroundColor: Colors.white,
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
                            Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Enter the email address associated with your account.',
                              style: TextStyle(
                                  // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'We will email you a verification code to check your authenticity.',
                              style: TextStyle(
                                color: Colors.black38,
                                // fontSize: 20,
                              ),
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Form(
                        key: formState2,
                        child: Column(
                          children: [
                            Container(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: theme_helper().text_form_style(
                                    "Email", "Enter your email", Icons.email),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Email can't be empty";
                                  }
                                  if (!isValidEmail(val)) {
                                    return 'Please enter a valid email address';
                                  }
                                },
                                onSaved: (newValue) {
                                  email = newValue;
                                },
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.0)),
                                color: primarycolor,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "SEND",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  if (formState2.currentState!.validate()) {
                                    formState2.currentState!.save();
                                    postForgot();
                                    // Navigator.of(context).push(
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             Verification()));
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: "Remember your password? "),
                                  TextSpan(
                                    text: 'Login',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => sign_in()),
                                        );
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primarycolor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
