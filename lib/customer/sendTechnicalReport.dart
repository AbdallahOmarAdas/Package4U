import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_application_1/style/header/header.dart';
import 'package:get_storage/get_storage.dart';

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

  Future postAddLocation() async {
    // var url = urlStarter + "/customer/addNewLocation";
    // var responce = await http.post(Uri.parse(url),
    //     body: jsonEncode({
    //       "customerUserName": customerUserName,
    //       "customerPassword": customerPassword,
    //       "locationName": locationName,
    //       "locationInfo": locationInfo,
    //       "latTo": latto,
    //       "longTo": longto,
    //     }),
    //     headers: {
    //       'Content-type': 'application/json; charset=UTF-8',
    //     });
    // var responceBody = jsonDecode(responce.body);
    // if (responce.statusCode == 201) {
    //   fetchData();
    //   _textController2.text = "";
    // } else {
    //   throw Exception('Failed to load data');
    // }
    // return responceBody;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Technical Report'),
        backgroundColor: primarycolor,
      ),
      body: Column(
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
                    keyboardType: TextInputType.phone,
                    onSaved: (newValue) {
                      title = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter a title for the Report";
                      }
                      return null;
                    },
                    decoration: theme_helper().text_form_style(
                      "Report Title",
                      "Enter report title",
                      Icons.title,
                    ),
                  ),
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
                    decoration: theme_helper().text_form_style(
                      "Technical Message",
                      "Write a description of the problem",
                      Icons.message,
                    ),
                  ),
                  SizedBox(
                    height: 25,
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
                  postAddLocation();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
