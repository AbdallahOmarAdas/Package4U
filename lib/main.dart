import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Package4U/customer/from_me.dart';
import 'package:Package4U/customer/main_page.dart';
import 'package:Package4U/drivers/home_page_driver.dart';
import 'package:Package4U/drivers/onGoing.dart';
import 'package:Package4U/employee/main_page.dart';
import 'package:Package4U/manager/main_page.dart';
import 'package:Package4U/sign_in_up_pages/sign_in.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  await onGetCurrentLocationPressed();
  runApp(LoginUiApp());
}

Future<void> onGetCurrentLocationPressed() async {
  bool serviceEnabled;
  LocationPermission permission;

  try {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  } catch (e) {
    print('Exception while requesting location permission: $e');
  }
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
