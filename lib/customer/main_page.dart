import 'dart:async';

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
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class home_page_customer extends StatefulWidget {
  @override
  State<home_page_customer> createState() => _home_page_customerState();
}

class _home_page_customerState extends State<home_page_customer> {
  Future<void> _onMessageOpenApp(RemoteMessage message) async {
    String packageId = message.data['packageId'];
    int? intValuePackageId = int.tryParse(packageId);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => track_p(
                  isSearchBox: false,
                  packageId: intValuePackageId!,
                ))));
    print('onMessageOpenedApp: $message');
  }

  Future<int> fetchNotificationCount() async {
    var url = urlStarter +
        "/customer/getNotificationCount?customerUserName=" +
        GetStorage().read("userName");
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  int _index = 0;
  String customerName = GetStorage().read("Fname");
  String userName = GetStorage().read("userName");
  String email = GetStorage().read("email");
  int storedNotificationCount = GetStorage().read("notificationCount");
  int newNotificationCount = 0;
  late Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNotificationCount().then((value) {
      storedNotificationCount = value;
      GetStorage().write("notificationCount", value);
    });
    newNotificationCount = storedNotificationCount;
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    imgUrl = urlStarter +
        '/image/' +
        GetStorage().read("userName") +
        GetStorage().read("url");
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      fetchNotificationCount().then((value) {
        setState(() {
          newNotificationCount = value;
          storedNotificationCount = GetStorage().read("notificationCount");
        });
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
            ElevatedButton(
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(0),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primarycolor)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => NotificationHistory(
                              newNotificationCount: newNotificationCount,
                            ))));
              },
              child: Stack(alignment: Alignment.center, children: [
                Icon(
                  Icons.notifications_on_rounded,
                  color: Colors.white,
                  size: 35,
                ),
                newNotificationCount > storedNotificationCount
                    ? Container(
                        margin: EdgeInsets.only(left: 25, bottom: 20),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Text(
                          "${newNotificationCount - storedNotificationCount}",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Container(),
              ]),
            ),
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
