import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_pay/flutter_pay.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paygate/screens/paytm_payment.dart';
import 'package:upi_india/upi_app.dart';
import 'package:upi_india/upi_india.dart';

class PaymentTypeChooser extends StatefulWidget {
  const PaymentTypeChooser({Key key}) : super(key: key);

  @override
  _PaymentTypeChooserState createState() => _PaymentTypeChooserState();
}

class _PaymentTypeChooserState extends State<PaymentTypeChooser> {
  TextEditingController controller;
  List<UpiApp> _apps;

  @override
  void initState() {
    controller = TextEditingController();
    Future.delayed(Duration(milliseconds: 0), () async {
      _apps = await UpiIndia().getAllUpiApps(
        allowNonVerifiedApps: true,
        mandatoryTransactionId: false,
      );
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(right: 20.0, left: 20, top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Checkout',
              style: GoogleFonts.montserrat(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xff002A42),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: 'Enter a amount'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)))),
                    minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 50))),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Choose the mode"),
                        content: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _apps.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                _onTap(_apps[index]);
                              },
                              leading: Image.memory(_apps[index].icon),
                              title: Text(_apps[index].name),
                            );
                          },
                        ),
                      );
                    },
                  );
                  // List list = _apps
                  //     .where((element) =>
                  //         element.packageName ==
                  //         "com.google.android.apps.nbu.paisa.user")
                  //     .toList();
                  // _onTap(list[0]);
                },
                child: Text(
                  "Installed Apps",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff00A3FF)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)))),
                    minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 50))),
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return PaymentScreen(amount: controller.text);
                    },
                  ));
                },
                child: Text(
                  "Paytm",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.yellow.shade800),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)))),
                    minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 50))),
                onPressed: () async {
                  FlutterPay pay = FlutterPay();
                  bool canPay = await pay.canMakePayments();
                  List<PaymentItem> items = [
                    PaymentItem(
                        name: "PAYGATE", price: double.parse(controller.text))
                  ];
                  if (canPay) {
                    pay.setEnvironment(environment: PaymentEnvironment.Test);
                    String token = await pay.requestPayment(
                      googleParameters: GoogleParameters(
                        gatewayName: "example",
                        gatewayMerchantId: "example_id",
                        merchantId: "example_merchant_id",
                        merchantName: "exampleMerchantName",
                      ),
                      appleParameters: AppleParameters(
                          merchantIdentifier: "merchant.flutterpay.example"),
                      currencyCode: "USD",
                      countryCode: "US",
                      paymentItems: items,
                    );
                    print("Hey! The token is - $token");
                  }
                },
                child: Text(
                  "Google Pay",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTap(UpiApp app) async {
    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");
    final a = await UpiIndia().startTransaction(
      app: app,
      receiverUpiId: "9893333654@paytm",
      receiverName: 'Pratham Sarankar',
      transactionRefId: transactionRef,
      transactionNote: 'Not actual. Just an example.',
      amount: double.parse(controller.text),
      currency: 'INR',
      merchantId: 'oUFnbW35609235084927',
    );
    print(a.approvalRefNo);
  }
}
