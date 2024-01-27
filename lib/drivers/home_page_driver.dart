import 'package:Package4U/customer/technicalReport.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Package4U/customer/change_password.dart';
import 'package:Package4U/customer/edit_profile.dart';
import 'package:Package4U/drivers/homeDriver.dart';
import 'package:Package4U/sign_in_up_pages/sign_in.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';

class home_page_driver extends StatefulWidget {
  @override
  State<home_page_driver> createState() => _home_page_driverState();
}

class _home_page_driverState extends State<home_page_driver> {
  String? Fname;
  String? email;
  String? userName;
  var imgUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Fname = GetStorage().read("Fname");
    email = GetStorage().read("email");
    userName = GetStorage().read("userName");
    imgUrl = urlStarter +
        '/image/' +
        GetStorage().read("userName") +
        GetStorage().read("url");
  }

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
                    '${Fname}',
                    style: TextStyle(fontSize: 20),
                  ),
                  accountEmail: Text(
                    '${email}',
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
                    "Report problem",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TechnicalReport()));
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
        body: HomeDriver());
  }
}
