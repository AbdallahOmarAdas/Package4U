import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Package4U/sign_in_up_pages/forget_pass.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:Package4U/style/header/header.dart';
import 'package:Package4U/sign_in_up_pages/new_password.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool _pinSuccess = false;
  String? code;
  var responceBody;
  Future postForgotCode() async {
    var email = GetStorage().read("email");
    var url = urlStarter + "/users/forgotCode";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({"email": email, "code": code}),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    responceBody = jsonDecode(responce.body);
    print(responceBody);
    if (responceBody['message'] == "done") {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => NewPass()));
    } else if (responceBody['message'] ==
        "We're sorry, but the verification code you entered is incorrect.") {
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
              title: Text("Wrong Code"),
              content: Text(
                  "We're sorry, but the verification code you entered is incorrect."),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
              contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
              backgroundColor: primarycolor,
            );
          });
      print("Wrong Code");
    } else if (responceBody['message'] ==
        "We're sorry, but the verification code you entered is incorrect.") {
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
              title: Text("No requiest for code"),
              content: Text(
                  "We're sorry, no requiest belong this emaile to reset password."),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
              contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
              backgroundColor: primarycolor,
            );
          });
      print("No requiest for code");
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
        appBar: AppBar(
          title: Text("Verification"),
          backgroundColor: primarycolor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              GetStorage().remove("email");
              Navigator.of(context).pop();
            },
          ),
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
                              'Verification',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Enter the verification code we just sent you on your email address.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Form(
                        child: Column(
                          children: [
                            OTPTextField(
                              length: 5,
                              width: 400,
                              fieldWidth: 50,
                              style: TextStyle(fontSize: 30),
                              otpFieldStyle:
                                  OtpFieldStyle(focusBorderColor: primarycolor),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onChanged: (val) {},
                              onCompleted: (pin) {
                                code = pin;
                                setState(() {
                                  _pinSuccess = true;
                                });
                              },
                            ),
                            SizedBox(height: 50.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "If you didn't receive a code! ",
                                    style: TextStyle(
                                      color: Colors.black38,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Resend',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        String? email =
                                            GetStorage().read("email");
                                        var url = urlStarter + "/users/forgot";
                                        var responce =
                                            await http.post(Uri.parse(url),
                                                body: jsonEncode({
                                                  "email": email,
                                                }),
                                                headers: {
                                              'Content-type':
                                                  'application/json; charset=UTF-8',
                                            });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return theme_helper().alartDialog(
                                                "Successful",
                                                "Verification code resend successful.",
                                                context);
                                          },
                                        );
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              decoration: BoxDecoration(
                                color: _pinSuccess ? primarycolor : Colors.grey,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "VERIFY",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                onPressed: _pinSuccess
                                    ? () {
                                        postForgotCode();
                                      }
                                    : null,
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
