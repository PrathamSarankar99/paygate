import 'package:paygate/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static String verificationID;
  static int resendingID;

  static Stream<User> userStream() {
    return FirebaseAuth.instance.userChanges();
  }

  static User currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static Future<User> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount account = await googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await account.authentication;
    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredential.user;
  }

  static Future<User> signInAnonymously() async {
    UserCredential credential = await FirebaseAuth.instance.signInAnonymously();
    return credential.user;
  }

  static Future<bool> signOut() async {
    await GoogleSignIn().signOut();
    // await FacebookLogin().logOut();
    await FirebaseAuth.instance.signOut();
    return true;
  }

  static Future<dynamic> verifyOTP(String otp) async {
    try {
      PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: otp);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  static Future<dynamic> signInWithFacebook() async {
    print("Facebook login start");
    FacebookLogin facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webOnly;
    FacebookLoginResult result = await facebookLogin.logIn(['email']);
    bool loggedIn;
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        OAuthCredential authCredential =
            FacebookAuthProvider.credential(accessToken.token);
        UserCredential credential =
            await FirebaseAuth.instance.signInWithCredential(authCredential);
        return credential.user;
      default:
        {
          loggedIn = false;
        }
    }
    return loggedIn;
  }

  static signInWithPhone(String phoneno, BuildContext context) {
    FirebaseAuth.instance.verifyPhoneNumber(
      timeout: Duration(seconds: 30),
      phoneNumber: phoneno,
      verificationCompleted: (phoneAuthCredential) {
        FirebaseAuth.instance
            .signInWithCredential(phoneAuthCredential)
            .then((value) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return HomePage(user: value.user);
            },
          ));
        });
      },
      verificationFailed: (error) {
        print('verification failed');
      },
      codeSent: (verificationId, forceResendingToken) {
        verificationID = verificationId;
        resendingID = forceResendingToken;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        verificationID = verificationId;
      },
    );
  }
}
