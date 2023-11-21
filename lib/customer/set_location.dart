import 'package:flutter/services.dart';
import 'package:flutter_application_1/customer/add_parcel.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class set_location extends StatefulWidget {
  final Function(String, double, double) onDataReceived;

  set_location({required this.onDataReceived});
  @override
  State<set_location> createState() => _set_locationState();
}

List<String> addressParts = [];
LatLong current = LatLong(32.193192, 35.297659);

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

class _set_locationState extends State<set_location> {
  @override
  void initState() {
    onGetCurrentLocationPressed().then((value) {
      setState(() {
        current;
      });
    });
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
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            widget.onDataReceived(
                                "${addressParts[0]}','${addressParts[1]}','${addressParts[2]}','${addressParts[3]}",
                                pickedData.latLong.latitude,
                                pickedData.latLong.longitude);
                            //add_parcel().
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
