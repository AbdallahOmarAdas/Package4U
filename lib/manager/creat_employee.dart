import 'package:flutter/material.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:Package4U/style/header/header.dart';
import 'package:Package4U/style/showDialogShared/show_dialog.dart';
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

  Future<void> fetchDataEmail(String email) async {
    var url = urlStarter + "/users/isAvailableEmail?email=" + email;
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 409) {
      setState(() {
        isEmailTaken = true;
      });
    } else {
      setState(() {
        isEmailTaken = false;
      });
    }
    _emailKey.currentState!.validate();
  }

  Future<void> fetchData(String userName) async {
    var url = urlStarter + "/users/isAvailableUserName?userName=" + userName;
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 409) {
      setState(() {
        isUsernameTaken = true;
      });
    } else {
      setState(() {
        isUsernameTaken = false;
      });
    }
    _usernameKey.currentState!.validate();
  }

  final GlobalKey<FormFieldState<String>> _usernameKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();
  bool isUsernameTaken = false;
  bool isEmailTaken = false;

  String? fname;
  String? lname;
  String? username;
  String? email;
  String? phone;
  String managerUserName = GetStorage().read('userName');
  String managerPassword = GetStorage().read('password');
  Future postUsersAddEmployee() async {
    var url = urlStarter + "/manager/addEmployee";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "managerUserName": managerUserName,
          "managerPassword": managerPassword,
          "userName": username,
          "Fname": fname,
          "Lname": lname,
          "email": email,
          "phoneNumber": phone
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
                            key: _usernameKey,
                            onChanged: (val) {
                              fetchData(val.toString());
                            },
                            onSaved: (newValue) {
                              username = newValue;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter username";
                              }
                              if (isUsernameTaken) {
                                return "This username is not available";
                              }
                              return null;
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
                            key: _emailKey,
                            onChanged: (val) {
                              fetchDataEmail(val);
                            },
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
                              if (isEmailTaken)
                                return "Used by another account";
                              return null;
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
