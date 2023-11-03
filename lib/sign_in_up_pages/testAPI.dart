import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class testAPI extends StatefulWidget {
  const testAPI({super.key});

  @override
  State<testAPI> createState() => _testAPIState();
}

class _testAPIState extends State<testAPI> {
  List posts = [];
  Future getPost() async {
    var url = "https://jsonplaceholder.typicode.com/posts";
    var responce = await http.get(Uri.parse(url));
    var responceBody = jsonDecode(responce.body);
    // setState(() {
    //   posts.addAll(responceBody);
    // });

    //print(posts);
    return responceBody;
    //print(responceBody[0]);
  }

  // @override
  // void initState() {
  //   getPost();
  //   super.initState();
  // }
  Future postPost() async {
    var url = "https://jsonplaceholder.typicode.com/posts";
    var responce = await http.post(Uri.parse(url), body: jsonEncode({
      "title": "foo",
      "body": "bar",
      "userId": "1",
    }), headers: {
      'Content-type': 'application/json; charset=UTF-8',
    });
    var responceBody = responce.body;
    print(responceBody);
    return responceBody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      // body: posts == null || posts.isEmpty
      //     ? Center(child: CircularProgressIndicator())
      //     : ListView.builder(
      //         itemCount: posts.length,
      //         itemBuilder: (context, index) {
      //           return Text("${posts[index]['title']}");
      //         },
      //       ),
      body: ListView(children: [
        ElevatedButton(
            onPressed: () {
              postPost();
            },
            child: Text("post")),
        FutureBuilder(
          future: getPost(),
          //initialData: InitialData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    "${snapshot.data[index]['title']}",
                    style: TextStyle(color: Colors.amber),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ]),
    );
  }
}
