import 'package:flutter/services.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

double late_spec = 0;
double lange_spec = 0;

class location_1 extends StatefulWidget {
  final Function(String, double, double) onDataReceived;

  location_1({required this.onDataReceived});
  @override
  State<location_1> createState() => _location_1State();
}

List<String> addressParts = [];
LatLong current = LatLong(0, 0);

Future<Position> onGetCurrentLocationPressed() async {
  bool serviceEnabled;
  LocationPermission permission;

  try {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  } catch (e) {
    print('Exception while requesting location permission: $e');
  }

  Position p = await Geolocator.getCurrentPosition();
  current = await LatLong(p.latitude, p.longitude);

  return p;
}

class _location_1State extends State<location_1> {
  @override
  void initState() {
    if (lange_spec == 0 && late_spec == 0)
      onGetCurrentLocationPressed().then((value) {
        setState(() {
          current;
        });
      });
    else {
      setState(() {
        current = LatLong(late_spec, lange_spec);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detect Location '),
        backgroundColor: primarycolor,
      ),
      body: OpenStreetMapSearchAndPick(
          center: current,
          locationPinIconColor: primarycolor,
          buttonColor: primarycolor,
          buttonText: 'Set Current Location',
          onPicked: (pickedData) async {
            try {
              String addressString = pickedData.address.toString();
              print(addressString);
              addressString = addressString.replaceAll(
                  RegExp(r'[{}]', multiLine: true), '');
              addressParts = addressString.split(',');
            } on PlatformException catch (e) {
              addressParts[0] = 'Unknown location';
              addressParts[0] = 'Unknown location';
              addressParts[0] = 'Unknown location';
              addressParts[0] = 'Unknown location';
            }
            // print(pickedData.latLong.latitude);
            // print(pickedData.latLong.longitude);
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actions: [
                      TextButton(
                          onPressed: () {
                            widget.onDataReceived(
                                "${addressParts[0]}','${addressParts[1]}','${addressParts[2]}','${addressParts[3]}",
                                pickedData.latLong.latitude,
                                pickedData.latLong.longitude);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )),
                    ],
                    title: Text("Set Location"),
                    content: Text(
                        "you need to save this location\n\n${addressParts[0]}\n${addressParts[1]}\n${addressParts[2]}\n${addressParts[3]}"),
                    titleTextStyle:
                        TextStyle(color: Colors.white, fontSize: 25),
                    contentTextStyle:
                        TextStyle(color: Colors.white, fontSize: 16),
                    backgroundColor: primarycolor,
                  );
                });
          }),
    );
  }
}
