import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/customer/change_password.dart';
import 'package:flutter_application_1/customer/edit_profile.dart';
import 'package:flutter_application_1/customer/home.dart';
import 'package:flutter_application_1/customer/service.dart';
import 'package:flutter_application_1/manager/creat_driver.dart';
import 'package:flutter_application_1/manager/creat_employee.dart';
import 'package:flutter_application_1/sign_in_up_pages/sign_in.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';

class home_page_manager extends StatefulWidget {
  @override
  State<home_page_manager> createState() => _home_page_managerState();
}

class _home_page_managerState extends State<home_page_manager> {
  String username = 'Manager';
  String email = 'manager@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '${Titleapp}',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: Container(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    color: primarycolor.withOpacity(0.8),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                accountName: Text(
                  '${username}',
                  style: TextStyle(fontSize: 20),
                ),
                accountEmail: Text(
                  '${email}',
                  style: TextStyle(fontSize: 14),
                ),
                currentAccountPicture: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/f3.png"))),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                leading: Icon(
                  Icons.person,
                  color: primarycolor,
                  size: 30,
                ),
                title: Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 25),
                ),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => edit_profile()));
                },
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                leading: Icon(
                  Icons.lock,
                  color: primarycolor,
                  size: 30,
                ),
                title: Text(
                  "Change password",
                  style: TextStyle(fontSize: 25),
                ),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => chang_pass()));
                },
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                leading: Icon(
                  Icons.help,
                  color: primarycolor,
                  size: 30,
                ),
                title: Text(
                  "Help",
                  style: TextStyle(fontSize: 25),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Divider(
                color: Colors.grey,
                height: 5,
                thickness: 1,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                leading: Icon(
                  Icons.logout,
                  color: primarycolor,
                  size: 30,
                ),
                title: Text(
                  "Log Out",
                  style: TextStyle(fontSize: 25),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => sign_in()));
                },
              ),
              // Divider(
              //   color: Colors.grey,
              //   height: 5,
              //   thickness: 1,
              // ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: primarycolor,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(60),
                          bottomLeft: Radius.circular(60))),
                ),
                SizedBox(
                  height: 30,
                ),
                content(
                  label: 'Add Employee',
                  btn: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => create_employee())));
                  },
                  IconData: Icons.person_add_alt,
                ),
                content(
                  label: 'Add Driver',
                  btn: () {
                    print('heloo');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => creat_driver())));
                  },
                  IconData: Icons.drive_eta_rounded,
                ),
                content(
                  label: 'View Reports',
                  btn: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: ((context) => create_employee())));
                  },
                  IconData: Icons.document_scanner,
                ),
                content(
                  label: 'Track Driver',
                  btn: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: ((context) => create_employee())));
                  },
                  IconData: Icons.gps_fixed,
                ),
                content(
                  label: 'Sending Development or technical notes to admin',
                  btn: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: ((context) => create_employee())));
                  },
                  IconData: Icons.chat,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class content extends StatelessWidget {
  final String label;
  final IconData;

  const content(
      {super.key,
      required this.label,
      required this.IconData,
      required this.btn});

  final Function() btn;
  @override
  Widget build(BuildContext) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: primarycolor.withOpacity(0.6),
        onTap: btn,
        child: Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 1), spreadRadius: 2, blurRadius: 5)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: primarycolor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    IconData,
                    color: Colors.white,
                    size: 30,
                  )),
              SizedBox(height: 8),
              Text(
                '${label}',
                style: TextStyle(
                  fontSize: 30,
                  // fontFamily:
                ),
              )
            ],
          ),
        ),
        //),
      ),
    );
  }
}
