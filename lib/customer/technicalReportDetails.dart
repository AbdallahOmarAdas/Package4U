import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TechnicalReportDetails extends StatefulWidget {
  final int id;
  const TechnicalReportDetails({super.key, required this.id});

  @override
  State<TechnicalReportDetails> createState() => _TechnicalReportDetailsState();
}

class _TechnicalReportDetailsState extends State<TechnicalReportDetails> {
  String customerUserName = GetStorage().read('userName').toString();
  Map<String, dynamic>? reportDetails;
  String? title;
  String? message;
  String? reply;
  String? imageUrl;
  String? dateTime = "2024-01-26T12:11:22.000Z";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    print(customerUserName);
    var url = urlStarter + "/admin/getTechnicalReport?id=${widget.id}";
    final response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'ngrok-skip-browser-warning': 'true'
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        title = data['title'];
        reply = data['reply'];
        message = data['message'];
        imageUrl = data['imageUrl'];
        reportDetails = data['result'];
        dateTime = data['createdAt'];
        isLoading = false; // Set isLoading to false after data is loaded
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Technical Report Details'),
        backgroundColor: primarycolor,
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
                heightFactor: 20,
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [
                      Text(
                        "Title:",
                        style: TextStyle(color: primarycolor, fontSize: 40),
                      ),
                      Text(
                        "${title}",
                        style: TextStyle(color: Colors.black, fontSize: 28),
                      ),
                    ]),
                    SizedBox(height: 10),
                    Text(
                      "Message:",
                      style: TextStyle(color: primarycolor, fontSize: 30),
                    ),
                    Text(
                      "${message}",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Reply:",
                      style: TextStyle(color: primarycolor, fontSize: 30),
                    ),
                    Text(
                      "${reply == null ? "No reply yet" : reply}",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Visibility(
                      visible: dateTime != null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Date: ${dateTime.toString().split('T')[0]}",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          Text(
                            "Time: ${dateTime.toString().split('T')[1]}",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    if (imageUrl != null)
                      CachedNetworkImage(
                        imageUrl: urlStarter + imageUrl.toString(),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/default.jpg'),
                      ), // Set the desired height for the image
                  ],
                ),
              ),
      ),
    );
  }
}
