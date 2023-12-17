import 'package:flutter/material.dart';
import 'package:flutter_application_1/customer/from_me.dart';
import 'package:flutter_application_1/customer/main_page.dart';
import 'package:flutter_application_1/drivers/home_page_driver.dart';
import 'package:flutter_application_1/drivers/onGoing.dart';
import 'package:flutter_application_1/employee/main_page.dart';
import 'package:flutter_application_1/manager/main_page.dart';
import 'package:flutter_application_1/sign_in_up_pages/sign_in.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
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
    else if (userType == "manager")
      return home_page_manager();
    else if (userType == "driver") return home_page_driver();
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
          "fromMe": (context) => from_me(),
          "onGoing": (context) => OnGoingPackages(),
        }
        //home: testAPI(),
        );
  }
}
