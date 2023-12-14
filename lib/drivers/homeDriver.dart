import 'package:flutter/material.dart';
import 'package:flutter_application_1/drivers/content_page_driver.dart';
import 'package:flutter_application_1/drivers/donePackages.dart';
import 'package:flutter_application_1/drivers/onGoing.dart';
import 'package:flutter_application_1/drivers/preparePackages.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';

class HomeDriver extends StatefulWidget {
  @override
  State<HomeDriver> createState() => _HomeDriverState();
}

class _HomeDriverState extends State<HomeDriver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: primarycolor,
                ),
              ),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Image(
                  image: AssetImage("assets/ff.png"),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              content(
                label: 'My packages for today',
                btn: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => OnGoingPackages())));
                },
                img: "assets/onGoing.png",
              ),
              SizedBox(
                height: 20,
              ),
              content(
                label: 'Prepare today packages',
                btn: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => PreparePackages())));
                },
                img: "assets/box.png",
              ),
              SizedBox(
                height: 20,
              ),
              content(
                label: 'Completed packages',
                btn: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => DonePackages())));
                },
                img: "assets/package-delivered-icon.png",
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // content(
              //   label: 'packages',
              //   btn: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: ((context) => content_page_driver())));
              //   },
              //   img: "assets/package-delivered-icon.png",
              // ),
            ],
          ),
        ));
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
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 1), spreadRadius: 2, blurRadius: 5)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image(
                  image: AssetImage(img),
                  height: 40,
                  width: 40,
                ),
              ),
              SizedBox(width: 10),
              Text(
                '${label}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // fontFamily:
                ),
              ),
              Expanded(
                child:
                    Container(), // This empty container takes up available space
              ),
              Icon(
                Icons.east,
                size: 35,
                color: primarycolor,
              ),
            ],
          ),
        ),
        //),
      ),
    );
  }
}
