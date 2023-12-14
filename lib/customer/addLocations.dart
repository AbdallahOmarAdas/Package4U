import 'package:flutter/material.dart';
import 'package:flutter_application_1/customer/set_location.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddLocation extends StatefulWidget {
  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  List Locations = [];
  String? userName;
  late double latto = 0;
  late double longto;
  String? locationName;
  String? locationInfo;
  GlobalKey<FormState> formState4 = GlobalKey();
  TextEditingController _textController2 = TextEditingController();
  String customerUserName = GetStorage().read('userName');
  String customerPassword = GetStorage().read('password');
  bool flag = false;

  Future<void> fetchData() async {
    var url =
        urlStarter + "/customer/getMyLocations?userName=" + userName.toString();
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        Locations.clear();
        Locations = data['result'];
        flag = false;
      });
    } else if (response.statusCode == 404) {
      setState(() {
        flag = true;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future postAddLocation() async {
    var url = urlStarter + "/customer/addNewLocation";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "customerUserName": customerUserName,
          "customerPassword": customerPassword,
          "locationName": locationName,
          "locationInfo": locationInfo,
          "latTo": latto,
          "longTo": longto,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    if (responce.statusCode == 201) {
      fetchData();
      _textController2.text = "";
    } else {
      throw Exception('Failed to load data');
    }
    return responceBody;
  }

  Future postDeleteLocation(int id) async {
    var url = urlStarter + "/customer/deleteLocation";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "customerUserName": customerUserName,
          "customerPassword": customerPassword,
          "id": id
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    if (responce.statusCode == 200) {
      fetchData();
    } else {
      throw Exception('Failed to load data');
    }
    return responceBody;
  }

  @override
  void initState() {
    super.initState();
    userName = GetStorage().read('userName');
    fetchData();
  }

  List<String> savedRows = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorite locations'),
        backgroundColor: primarycolor,
      ),
      body: Column(
        children: [
          Visibility(
            visible: !flag,
            child: Expanded(
              child: ListView.separated(
                itemCount: Locations.length,
                itemBuilder: (context, index) {
                  List<String> detials =
                      Locations[index]['location'].split(',');
                  return ListTile(
                      title: Text(
                        "${Locations[index]['name']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: primarycolor, fontSize: 28),
                      ),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                detials[0],
                                style: textcolumnstyle(),
                              ),
                              Text(detials[1], style: textcolumnstyle()),
                              Text(detials[2], style: textcolumnstyle()),
                              Text(detials[3], style: textcolumnstyle()),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.delete_sweep,
                                  size: 35,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  postDeleteLocation(Locations[index]['id']);
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                      // trailing: Text("${mobiles[index]['screen']}"),
                      );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 2,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Visibility(
              visible: flag,
              child: Column(
                children: [
                  Text(
                    "You don't have saved locations",
                    style: TextStyle(color: primarycolor, fontSize: 25),
                  ),
                  SizedBox(height: 30),
                ],
              )),
          Container(
            alignment: Alignment.center,
            child: TextButton.icon(
              label: Text(
                'Add New Location',
                style: TextStyle(
                  color: primarycolor,
                  fontSize: 28,
                ),
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    builder: (context) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                'Add a new Location',
                                style: TextStyle(
                                  color: primarycolor,
                                  fontSize: 30,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Form(
                                  key: formState4,
                                  child: Column(children: [
                                    TextFormField(
                                      keyboardType: TextInputType.phone,
                                      onSaved: (newValue) {
                                        locationName = newValue!;
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter a name for the location";
                                        }
                                        return null;
                                      },
                                      decoration:
                                          theme_helper().text_form_style(
                                        "Location Name",
                                        "Enter nocation name like: Home",
                                        Icons.edit_location_alt_sharp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: _textController2,
                                      style: TextStyle(fontSize: 12.0),
                                      validator: (val) {
                                        if (val!.isEmpty)
                                          return 'Please set location first';
                                        return null;
                                      },
                                      onSaved: (newValue) {
                                        locationInfo = newValue;
                                      },
                                      readOnly: true,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    set_location(
                                                        onDataReceived:
                                                            getlocationto))));
                                      },
                                      decoration:
                                          theme_helper().text_form_style(
                                        "Set Location",
                                        "Set Location",
                                        Icons.add_location_alt_rounded,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                  ])),
                              Container(
                                alignment: Alignment.center,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(22.0)),
                                  color: primarycolor,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      "Add",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (formState4.currentState!.validate()) {
                                      formState4.currentState!.save();
                                      postAddLocation();
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: Icon(Icons.add_location_alt_outlined),
            ),
          ),
        ],
      ),
    );
  }

  void getlocationto(String text, double lat, double long) async {
    setState(() {
      String modifiedString = text.replaceAll("','", ",");
      _textController2.text = modifiedString;
      latto = lat;
      longto = long;
    });
  }
}

TextStyle textcolumnstyle() {
  return TextStyle(
    fontSize: 15,
  );
}
