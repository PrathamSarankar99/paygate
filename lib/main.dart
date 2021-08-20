import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paygate/screens/homepage.dart';
import 'package:paygate/screens/sign_in.dart';
import 'package:paygate/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PaygateApp());
}

class PaygateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paygate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Paygate(),
    );
  }
}

class Paygate extends StatefulWidget {
  Paygate({Key key}) : super(key: key);

  @override
  _PaygateState createState() => _PaygateState();
}

class _PaygateState extends State<Paygate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: AuthService.userStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage(user: snapshot.data);
          }
          return SignIn();
        });
  }
}
