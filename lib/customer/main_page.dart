import 'package:Package4U/customer/nofificationsHistory.dart';
import 'package:Package4U/customer/track_package.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Package4U/customer/change_password.dart';
import 'package:Package4U/customer/edit_profile.dart';
import 'package:Package4U/customer/from_me.dart';
import 'package:Package4U/customer/home.dart';
import 'package:Package4U/customer/service.dart';
import 'package:Package4U/customer/technicalReport.dart';
import 'package:Package4U/customer/to_me.dart';
import 'package:Package4U/sign_in_up_pages/sign_in.dart';
import 'package:Package4U/style/common/theme_h.dart';

import 'package:get_storage/get_storage.dart';

class home_page_customer extends StatefulWidget {
  @override
  State<home_page_customer> createState() => _home_page_customerState();
}

class _home_page_customerState extends State<home_page_customer> {
  int _index = 0;
  String customerName = GetStorage().read("Fname");
  String userName = GetStorage().read("userName");
  String email = GetStorage().read("email");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgUrl = urlStarter +
        '/image/' +
        GetStorage().read("userName") +
        GetStorage().read("url");
  }

  var imgUrl = urlStarter +
      '/image/' +
      GetStorage().read("userName") +
      GetStorage().read("url");

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
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                    imgUrl = urlStarter +
                        '/image/' +
                        GetStorage().read("userName") +
                        GetStorage().read("url");
                  });
                  Scaffold.of(context).openDrawer();
                });
          }),
          title: Text(
            'Express4U',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => NotificationHistory())));
                },
                icon: Icon(
                  Icons.notifications_on_rounded,
                  color: Colors.white,
                  size: 35,
                ),
                label: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Text(
                    "11",
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            // IconButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: ((context) => NotificationHistory())));
            //     },
            //     icon: Stack(
            //       children: [Icon(Icons.notifications_on_rounded), Text("11")],
            //     ))
          ],
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
                    customerName,
                    style: TextStyle(fontSize: 20),
                  ),
                  accountEmail: Text(
                    email,
                    style: TextStyle(fontSize: 14),
                  ),
                  currentAccountPicture: CachedNetworkImage(
                    imageUrl: imgUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/default.jpg'),
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
                    Icons.bug_report,
                    color: primarycolor,
                    size: 30,
                  ),
                  title: Text(
                    "Technical Report",
                    style: TextStyle(fontSize: 25),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TechnicalReport()));
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
                    GetStorage().erase();
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
