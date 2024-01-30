import 'package:flutter/material.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class add_city extends StatefulWidget {
  @override
  _add_cityState createState() => _add_cityState();
}

class _add_cityState extends State<add_city> {
  List cities = [];
  List new_cities = [];
  String new_city = '';
  final formGlobalKey = GlobalKey<FormState>();
  String UserName = GetStorage().read('userName');
  String Password = GetStorage().read('password');

  Future update_cities(List city, String type) async {
    var url = urlStarter + "/manager/editCitiesList";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "managerUserName": UserName,
          "managerPassword": Password,
          "citiesList": city.toString()
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (responce.statusCode == 200) {
      setState(() {
        if (type == 'delete') {
          cities = city;
          // fetch_cities().then((List result) {
          //   cities = result;
          // });
        } else
          //fetch_cities().then((List result) {
          cities = city;
        // });
        new_cities = [];
        new_city = '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetch_cities().then((List result) {
      setState(() {
        cities = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        title: Text('Add and Remove Cities'),
        backgroundColor: primarycolor,
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              return Container(
                child: Card(
                  color: Colors.grey[300],
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${cities[index]}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_sweep,
                            size: 35,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            new_cities = cities;
                            print('${cities[index]}');
                            new_cities.remove('${cities[index]}');
                            update_cities(new_cities, 'delete');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
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
                        'Add new city',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            // Customize the border color
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  if (formGlobalKey.currentState!.validate()) {
                                    formGlobalKey.currentState!.save();
                                    new_cities = cities;
                                    print(new_cities.length);
                                    new_cities.add(new_city);
                                    update_cities(new_cities, 'add');
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text(
                                  "Add",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
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
                          title: Text("Add new city"),
                          content: Form(
                            key: formGlobalKey,
                            child: TextFormField(
                              onSaved: (newValue) {
                                new_city = newValue!;
                              },
                              maxLines: 1,
                              validator: (val) {
                                if (val!.isEmpty)
                                  return "Please Enter city name";

                                return null;
                              },
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Enter new city name'),
                            ),
                          ),
                          titleTextStyle:
                              TextStyle(color: Colors.white, fontSize: 25),
                          contentTextStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          backgroundColor: primarycolor,
                        );
                      });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
