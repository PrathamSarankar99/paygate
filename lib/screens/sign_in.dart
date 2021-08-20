import 'package:paygate/screens/homepage.dart';
import 'package:paygate/screens/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paygate/services/auth_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Payment",
                  style: GoogleFonts.montserrat(
                    fontSize: 45,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff002A42),
                  )),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Gate',
                      style: GoogleFonts.montserrat(
                        fontSize: 45,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff002A42),
                      )),
                  Container(
                    width: 13,
                    height: 13,
                    margin: EdgeInsets.only(bottom: 10, left: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff00A3FF),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: TextField(
                  style: GoogleFonts.montserrat(),
                  controller: controller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: 'Enter a phone no.',
                    hintStyle: GoogleFonts.montserrat(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 30),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff00A3FF)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(1000)))),
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 50))),
                  onPressed: () {
                    AuthService.signInWithPhone(controller.text, context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Otp();
                      },
                    ));
                  },
                  child: Text(
                    "Request OTP",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35.0, bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xff002A42).withOpacity(0.6),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, left: 12),
                      child: Text(
                        "more Sign in Options",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Color(0xff002A42).withOpacity(0.6),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xff002A42).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: OutlinedButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.black12),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 50))),
                  onPressed: () async {
                    User user = await AuthService.signInWithGoogle();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return HomePage(
                          user: user,
                        );
                      },
                    ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/google.png',
                        height: 30,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Sign in with Google",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff002A42),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 10),
                child: OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff4267B2)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 50))),
                  onPressed: () async {
                    var result = await AuthService.signInWithFacebook();
                    if (result.runtimeType == User) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) {
                          return HomePage(user: result);
                        },
                      ));
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/facebook.png',
                        height: 30,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Sign in with Facebook",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Text(
                        "Let's Get started. ",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          color: Color(0xff002A42),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        User user = await AuthService.signInAnonymously();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) {
                            return HomePage(user: user);
                          },
                        ));
                      },
                      child: Text(
                        "Login anonymously!",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          color: Color(0xff00A3FF),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
