import 'package:flutter/material.dart';
import 'package:Package4U/customer/change_password.dart';
import 'package:Package4U/customer/edit_profile.dart';
import 'package:Package4U/customer/home.dart';
import 'package:Package4U/customer/service.dart';
import 'package:Package4U/sign_in_up_pages/sign_in.dart';
import 'package:Package4U/style/common/theme_h.dart';

class home_page_employee extends StatefulWidget {
  @override
  State<home_page_employee> createState() => _home_page_employeeState();
}

class _home_page_employeeState extends State<home_page_employee> {
  String username = 'employee';
  String email = 'employee@gmail.com';
  int _index = 0;

  void _bottomBar(int index) {
    setState(() {
      _index = index;
    });
  }

  final List<Widget> _pages = [
    home(),
    service(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _index,
      //   onTap: _bottomBar,
      //   type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.location_city), label: 'Service point'),
      //     //BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      //   ],
      // ),
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
            ],
          ),
        ),
      ),
      //body: _pages[_index]
    );
  }
}
