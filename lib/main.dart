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
import 'package:flutter_application_1/sign_in_up_pages/testAPI.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(LoginUiApp());
// }
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs =await SharedPreferences.getInstance();
  var userType=prefs.getString("userType");
  print(userType);
  runApp(MaterialApp(
    theme: ThemeData(
        primaryColor: primarycolor,
      ),
    debugShowCheckedModeBanner: false,
    home: userType==null?sign_in():home_page_customer(),));
}
// class LoginUiApp extends StatelessWidget {
//   var userType;
//   getPref() async {
//     SharedPreferences sharedPref = await SharedPreferences.getInstance();
//     if (sharedPref.getString('userType') == "customer")
//       userType = "customer";
//     else
//       userType = "none";
//   }

//   @override
//   void initState() {
//     getPref();
//   }

//   @override
//   Widget build(BuildContext context) {
//     getPref();
//     return MaterialApp(
//       theme: ThemeData(
//         primaryColor: primarycolor,
//       ),
//       home: userType == "customer" ? home_page_customer() : sign_in(),
//       debugShowCheckedModeBanner: false,
//       //home: testAPI(),
//     );
//   }
// }
