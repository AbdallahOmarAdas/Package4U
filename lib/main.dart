import 'package:flutter/material.dart';
import 'package:flutter_application_1/customer/add_parcel.dart';
import 'package:flutter_application_1/customer/call.dart';
import 'package:flutter_application_1/customer/edit_profile.dart';
import 'package:flutter_application_1/customer/home.dart';
import 'package:flutter_application_1/customer/main_page.dart';
import 'package:flutter_application_1/customer/set_location.dart';
import 'package:flutter_application_1/drivers/main_page.dart';
import 'package:flutter_application_1/employee/main_page.dart';
import 'package:flutter_application_1/manager/creat_driver.dart';
import 'package:flutter_application_1/manager/creat_employee.dart';
import 'package:flutter_application_1/manager/main_page.dart';
import 'package:flutter_application_1/sign_in_up_pages/regstration.dart';
import 'package:flutter_application_1/sign_in_up_pages/sign_in.dart';
import 'package:flutter_application_1/sign_in_up_pages/testAPI.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(LoginUiApp());
}

class LoginUiApp extends StatefulWidget {
  const LoginUiApp({super.key});

  @override
  State<LoginUiApp> createState() => _LoginUiAppState();
}

class _LoginUiAppState extends State<LoginUiApp> {
  String? userType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userType = GetStorage().read("userType");
    print("userType:" + userType.toString());
  }

  HomeReturn() {
    if (userType == null)
      return sign_in();
    else if (userType == "customer")
      return home_page_customer();
    else if (userType == "manager") return home_page_manager();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: primarycolor,
        ),
        home: HomeReturn(),
        debugShowCheckedModeBanner: false,
        routes: {
          "customerHome": (context) => home_page_customer(),
          "managerHome": (context) => home_page_manager(),
          "driverHome": (context) => home_page_driver(),
          "employeeHome": (context) => home_page_employee(),
          "signIn": (context) => sign_in(),
        }
        //home: testAPI(),
        );
  }
}
