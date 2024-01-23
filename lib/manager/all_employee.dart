import 'package:Package4U/manager/creat_employee.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class all_employee extends StatefulWidget {
  const all_employee({super.key});

  @override
  State<all_employee> createState() => _all_employeeState();
}

class _all_employeeState extends State<all_employee> {
  List<Content_p> all_employees = [];
  List<dynamic> employees_ = [];
  String? searchText;

  @override
  void initState() {
    searchText = '';
    fetchData_employees();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> fetchData_employees() async {
    var url = urlStarter + "/employee/GetDriverListEmployee";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      employees_ = data;
      print(data);
      setState(() {
        all_employees = buildMy_employees();
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<Content_p> buildMy_employees() {
    List<Content_p> new_drivers = [];
    for (int i = 0; i < employees_.length; i++) {
      new_drivers.add(
        Content_p(
          phone: '444444', //drivers_[i]['phone'],
          username: employees_[i]['username'],
          name: employees_[i]['name'],
          email: 'aa@gailc.ssssss',
          photo: urlStarter + employees_[i]['img'],
        ),
      );
    }

    return new_drivers;
  }

  List<Content_p> filterddrivers() {
    if (searchText!.isEmpty) return all_employees;
    return all_employees.where((order) {
      if (searchText!.isNotEmpty &&
          !order.name.toLowerCase().startsWith(searchText!.toLowerCase()))
        return false;

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Content_p> filterd_drivers = filterddrivers();
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
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
                            'Serach by employee name',
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
                        'Add employee',
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
                          builder: ((context) => create_employee())));
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
class Content_p extends StatefulWidget {
  final String photo;
  final String name;
  final String username;
  final String phone;
  final String email;

  Content_p({
    super.key,
    required this.photo,
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
  });

  @override
  State<Content_p> createState() => _Content_pState();
}

class _Content_pState extends State<Content_p> {
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
                              text: 'Employee name : ',
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
                              text: "Email : ",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.email,
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
                                  title: Text("Delete employee"),
                                  content: Container(
                                    width: 400,
                                    child: Text(
                                      "Are you sure you want to delete  the employee name's  ${widget.name} from company",
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
