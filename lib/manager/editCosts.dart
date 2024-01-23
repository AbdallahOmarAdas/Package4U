import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:Package4U/style/header/header.dart';
import 'package:Package4U/style/showDialogShared/show_dialog.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class editCosts extends StatefulWidget {
  const editCosts({super.key});

  @override
  State<editCosts> createState() => _editCostsState();
}

class _editCostsState extends State<editCosts> {
  double? openingPrice;
  double? bigPackagePrice;
  double? pricePerKm;
  int? discount;

  TextEditingController _textControlleropeningPrice = TextEditingController();
  TextEditingController _textControllerbigPackagePrice =
      TextEditingController();
  TextEditingController _textControllerpricePerKm = TextEditingController();
  TextEditingController _textControllerdiscount = TextEditingController();

  Future<void> fetchData() async {
    var url = urlStarter + "/users/costs";
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _textControlleropeningPrice.text = data['openingPrice'].toString();
        _textControllerbigPackagePrice.text =
            data['bigPackagePrice'].toString();
        _textControllerpricePerKm.text = data['pricePerKm'].toString();
        _textControllerdiscount.text = data['discount'].toString();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future postEditDeliveryCosts() async {
    var url = urlStarter + "/manager/editDeliveryCosts";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "managerPassword": GetStorage().read('password'),
          "managerUserName": GetStorage().read('userName'),
          "openingPrice": openingPrice,
          "bigPackagePrice": bigPackagePrice,
          "pricePerKm": pricePerKm,
          "discount": discount
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    print(responceBody);
    if (responceBody['message'] == "failed") {
      List errors = responceBody['error']['errors'];
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().aboutDialogErrors(errors, context);
          });
    }
    if (responceBody['message'] == "done") {
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().alartDialogPushNamed(
                "Done!",
                "Delivery costs edited succsessfully.",
                context,
                GetStorage().read("userType"));
          });
    }
    if (responceBody['message'] == "faild2") {
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().alartDialog(
                "Faild!", "Company Information edited succsessfully.", context);
          });
    }
    return responceBody;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  GlobalKey<FormState> formState1 = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Package4U Edit Info'),
          backgroundColor: primarycolor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 110,
                child: HeaderWidget(110),
              ),
              SafeArea(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                        key: formState1,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _textControlleropeningPrice,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                              onSaved: (newValue) {
                                openingPrice =
                                    double.tryParse(newValue.toString());
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter opening price";
                                }
                                return null;
                              },
                              decoration: theme_helper().text_form_style(
                                'Opening Price',
                                'Enter opening price',
                                Icons.monetization_on_outlined,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                              controller: _textControllerbigPackagePrice,
                              onSaved: (newValue) {
                                bigPackagePrice =
                                    double.tryParse(newValue.toString());
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter big package cost";
                                }
                                return null;
                              },
                              decoration: theme_helper().text_form_style(
                                'Big Package Cost',
                                'Enter big package cost',
                                Icons.check_box_outlined,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _textControllerpricePerKm,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                              onSaved: (newValue) {
                                pricePerKm =
                                    double.tryParse(newValue.toString());
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter price Per Km";
                                }
                                return null;
                              },
                              decoration: theme_helper().text_form_style(
                                'Price/Km',
                                'Enter Price/Km',
                                Icons.edit_road,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _textControllerdiscount,
                              onSaved: (newValue) {
                                discount = int.tryParse(newValue.toString());
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter discount percentage";
                                }
                                return null;
                              },
                              decoration: theme_helper().text_form_style(
                                'Discount Percentage',
                                'Enter discount percentage',
                                Icons.percent,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                // for below version 2 use this
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.0)),
                                color: primarycolor,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  if (formState1.currentState!.validate()) {
                                    formState1.currentState!.save();
                                    postEditDeliveryCosts();
                                  }
                                },
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
