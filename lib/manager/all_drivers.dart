import 'package:Package4U/manager/creat_driver.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class all_drivers extends StatefulWidget {
  const all_drivers({super.key});

  @override
  State<all_drivers> createState() => _all_driversState();
}

class _all_driversState extends State<all_drivers> {
  List<Content_d> all_driver = [];
  List<dynamic> drivers_ = [];
  String? searchText;

  @override
  void initState() {
    searchText = '';
    fetchData_drivers();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> fetchData_drivers() async {
    var url = urlStarter + "/manager/driversDetailsList";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      drivers_ = data;
      print(data);
      setState(() {
        all_driver = buildMy_drivers();
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<Content_d> buildMy_drivers() {
    List<Content_d> new_drivers = [];
    for (int i = 0; i < drivers_.length; i++) {
      List<String> daysList = drivers_[i]['working_days']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(', ')
          .map((day) => day.trim())
          .toList();

      new_drivers.add(
        Content_d(
          refreshdata: () {
            fetchData_drivers();
          },
          vehicleNumber: drivers_[i]['vehicleNumber'],
          city: drivers_[i]['city'],
          phone: drivers_[i]['phoneNumber'].toString(),
          username: drivers_[i]['username'],
          name: drivers_[i]['name'],
          working_days: daysList,
          photo: urlStarter + drivers_[i]['img'],
          vacation: drivers_[i]['notAvailableDate'],
        ),
      );
    }

    return new_drivers;
  }

  List<Content_d> filterddrivers() {
    if (searchText!.isEmpty) return all_driver;
    return all_driver.where((order) {
      if (searchText!.isNotEmpty &&
          !order.name.toLowerCase().startsWith(searchText!.toLowerCase()))
        return false;

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Content_d> filterd_drivers = filterddrivers();
    return Scaffold(
      appBar: AppBar(
        title: Text('Drivers'),
        backgroundColor: primarycolor,
      ),
      body: Stack(
        children: [
          ListView(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 350,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                            });
                          },
                          onSaved: (newValue) {},
                          decoration: theme_helper().text_form_style(
                            'Serach by driver name',
                            '',
                            Icons.search,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ...filterd_drivers.map((order) {
              return order;
            }).toList(),
          ]),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Container(
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: primarycolor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        'Add driver',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => creat_driver())));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Content_d extends StatefulWidget {
  final String photo;
  final String? vacation;
  final String name;
  final String username;
  final String phone;
  final String city;
  final String vehicleNumber;
  final List<String> working_days;
  final Function() refreshdata;

  Content_d(
      {super.key,
      required this.city,
      required this.working_days,
      required this.name,
      required this.username,
      required this.phone,
      required this.photo,
      required this.vehicleNumber,
      required this.refreshdata,
      required this.vacation});

  @override
  State<Content_d> createState() => _Content_dState();
}

class _Content_dState extends State<Content_d> {
  //  String username = GetStorage().read("userName");
  // String password = GetStorage().read("password");

  // Future post_delete_driver() async {
  //   var url = urlStarter + "/employee/DeletePackage";
  //   var responce = await http.post(Uri.parse(url),
  //       body: jsonEncode({
  //         "employeeUserName": username,
  //         "employeePassword": password,
  //       }),
  //       headers: {
  //         'Content-type': 'application/json; charset=UTF-8',
  //       });
  //   if (responce.statusCode == 200) {
  //     setState(() {
  //       widget.refreshdata();
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: primarycolor.withOpacity(0.6),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 1), spreadRadius: 2, blurRadius: 5)
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: CachedNetworkImage(
                        imageUrl: widget.photo,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/default.jpg'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Driver name : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: ' ${widget.name}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                          Text.rich(TextSpan(
                              text: 'Username : ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: ' ${widget.username}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                          Text.rich(TextSpan(
                              text: "Phone : ",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.phone,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                          Text.rich(TextSpan(
                              text: "Work city: ",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.city,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                          Text.rich(TextSpan(
                              text: "vehicle Number: ",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.vehicleNumber,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 3,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(TextSpan(
                          text: 'Working days: ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          children: <InlineSpan>[
                            TextSpan(
                              text: widget.working_days.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                              ),
                            )
                          ])),
                    ),
                  ],
                ),
                Visibility(
                  visible: widget.vacation != null,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text.rich(TextSpan(
                              text: 'Vacation : ',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.vacation,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                  ),
                                )
                              ])),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 3,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Delete",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 18),
                                        )),
                                  ],
                                  title: Text("Delete driver"),
                                  content: Container(
                                    width: 400,
                                    child: Text(
                                      "Are you sure you want to delete  the driver nams's  ${widget.name} from company",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                  titleTextStyle: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                  contentTextStyle: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  backgroundColor: primarycolor,
                                );
                              });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
