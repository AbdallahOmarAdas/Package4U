import 'package:Package4U/manager/location_1.dart';
import 'package:flutter/material.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:Package4U/style/header/header.dart';
import 'package:Package4U/style/showDialogShared/show_dialog.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class editCompany extends StatefulWidget {
  const editCompany({super.key});

  @override
  State<editCompany> createState() => _editCompanyState();
}

class _editCompanyState extends State<editCompany> {
  String? locationName;
  String? locationInfo;

  TextEditingController _textController2 = TextEditingController();
  List cities = [];
  String? city;
  String? phone1;
  String? phone2;
  String? email;
  String? facebook;
  String? openDay;
  String? openTime;
  String? closeDay;
  String? companyManager;
  String? aboutCompany;
  double late = 0;
  double lang = 0;

  TextEditingController _textControllerphone1 = TextEditingController();
  TextEditingController _textControllerphone2 = TextEditingController();
  TextEditingController _textControlleremail = TextEditingController();
  TextEditingController _textControllerfacebook = TextEditingController();
  TextEditingController _textControlleropenDay = TextEditingController();
  TextEditingController _textControlleropenTime = TextEditingController();
  TextEditingController _textControllercloseDay = TextEditingController();
  TextEditingController _textControllercompanyManager = TextEditingController();
  TextEditingController _textControlleraboutCompany = TextEditingController();

  Future<void> fetchData() async {
    var url = urlStarter + "/users/info";
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _textControllerphone1.text = data['phone1'];
        _textControllerphone2.text = data['phone2'];
        _textControlleremail.text = data['email'];
        _textControllerfacebook.text = data['facebook'];
        _textControlleropenDay.text = data['openDay'];
        _textControlleropenTime.text = data['openTime'];
        _textControllercloseDay.text = data['closeDay'];
        city = data['companyHead'];
        _textControllercompanyManager.text = data['companyManager'];
        _textControlleraboutCompany.text = data['aboutCompany'];
        _textController2.text = data['locationInfo'];
        late = data['latitude'];
        lang = data['longitude'];
        print('///////////////////////////////////');
        print(late);
        print(lang);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future postEditCompanyInfo() async {
    var url = urlStarter + "/manager/editCompanyInfo";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "managerPassword": GetStorage().read('password'),
          "managerUserName": GetStorage().read('userName'),
          "phone1": phone1,
          "phone2": phone2,
          "email": email,
          "facebook": facebook,
          "openDay": openDay,
          "openTime": openTime,
          "closeDay": closeDay,
          "companyHead": city,
          "companyManager": companyManager,
          "aboutCompany": aboutCompany,
          "locationInfo": _textController2.text,
          "latitude": late,
          "longitude": lang,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    print(responceBody);
    if (responceBody['message'] == "failed") {
      List errors = responceBody['error']['errors'];
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().aboutDialogErrors(errors, context);
          });
    }
    if (responceBody['message'] == "done") {
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().alartDialogPushNamed(
                "Done!",
                "Company Information edited succsessfully.",
                context,
                GetStorage().read("userType"));
          });
    }
    if (responceBody['message'] == "faild2") {
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().alartDialog(
                "Faild!", "Company Information edited succsessfully.", context);
          });
    }
    return responceBody;
  }

  @override
  void initState() {
    fetch_cities().then((List result) {
      setState(() {
        cities = result;
      });
    });
    super.initState();
    fetchData();
  }

  GlobalKey<FormState> formState1 = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Information'),
          backgroundColor: primarycolor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 110,
                child: HeaderWidget(110),
              ),
              SafeArea(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                        key: formState1,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _textControllerphone1,
                              keyboardType: TextInputType.phone,
                              onSaved: (newValue) {
                                phone1 = newValue;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter company landline phone number";
                                }
                                return null;
                              },
                              decoration: theme_helper().text_form_style(
                                'landline phone number',
                                'Enter landline phone number',
                                Icons.local_phone,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: _textControllerphone2,
                              onSaved: (newValue) {
                                phone2 = newValue;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter company phone number";
                                }
                                return null;
                              },
                              decoration: theme_helper().text_form_style(
                                'company phone number',
                                'Enter company phone number',
                                Icons.phone_android_sharp,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _textControlleremail,
                              onSaved: (newValue) {
                                email = newValue;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter company email";
                                }
                                if (!isValidEmail(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              decoration: theme_helper().text_form_style(
                                'Company Email',
                                'Enter Company Email',
                                Icons.email,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _textControllerfacebook,
                              onSaved: (newValue) {
                                facebook = newValue;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter facebook page name";
                                }
                                return null;
                              },
                              decoration: theme_helper().text_form_style(
                                'Facebook page',
                                'Enter company facebook page name',
                                Icons.facebook,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _textControlleropenDay,
                              onSaved: (newValue) {
                                openDay = newValue;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter company opening days";
                                }
                                return null;
                              },
                              decoration: theme_helper().text_form_style(
                                'Opening Days',
                                'Enter company opening days',
                                Icons.edit_calendar_sharp,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _textControlleropenTime,
                              onSaved: (newValue) {
                                openTime = newValue;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter company opening time";
                                }
                                return null;
                              },
                              decoration: theme_helper().text_form_style(
                                'Opening Time',
                                'Enter company opening time',
                                Icons.watch_later_outlined,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _textControllercloseDay,
                              onSaved: (newValue) {
                                closeDay = newValue;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter company closing days";
                                }
                                return null;
                              },
                              decoration: theme_helper().text_form_style(
                                'Closing Days',
                                'Enter company closing days',
                                Icons.close,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            DropdownButtonFormField(
                              isExpanded: true,
                              hint: Text('Select City',
                                  style: TextStyle(color: Colors.grey)),
                              items: cities.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value:
                                  cities.contains(city) == true ? city : null,
                              decoration: theme_helper().text_form_style(
                                '',
                                '',
                                Icons.location_city,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  city = value as String?;
                                  print(city);
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Please select city";
                                }
                                return null;
                              },
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
                                setState(() {
                                  late_spec = late;
                                  lange_spec = lang;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => location_1(
                                            onDataReceived: getlocationto))));
                              },
                              decoration: theme_helper().text_form_style(
                                "Set Location",
                                "Set Location",
                                Icons.add_location_alt_rounded,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _textControllercompanyManager,
                              onSaved: (newValue) {
                                companyManager = newValue;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Company Manager name";
                                }
                                return null;
                              },
                              decoration: theme_helper().text_form_style(
                                "Company Manager",
                                "Enter the company manager name",
                                Icons.person,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _textControlleraboutCompany,
                              minLines: 4,
                              maxLines: 8,
                              onSaved: (newValue) {
                                aboutCompany = newValue;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter about company message";
                                }
                                return null;
                              },
                              decoration: theme_helper().text_form_style(
                                "About Company",
                                "Enter about company message",
                                Icons.info_outline,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.0)),
                                color: primarycolor,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  if (formState1.currentState!.validate()) {
                                    formState1.currentState!.save();
                                    postEditCompanyInfo();
                                  }
                                },
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ))
            ],
          ),
        ));
  }

  void getlocationto(String text, double lat, double long) {
    setState(() {
      String modifiedString = text.replaceAll("','", ",");
      _textController2.text = modifiedString;
      late = lat;
      lang = long;
    });
  }
}
