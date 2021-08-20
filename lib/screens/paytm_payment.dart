import 'package:flutter/material.dart';
import 'package:paygate/services/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String amount;
  const PaymentScreen({Key key, @required this.amount}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  WebViewController _controller;

  @override
  void dispose() {
    _controller = null;
    super.dispose();
  }

  String _loadHTML() {
    return "<html> <body onload='document.f.submit();'> <form id='f' name='f' method='post' action='$PAYMENT_URL'><input type='hidden' name='orderID' value='ORDER_${DateTime.now().millisecondsSinceEpoch}'/>" +
        "<input  type='hidden' name='custID' value='${ORDER_DATA["custID"]}' />" +
        "<input  type='hidden' name='amount' value='${widget.amount}' />" +
        "<input type='hidden' name='custEmail' value='${ORDER_DATA["custEmail"]}' />" +
        "<input type='hidden' name='custPhone' value='${ORDER_DATA["custPhone"]}' />" +
        "</form> </body> </html>";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebView(
            debuggingEnabled: false,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _controller = controller;
              _controller.loadUrl(
                  new Uri.dataFromString(_loadHTML(), mimeType: 'text/html')
                      .toString());
            },
          )),
    ));
  }
}
