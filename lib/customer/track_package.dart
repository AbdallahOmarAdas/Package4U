import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:lottie/lottie.dart';

class track_p extends StatefulWidget {
  @override
  State<track_p> createState() => _track_pState();
}

class _track_pState extends State<track_p> {
  final FocusNode _focusNode = FocusNode();

  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  final formState2 = GlobalKey<FormState>();
  int _index = 0;
  String? tracking_number;
  bool result = false;
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
              Form(
                key: formState2,
                child: TextFormField(
                  onSaved: (newValue) {
                    tracking_number = newValue;
                  },
                  validator: (val) {
                    if (val!.isEmpty) return "Please enter tracking number";
                    if (val.length < 10) return "Please enter 10 digit";
                  },
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter 10 digits tracking number',
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red, width: 2)),
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
                      setState(() {
                        result = true;
                      });
                      formState2.currentState!.save();
                    }
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              result
                  ? Stepper(
                      controlsBuilder:
                          (BuildContext context, ControlsDetails details) {
                        return Text('');
                      },
                      currentStep: _index,
                      // onStepCancel: () {
                      //   if (_index > 0) {
                      //     setState(() {
                      //       _index -= 1;
                      //     });
                      //   }
                      // },
                      // onStepContinue: () {
                      //   if (_index <= 2) {
                      //     setState(() {
                      //       _index += 1;
                      //     });
                      //   }
                      // },
                      onStepTapped: (int index) {
                        setState(() {
                          _index = index;
                        });
                      },
                      stepIconBuilder: (context, state) {
                        return Icon(Icons.check, color: Colors.white);
                      },
                      steps: <Step>[
                        Step(
                          isActive: _index >= 0,
                          title: const Text('Step 1 title'),
                          content: Container(
                            alignment: Alignment.centerLeft,
                            child: const Text('Content for Step 1'),
                          ),
                        ),
                        Step(
                          isActive: _index >= 1,
                          title: const Text('Step 2 title'),
                          content: Container(
                            alignment: Alignment.centerLeft,
                            child: const Text('Content for Step 2'),
                          ),
                        ),
                        Step(
                          isActive: _index >= 2,
                          title: const Text('Step 3 title'),
                          content: Container(
                            alignment: Alignment.centerLeft,
                            child: const Text('Content for Step 3'),
                          ),
                        ),
                        Step(
                          isActive: _index >= 3,
                          title: const Text('Step 4 title'),
                          content: Container(
                            alignment: Alignment.centerLeft,
                            child: const Text('Content for Step 4'),
                          ),
                        ),
                      ],
                      connectorColor: MaterialStateColor.resolveWith((states) {
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
}
