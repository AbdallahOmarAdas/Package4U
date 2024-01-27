import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:Package4U/style/header/header.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class SendTechnicalReport extends StatefulWidget {
  const SendTechnicalReport({super.key});

  @override
  State<SendTechnicalReport> createState() => _SendTechnicalReportState();
}

class _SendTechnicalReportState extends State<SendTechnicalReport> {
  String? title;
  String? message;

  GlobalKey<FormState> formState4 = GlobalKey();

  String customerUserName = GetStorage().read('userName');
  String customerPassword = GetStorage().read('password');

  var _screenshotController = TextEditingController();

  Future<void> sendTechnicalReport() async {
    // Check if an image is selected
    if (_image != null) {
      final uri = Uri.parse(urlStarter + "/admin/sendTechnicalReportWithImage");
      var request = http.MultipartRequest('POST', uri);

      // Add form fields
      request.fields['userName'] = GetStorage().read("userName");
      request.fields['title'] = title.toString();
      request.fields['message'] = message.toString();
      var file = await http.MultipartFile.fromPath('image', _image!.path);
      request.files.add(file);
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Report sent successfully');

        final respStr = await response.stream.bytesToString();
        var res = jsonDecode(respStr);
        print(res);
        Navigator.pop(context);
      } else {
        print('Failed to send report. Status code: ${response.statusCode}');
      }
    } else {
      final url = urlStarter + "/admin/sendTechnicalReportWithoutImage";
      var response = await http.post(Uri.parse(url),
          body: jsonEncode({
            "userName": GetStorage().read("userName"),
            "title": title.toString(),
            "message": message.toString()
          }),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        print('Report sent successfully');

        var res = jsonDecode(response.body);
        print(res);
        Navigator.pop(context);
      } else {
        print('Failed to send report. Status code: ${response.statusCode}');
      }
    }
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        _screenshotController.text = _image!.name.toString();
      });
    }
  }

  XFile? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Technical Report'),
        backgroundColor: primarycolor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 120,
              child: HeaderWidget(120),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              child: Form(
                  key: formState4,
                  child: Column(children: [
                    TextFormField(
                        maxLength: 30,
                        onSaved: (newValue) {
                          title = newValue!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please enter a title for the Report";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Title',
                            style: TextStyle(color: Colors.grey),
                          ),
                          prefixIcon: Icon(Icons.title, color: primarycolor),
                          hintText: 'Enter report title',
                          hintStyle: TextStyle(fontSize: 16.0),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                        minLines: 4,
                        maxLines: 8,
                        onSaved: (newValue) {
                          message = newValue;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter an message";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Message',
                            style: TextStyle(color: Colors.grey),
                          ),
                          prefixIcon:
                              Icon(Icons.screenshot, color: primarycolor),
                          hintText:
                              'Write a description of the problem, or any suggestions for improvement',
                          hintStyle: TextStyle(fontSize: 16.0),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                        )),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: _screenshotController,
                      onSaved: (newValue) {
                        //fname = newValue!;
                      },
                      readOnly: true,
                      onTap: () {
                        getImage();
                      },
                      //initialValue: fname,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.screenshot, color: primarycolor),
                        hintText: 'Optinaly Screenshot',
                        hintStyle: TextStyle(fontSize: 16.0),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2)),
                      ),
                    ),
                  ])),
            ),
            Container(
              alignment: Alignment.center,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                color: primarycolor,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: Text(
                    "Send",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                onPressed: () {
                  if (formState4.currentState!.validate()) {
                    formState4.currentState!.save();
                    sendTechnicalReport();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
