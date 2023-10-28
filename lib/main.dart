import 'package:flutter/material.dart';
import 'package:flutter_application_1/customer/edit_profile.dart';
import 'package:flutter_application_1/customer/home.dart';
import 'package:flutter_application_1/customer/main_page.dart';
import 'package:flutter_application_1/drivers/main_page.dart';
import 'package:flutter_application_1/employee/main_page.dart';
import 'package:flutter_application_1/manager/creat_driver.dart';
import 'package:flutter_application_1/manager/creat_employee.dart';
import 'package:flutter_application_1/manager/main_page.dart';
import 'package:flutter_application_1/sign_in_up_pages/regstration.dart';
import 'package:flutter_application_1/sign_in_up_pages/sign_in.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';

void main() {
  runApp(LoginUiApp());
}

class LoginUiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primarycolor,
      ),
      home: sign_in(),
    );
  }
}
