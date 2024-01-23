import 'package:Package4U/customer/sendTechnicalReport.dart';
import 'package:Package4U/manager/all_drivers.dart';
import 'package:Package4U/manager/all_employee.dart';
import 'package:Package4U/manager/reports/reports.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Package4U/customer/change_password.dart';
import 'package:Package4U/customer/edit_profile.dart';
import 'package:Package4U/manager/editCompany.dart';
import 'package:Package4U/manager/editCosts.dart';
import 'package:Package4U/manager/track_driver.dart';
import 'package:Package4U/sign_in_up_pages/sign_in.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';

class home_page_manager extends StatefulWidget {
  @override
  State<home_page_manager> createState() => _home_page_managerState();
}

class _home_page_managerState extends State<home_page_manager> {
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
              Padding(padding: EdgeInsets.only(top: 0)),
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
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => edit_profile()));
                },
              ),
              Padding(padding: EdgeInsets.only(top: 0)),
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
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => chang_pass()));
                },
              ),
              Padding(padding: EdgeInsets.only(top: 0)),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                leading: Icon(
                  Icons.edit,
                  color: primarycolor,
                  size: 30,
                ),
                title: Text(
                  "Company Informations",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => editCompany()));
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                leading: Icon(
                  Icons.edit,
                  color: primarycolor,
                  size: 30,
                ),
                title: Text(
                  "Delivery Costs",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => editCosts()));
                },
              ),
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
                      builder: (context) => SendTechnicalReport()));
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
                  label: 'Employees',
                  btn: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => all_employee())));
                  },
                  img: "assets/add-friend.png",
                ),
                content(
                  label: 'Drivers',
                  btn: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => all_drivers())));
                  },
                  img: "assets/driver.png",
                ),
                content(
                  label: 'View Reports',
                  btn: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => reports())));
                  },
                  img: "assets/audit.png",
                ),
                content(
                  label: 'Track Driver',
                  btn: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => Track_driver())));
                  },
                  img: "assets/route.png",
                ),
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
  final img;
  final Function() btn;

  const content(
      {super.key, required this.label, required this.img, required this.btn});

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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image(
                  image: AssetImage(img),
                  height: 100,
                  width: 100,
                ),
              ),
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
