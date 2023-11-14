import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_application_1/style/header/header.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_application_1/style/showDialogShared/show_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class edit_profile extends StatefulWidget {
  @override
  State<edit_profile> createState() => _edit_profileState();
}

class _edit_profileState extends State<edit_profile> {
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  String isValidPhone(String input) {
    bool isnum = RegExp(r'^[0-9]+$').hasMatch(input);
    if (input.isEmpty)
      return "Please enter number phone";
    else if (input.length != 10) {
      return 'Phone number must have exactly 10 digits';
    } else if (!isnum) {
      return "Phone number must have numbers only";
    } else {
      return "";
    }
  }

  GlobalKey<FormState> formState4 = GlobalKey();
  String? fname;
  String? lname;
  String? username;
  String? oldUserName;
  String? city;
  String? email;
  String? oldEmail;
  String? town;
  String? street;
  String? phone;
  String? townStreet;
  List citylist = [
    'Nablus',
    'Tulkarm',
    'Ramallah',
    'Jenin',
    'Qalqilya',
    'Salfit',
    'Hebron'
  ];
  @override
  void initState() {
    super.initState();
    fname = GetStorage().read("Fname");
    lname = GetStorage().read("Lname");
    username = GetStorage().read("userName");
    oldUserName = GetStorage().read("userName");
    email = GetStorage().read("email");
    oldEmail = GetStorage().read("email");
    phone = GetStorage().read("phoneNumber").toString();
    city = GetStorage().read("city");
    town = GetStorage().read("town");
    street = GetStorage().read("street");
    townStreet = town! + ", " + street!;
  }

  Future postEditProfile() async {
    var url = urlStarter + "/users/editProfile";
    print(oldUserName);
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "oldUserName": oldUserName,
          "userName": username,
          "Fname": fname,
          "Lname": lname,
          "oldEmail": oldEmail,
          "email": email,
          "phoneNumber": phone,
          "city": city,
          "town": town,
          "street": street,
          "url": GetStorage().read("url")
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    print(responceBody);
    if (responceBody['message'] == "done") {
      GetStorage().write("Fname", fname);
      GetStorage().write("Lname", lname);
      GetStorage().write("userName", username);
      GetStorage().write("email", email);
      GetStorage().write("phoneNumber", phone);
      GetStorage().write("city", city);
      GetStorage().write("town", town);
      GetStorage().write("street", street);
      showDialog(
          context: context,
          builder: (context) {
            String userType = GetStorage().read("userType");
            return show_dialog().alartDialogPushNamed(
                "Done!",
                "The profile has been successfully modifiedly.",
                context,
                userType);
          });
    } else if (responceBody['message'] != "failed") {
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog()
                .alartDialog("Failed!", responceBody['message'], context);
          });
    } else {
      List errors = responceBody['error']['errors'];
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().aboutDialogErrors(errors, context);
          });
    }
    return responceBody;
  }

  XFile? _image;

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        uploadImage();
      });
    }
  }

  var imgUrl = urlStarter +
      '/image/' +
      GetStorage().read("userName") +
      GetStorage().read("url");

  Future uploadImage() async {
    final uri = Uri.parse(urlStarter + "/users/imm");
    var request = http.MultipartRequest('POST', uri);
    request.fields['userName'] = GetStorage().read("userName");

    var file = await http.MultipartFile.fromPath('image', _image!.path);
    request.files.add(file);

    var response = await request.send();
    if (response.statusCode == 200) {
      print(_image!.name.split('.')[1]);
      GetStorage().write("url", "." + _image!.name.split('.')[1]);
      print('Image uploaded successfully');
      final respStr = await response.stream.bytesToString();
      var res = jsonDecode(respStr);
      print(res['url']);
      GetStorage().write("url", res['url']);
      setState(() {
        imgUrl = urlStarter +
            '/image/' +
            GetStorage().read("userName") +
            GetStorage().read("url");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Edit Profile'),
        backgroundColor: primarycolor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: SafeArea(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 120,
                          child: HeaderWidget(120),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: imgUrl,
                                  width: 130,
                                  height: 130,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
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
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primarycolor,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          getImage();
                                        },
                                        icon: Icon(Icons.edit),
                                        color: Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 35,
                    ),
                    Form(
                        key: formState4,
                        child: Column(children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onSaved: (newValue) {
                                    fname = newValue!;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter First name";
                                    }
                                  },
                                  initialValue: fname,
                                  decoration: theme_helper().text_form_style(
                                    "First Name",
                                    "Enter  first name",
                                    Icons.person,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: TextFormField(
                                  onSaved: (newValue) {
                                    lname = newValue!;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter username";
                                    }
                                  },
                                  initialValue: lname,
                                  decoration: theme_helper().text_form_style(
                                    "Last Name",
                                    "Enter  last name",
                                    Icons.person,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            onSaved: (newValue) {
                              username = newValue!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter username";
                              }
                            },
                            initialValue: username,
                            decoration: theme_helper().text_form_style(
                              "Username",
                              "Enter  username",
                              Icons.person,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (newValue) {
                              email = newValue!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your email";
                              }
                              if (!isValidEmail(value)) {
                                return 'Please enter a valid email address';
                              }
                            },
                            initialValue: email,
                            decoration: theme_helper().text_form_style(
                              "E-mail",
                              "Enter your email",
                              Icons.email,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            onSaved: (newValue) {
                              phone = newValue!;
                            },
                            validator: (value) {
                              String res = isValidPhone(value.toString());
                              if (!res.isEmpty) {
                                return res;
                              }
                            },
                            initialValue: phone,
                            decoration: theme_helper().text_form_style(
                              "phone",
                              "Enter your phone number",
                              Icons.phone,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DropdownButtonFormField(
                            isExpanded: true,
                            hint: Text('Select City',
                                style: TextStyle(color: Colors.grey)),
                            items: citylist.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: city,
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
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue: townStreet,
                            onSaved: (newValue) {
                              town = newValue;
                              if (newValue != null) {
                                print(newValue.split(",").length);
                                town = newValue.split(",")[0];
                                street = newValue.split(",")[1];
                                print(town);
                                print("street:");
                                print(street);
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty ||
                                  value.split(",").length != 2) {
                                return "Enter your town's and street location";
                              }
                            },
                            decoration: theme_helper().text_form_style(
                              'Twon , Street',
                              "Enter your town's location",
                              Icons.place,
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                        ])),

                    // Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //  children: [
                    // MaterialButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(22.0)),
                    //   color: Colors.grey,
                    //   child: Padding(
                    //     padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    //     child: Text(
                    //       "Cancel",
                    //       style: TextStyle(
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                    MaterialButton(
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
                        if (formState4.currentState!.validate()) {
                          formState4.currentState!.save();
                          postEditProfile();
                        }
                      },
                    )
                    //],
                    //)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
