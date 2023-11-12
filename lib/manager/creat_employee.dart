import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_application_1/style/header/header.dart';
import 'package:flutter_application_1/style/showDialogShared/show_dialog.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class create_employee extends StatefulWidget {
  @override
  State<create_employee> createState() => _create_employeeState();
}

class _create_employeeState extends State<create_employee> {
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  String? fname;
  String? lname;
  String? username;
  String? email;
  String? phone;

  Future postUsersAddEmployee() async {
    var url = urlStarter + "/users/addEmployee";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "userName": username,
          "Fname": fname,
          "Lname": lname,
          "email": email,
          "phoneNumber": phone,
          "userType": "employee",
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
                "The employee account is created successfully,\nNow Please ask the employee to reset his password in login page.",
                context,
                GetStorage().read("userType"));
          });
    }
    return responceBody;
  }

  GlobalKey<FormState> formState1 = GlobalKey();

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: primarycolor,
        title: Text("Create New Employee"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
                child: Container(
              child: Column(
                children: [
                  Container(
                    height: 120,
                    child: HeaderWidget(120),
                  ),
                  SizedBox(
                    height: 50,
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
                              if (value!.isEmpty) {
                                return "Please enter number phone";
                              }
                            },
                            decoration: theme_helper().text_form_style(
                              'Phone number',
                              'Enter phone number',
                              Icons.phone,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: primarycolor,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Creat account",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                if (formState1.currentState!.validate()) {
                                  formState1.currentState!.save();
                                  postUsersAddEmployee();
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
