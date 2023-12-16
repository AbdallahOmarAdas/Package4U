import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Track_driver extends StatefulWidget {
  Track_driverState createState() => Track_driverState();
}

class Track_driverState extends State<Track_driver> {
  late List<driver> persons;
  late List<driver> original;
  TextEditingController controller = new TextEditingController();

  void loadData() async {
    persons = [
      driver(
        late: 32.319199,
        long: 35.064320,
        name: 'mohammad',
        phone: '0598989898989',
        img: "assets/f3.png",
      ),
      driver(
        late: 32.173161,
        long: 35.060353,
        name: 'rami',
        phone: '0598989898989',
        img: "assets/add-friend.png",
      ),
      driver(
        late: 32.452490,
        long: 35.305687,
        name: 'zain',
        phone: '0598989898989',
        img: "assets/driver.png",
      ),
      driver(
        late: 32.125780,
        long: 35.345736,
        name: 'ahmad',
        phone: '0598989898989',
        img: "",
      ),
    ];

    original = persons;
    setState(() {});
  }

  void search(String query) {
    if (query.isEmpty) {
      persons = original;
      setState(() {});
      return;
    }

    query = query.toLowerCase();
    print(query);
    List<driver> result = [];
    persons.forEach((p) {
      var name = p.name.toString().toLowerCase();
      if (name.startsWith(query)) {
        result.add(p);
      }
    });

    persons = result;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Drivers"),
        backgroundColor: primarycolor,
      ),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  TextFormField(
                    controller: controller,
                    onChanged: search,
                    decoration: InputDecoration(
                      hintText: "Search",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: primarycolor,
                      ),
                      suffixIcon: IconButton(
                        color: Colors.black,
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          controller.text = '';
                          search(controller.text);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _listView(persons)
          ]),
    );
  }
}

Widget _listView(persons) {
  return Expanded(
    child: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          return InkWell(
            borderRadius: BorderRadius.circular(30),
            splashColor: Colors.grey.withOpacity(0.6),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => track_location(
                          name: persons[index].name,
                          Late: persons[index].late,
                          long: persons[index].long)));
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: primarycolor,
                backgroundImage: persons[index].img == ""
                    ? null
                    : AssetImage("${persons[index].img}"),
                child: persons[index].img == ""
                    ? Text(
                        persons[index].name[0].toString().toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      )
                    : null,
              ),
              title: Text(persons[index].name),
              subtitle: Text("Phone: " + persons[index].phone),
            ),
          );
        }),
  );
}

class driver {
  final String name;
  final String phone;
  final double late;
  final double long;
  final String img;

  driver({
    required this.late,
    required this.long,
    required this.name,
    required this.phone,
    required this.img,
  });
}

class track_location extends StatefulWidget {
  final double Late;
  final double long;
  final String name;

  track_location({required this.Late, required this.long, required this.name});

  @override
  State<track_location> createState() => _track_locationState();
}

class _track_locationState extends State<track_location> {
  late double late;
  late double long;
  late String name;
  GoogleMapController? mapController;
  late Timer timer;
  List<Marker> markers = [];

  void initState() {
    long = widget.long;
    late = widget.Late;
    name = widget.name;
    _addMarker(LatLng(late, long), name);

    initial();
    super.initState();
    //update every   10 seconds
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      setState(() {
        //set new value
        late = 32.173161;
        long = 35.060353;
        _addMarker(LatLng(late, long), name);

        mapController!
            .animateCamera(CameraUpdate.newLatLng(LatLng(late, long)));
        setState(() {});
      });
    });
  }

  void dispose() {
    super.dispose();
    timer.cancel();
  }

  initial() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('service location not enabled');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission denied');
      }
    }
  }

  _addMarker(LatLng position, String desc) {
    MarkerId markerId = MarkerId(desc);
    Marker marker = Marker(
        markerId: markerId,
        infoWindow: InfoWindow(title: desc),
        position: position);
    markers.add(marker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${name} Location'),
        backgroundColor: primarycolor,
      ),
      body: Container(
          child: GoogleMap(
        markers: markers.toSet(),
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(late, long),
          zoom: 12.0,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
      )),
    );
  }
}

// Widget _customMarker() {
//   return Stack(
//     children: [
//       Icon(
//         Icons.add_location,
//         size: 125,
//       ),
//       Positioned(
//         left: 32,
//         top: 18,
//         child: Container(
//           width: 60,
//           height: 60,
//           child: ClipOval(
//               child: Image(
//             fit: BoxFit.cover,
//             image: AssetImage(
//               '',
//             ),
//           )),
//         ),
//       )
//     ],
//   );
// }
