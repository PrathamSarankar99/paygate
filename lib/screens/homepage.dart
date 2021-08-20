import 'dart:math';

import 'package:paygate/screens/payment_chooser.dart';
import 'package:paygate/screens/paytm_payment.dart';
import 'package:paygate/screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paygate/services/auth_service.dart';
import 'package:upi_india/upi_app.dart';
import 'package:upi_india/upi_india.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20, top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: GoogleFonts.montserrat(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff002A42),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    child: Text(
                      AuthService.currentUser().displayName ?? "Username",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff002A42),
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 8, left: 0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Color(0xff00A3FF),
                    ),
                    child: IconButton(
                        onPressed: () async {
                          TextEditingController controller =
                              TextEditingController();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "New username",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff002A42),
                                  ),
                                ),
                                content: TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    hintText: 'Enter a username',
                                    hintStyle: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black.withOpacity(0.3)),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        if (controller.text.isNotEmpty) {
                                          AuthService.currentUser()
                                              .updateDisplayName(
                                                  controller.text)
                                              .then((value) => setState(() {}));
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Text('Save')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel')),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Color(0xff00A3FF),
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  "Welcome to the homepage, you are now logged in as a new user. Click on logout button to revisit the Sign in screen and try new options.",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  "Every user have a unique ID, so do you. Your ID is ${widget.user.uid}. Make sure your unique ID is confidential. This page has Paytm Payment Gateway Integrated, Enter amount in ruppees below and try it by clicking on the Add payment method.",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
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
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PaymentTypeChooser();
                      },
                    ));
                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return AlertDialog(
                    //       title: Text("Choose the mode"),
                    //       content: ListView.builder(
                    //         shrinkWrap: true,
                    //         itemCount: _apps.length,
                    //         itemBuilder: (context, index) {
                    //           return ListTile(
                    //             onTap: () {
                    //               _onTap(_apps[index]);
                    //             },
                    //             leading: Image.memory(_apps[index].icon),
                    //             title: Text(_apps[index].name),
                    //           );
                    //         },
                    //       ),
                    //     );
                    //   },
                    // );
                    // List list = _apps
                    //     .where((element) =>
                    //         element.packageName ==
                    //         "com.google.android.apps.nbu.paisa.user")
                    //     .toList();
                    // _onTap(list[0]);
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (context) {
                    //     return PaymentScreen(amount: controller.text);
                    //   },
                    // ));
                  },
                  child: Text(
                    "Add Payment",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff00A3FF)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 50))),
                  onPressed: () async {
                    bool loggedOut = await AuthService.signOut();
                    if (loggedOut) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SignIn();
                          },
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Logout",
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
      ),
    );
  }
}
