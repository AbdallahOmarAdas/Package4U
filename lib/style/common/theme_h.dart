import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var urlStarter = "https://86e5-212-33-123-26.ngrok-free.app";
const primarycolor = Color.fromARGB(255, 7, 146, 93);
const String Titleapp = 'Package4U';

Future<List> fetch_cities() async {
  var url = urlStarter + "/employee/GetDriverListEmployee";
  final response = await http.get(Uri.parse(url), headers: {
    'Content-type': 'application/json; charset=UTF-8',
    'ngrok-skip-browser-warning': 'true'
  });

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    List cities = [];
    cities = data[0]['working_days']
        .substring(1, data[0]['working_days'].length - 1)
        .split(', ');

    return cities;
  } else {
    throw Exception('Failed to load data');
  }
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

bool isValidEmail(String email) {
  final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  return emailRegExp.hasMatch(email);
}

class theme_helper {
  InputDecoration text_form_style(
      [String label = "", String hinttext = "", IconData? iconData]) {
    return InputDecoration(
      prefixIcon: Icon(
        iconData,
        color: primarycolor,
      ),
      labelStyle: TextStyle(color: Colors.grey),
      labelText: label,
      hintText: hinttext,
      fillColor: Colors.white,
      focusColor: primarycolor,
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: Colors.grey.shade400)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: Colors.red, width: 2)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: Colors.red, width: 2)),
    );
  }

  InputDecoration edit_text_form_style(
      [String? placeholder, IconData? iconData]) {
    return InputDecoration(
      prefixIcon: Icon(iconData),
      labelText: placeholder,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: Colors.grey.shade400)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: Colors.red, width: 2)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: Colors.red, width: 2)),
    );
  }

  AlertDialog alartDialog(String title, String content, BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black38)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  InputDecoration text_form_style_search(
      [String label = "",
      String hinttext = "",
      IconData? iconData,
      TextEditingController? controller,
      void Function()? onCancel]) {
    return InputDecoration(
      prefixIcon: Icon(
        iconData,
        color: primarycolor,
      ),
      suffixIcon: controller != null && controller.text.isNotEmpty
          ? IconButton(
              icon: Icon(Icons.cancel_outlined),
              color: Colors.red,
              onPressed: onCancel,
            )
          : null,
      labelStyle: TextStyle(color: Colors.grey),
      labelText: label,
      hintText: hinttext,
      fillColor: Colors.white,
      focusColor: primarycolor,
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
