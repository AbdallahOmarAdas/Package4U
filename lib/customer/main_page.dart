import 'package:flutter/material.dart';
import 'package:flutter_application_1/customer/change_password.dart';
import 'package:flutter_application_1/customer/edit_profile.dart';
import 'package:flutter_application_1/customer/from_me.dart';
import 'package:flutter_application_1/customer/home.dart';
import 'package:flutter_application_1/customer/service.dart';
import 'package:flutter_application_1/customer/to_me.dart';
import 'package:flutter_application_1/sign_in_up_pages/sign_in.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home_page_customer extends StatefulWidget {
  @override
  State<home_page_customer> createState() => _home_page_customerState();
}

class _home_page_customerState extends State<home_page_customer> {
  int _index = 0;

  void _bottomBar(int index) {
    setState(() {
      _index = index;
    });
  }

  final List<Widget> _pages = [
    home(),
    from_me(),
    to_me(),
    service(),
  ];
  deletePref() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove("userName");
    sharedPref.remove("Fname");
    sharedPref.remove("Lname");
    sharedPref.remove("phoneNumber");
    sharedPref.remove("email");
    sharedPref.remove("userType");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: primarycolor,
          currentIndex: _index,
          onTap: _bottomBar,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.outbox,
                ),
                label: 'From me'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.inventory,
                ),
                label: 'To me'),
            //BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_city), label: 'Service point'),
          ],
        ),
        appBar: AppBar(
          backgroundColor: primarycolor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Express4U',
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
                    'customer',
                    style: TextStyle(fontSize: 20),
                  ),
                  accountEmail: Text(
                    'aaaa@gmail.com',
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

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => edit_profile()));
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
                    deletePref();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => sign_in()));
                  },
                ),
              ],
            ),
          ),
        ),
        body: _pages[_index]);
  }
}
