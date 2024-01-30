import 'package:flutter/material.dart';
import 'package:Package4U/Models/DriverTrack.dart';
import 'package:Package4U/manager/TrackDriverLocation.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:Package4U/style/showDialogShared/show_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class track_p extends StatefulWidget {
  final bool isSearchBox;
  final int packageId;

  const track_p(
      {super.key, required this.isSearchBox, required this.packageId});

  @override
  State<track_p> createState() => _track_pState();
}

class _track_pState extends State<track_p> {
  final FocusNode _focusNode = FocusNode();
  int _index = 0;
  int pktIndex = 4;
  String? status;
  String? driverName;
  String? vehicleNumber;
  String? driverComment;
  DateTime? rerciveDate;
  DateTime? deliverDate;
  Driver? _driver;
  List allStatus = [
    "Under review", //0
    "Accepted", //1
    "Wait Driver", //2
    "In Warehouse", //3
    "With Driver", //4
    "Delivered", //5
    "Rejected by driver", //6
    "Complete Receive", //7
    "Rejected by employee", //8
    "Assigned to receive", // 9
    "Assigned to deliver", // 10
    "Completed", //11
  ];
  bool result = false;
  bool isAllowdExpand = true;
  Future<void> fetchData() async {
    var url = urlStarter +
        "/customer/packageState?packageId=" +
        tracking_number.toString();
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      if (data['message'] == "done") {
        print("done");
        setState(() {
          var driver = data['result']['driver'];
          String recieveDateString = (data['result']['receiveDate'] == null)
              ? "0000-00-00T00:00:00"
              : data['result']['receiveDate'];
          String deliverDateString = (data['result']['deliverDate'] == null)
              ? "0000-00-00T00:00:00"
              : data['result']['deliverDate'];
          status = data['result']['status'];
          driverComment = data['result']['driverComment'];
          rerciveDate =
              DateFormat('yyyy-MM-ddTHH:mm:ss').parse(recieveDateString);
          deliverDate =
              DateFormat('yyyy-MM-ddTHH:mm:ss').parse(deliverDateString);
          if (driver == null) {
            driverName = " ";
            vehicleNumber = " ";
          } else {
            driverName = driver['Fname'] + " " + driver['Lname'];
            vehicleNumber = data['driver']['vehicleNumber'];
            print(data['driver']['latitude']);
            _driver = new Driver(
                date: data['driver']['updatedAt'],
                late: data['driver']['latitude'],
                long: data['driver']['longitude'],
                username: driver['userName'],
                name: driverName.toString());
          }

          pktIndex = allStatus.indexOf(status);
          _index = pktIndex;
          pktIndex == 6 ? _index = 3 : _index;
          pktIndex == 7 ? _index = 3 : _index;
          pktIndex == 8 ? _index = 1 : _index;
          pktIndex == 9 ? _index = 1 : _index;
          pktIndex == 10 ? _index = 3 : _index;
          pktIndex == 11 ? _index = 5 : _index;
          result = true;
          if (pktIndex != 6 && pktIndex != 8) pktIndex = _index;
          print("pkt ini= " + pktIndex.toString());
          if (pktIndex == 6 || pktIndex == 8) isAllowdExpand = false;
        });
      } else if (data['message'] == "invalid id") {
        print("invalid id");
        setState(() {
          result = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              return show_dialog().alartDialog("In vaild package Id",
                  "Please enter vaild package Id", context);
            });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void initState() {
    _focusNode.requestFocus();
    super.initState();
    if (widget.isSearchBox) {
      result = false;
    } else {
      result = true;
      tracking_number = widget.packageId.toString();
      fetchData();
    }
  }

  final formState2 = GlobalKey<FormState>();

  String? tracking_number;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Package'),
        backgroundColor: primarycolor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Visibility(
                visible: !result,
                child: Column(
                  children: [
                    Form(
                      key: formState2,
                      child: TextFormField(
                        onSaved: (newValue) {
                          tracking_number = newValue;
                        },
                        validator: (val) {
                          if (val!.isEmpty)
                            return "Please enter tracking number";
                          return null;
                        },
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter tracking package number',
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primarycolor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0)),
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        ),
                        label: Text("Search"),
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (formState2.currentState!.validate()) {
                            formState2.currentState!.save();
                            fetchData();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              result
                  ? Column(
                      children: [
                        Text(
                          "Package State Progress",
                          style: TextStyle(
                              color: primarycolor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Transform(
                            transform: Matrix4.translationValues(0, 0, 0),
                            child:
                                Lottie.asset("assets/stepper annimation.json")),
                        Container(
                          height: 40,
                        ),
                        Stepper(
                          controlsBuilder:
                              (BuildContext context, ControlsDetails details) {
                            return Text('');
                          },
                          currentStep: _index,
                          onStepTapped: (int index) {
                            print(index);
                            setState(() {
                              _index = index;
                            });
                          },
                          steps: <Step>[
                            Step(
                              isActive: _index >= 0 && 0 <= pktIndex,
                              state: 0 <= pktIndex
                                  ? StepState.complete
                                  : StepState.disabled,
                              title: const Text('Pending'),
                              content: Container(
                                alignment: Alignment.centerLeft,
                                child:
                                    const Text('This Package is under review.'),
                              ),
                            ),
                            AcceptState(),
                            Step(
                              isActive: _index >= 2 &&
                                  2 <= pktIndex &&
                                  isAllowdExpand,
                              state: 2 == pktIndex && isAllowdExpand
                                  ? StepState.complete
                                  : StepState.disabled,
                              title: const Text('Wait Driver'),
                              content: Container(
                                child: Column(
                                  children: [
                                    const Text(
                                        'Detailes: This package will be picked up today by the driver'),
                                    Text("Driver Name: " +
                                        driverName.toString()),
                                    Text("Vehicle Number: " +
                                        vehicleNumber.toString()),
                                    TextButton.icon(
                                        label: Text(
                                          "Track Location",
                                          style: TextStyle(color: primarycolor),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TrackDriverLocation(
                                                          name: _driver!.name,
                                                          userName:
                                                              _driver!.username,
                                                          Late: _driver!.late,
                                                          long:
                                                              _driver!.long)));
                                        },
                                        icon: Icon(
                                          Icons.track_changes,
                                          color: primarycolor,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            driverState(),
                            Step(
                              isActive: _index >= 4 &&
                                  4 <= pktIndex &&
                                  isAllowdExpand,
                              state: 4 == pktIndex && isAllowdExpand
                                  ? StepState.complete
                                  : StepState.disabled,
                              title: const Text('With Driver'),
                              content: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const Text(
                                        'Detailes: This package is with the driver, you can now track the location of the package'),
                                    Text(" "),
                                    Text("Driver Name: " +
                                        driverName.toString()),
                                    Text("Vehicle Number: " +
                                        vehicleNumber.toString()),
                                    TextButton.icon(
                                        label: Text(
                                          "Track Location",
                                          style: TextStyle(color: primarycolor),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TrackDriverLocation(
                                                          name: _driver!.name,
                                                          userName:
                                                              _driver!.username,
                                                          Late: _driver!.late,
                                                          long:
                                                              _driver!.long)));
                                        },
                                        icon: Icon(
                                          Icons.track_changes,
                                          color: primarycolor,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Step(
                              isActive: _index >= 5 &&
                                  5 <= pktIndex &&
                                  isAllowdExpand,
                              state: 5 <= pktIndex && isAllowdExpand
                                  ? StepState.complete
                                  : StepState.disabled,
                              title: const Text('Delivered'),
                              content: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const Text(
                                        'Details: This package has been delivered successfully. We are pleased to serve you'),
                                    Text('Date: ' + deliverDate.toString()),
                                  ],
                                ),
                              ),
                            )
                          ],
                          connectorColor: MaterialStateColor.resolveWith(
                              (states) {
                            if (states.contains(MaterialState.disabled)) {
                              // Color for disabled state
                              return Colors.grey;
                            } else {
                              // Default color
                              return primarycolor;
                            }
                          }
                              //_index == states ? Colors.amber : Colors.black

                              ),
                        ),
                      ],
                    )
                  : Transform(
                      transform: Matrix4.translationValues(0, 0, 0),
                      child: Lottie.asset("assets/search.json")),
            ],
          ),
        ),
      ),
    );
  }

  Step driverState() {
    if (6 == pktIndex) {
      return Step(
        isActive: true,
        state: StepState.error,
        title: const Text('Rejected by driver'),
        content: Container(
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              const Text(
                  'Detailes: The driver refused to receive the package from you'),
              Text(" "),
              Text("Driver Comment: " + driverComment.toString()),
              Text("Driver Name: " + driverName.toString()),
            ],
          ),
        ),
      );
    }
    return Step(
      isActive: _index >= 3 && 3 <= pktIndex,
      state: 3 <= pktIndex && isAllowdExpand
          ? StepState.complete
          : StepState.disabled,
      title: const Text('In Warehouse'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: const Text(
            'Detailes: This package is in our warehouse waiting to be distributed to drivers'),
      ),
    );
  }

  Step AcceptState() {
    if (8 == pktIndex) {
      return Step(
        isActive: true,
        state: StepState.error,
        title: const Text('Rejected'),
        content: Container(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Detailes: Your package delivery has been refused'),
              Text(" "),
              Text("Reason: " + driverComment.toString())
            ],
          ),
        ),
      );
    }
    return Step(
      isActive: _index >= 1 && 1 <= pktIndex,
      state: 1 <= pktIndex ? StepState.complete : StepState.disabled,
      title: const Text('Accepted'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            const Text('Detailes: This package has been approved for delivery'),
            Text('Date: ' + rerciveDate.toString()),
          ],
        ),
      ),
    );
  }
}
