import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ui/flutter_firebase_ui.dart';
import 'package:nero_restaurant/ui/home_page/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nero_restaurant/services/firebase_calls.dart';
import 'package:nero_restaurant/ui/style.dart';
import 'package:nero_restaurant/ui/order_page/main_order_page.dart';
import 'package:nero_restaurant/ui/loyalty_card_page.dart';


void main() => runApp(new NeroRestaurant());

class NeroRestaurant extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Nero Digital',
      theme: mainTheme,
      home: new LoginPage(title: 'Nero Digital'),
      routes: <String, WidgetBuilder>{
        '/main_order_page': (_) => new MainOrderPage(),
        '/loyalty_card_page': (_) => new LoyaltyCardPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<FirebaseUser> _listener;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  FirebaseUser _currentUser;
  String pushToken;

  @override
  void initState() {
    super.initState();
    FirebaseCalls.loadItems().then((status) => setState(() {}));
    FirebaseCalls.loadCategories().then((status) => setState(() {}));
    FirebaseCalls.loadOptions().then((status) => setState(() {}));
    FirebaseCalls.loadWebLinks().then((status) => setState(() {}));

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      print(token);
      pushToken = token;
    });
    _checkCurrentUser();
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return new SignInScreen(
        title: "Nero Restaurant",
        header: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: new Image.asset(
              'assets/images/ndm_logo.png',
              width: 246.0,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        providers: [
          ProvidersTypes.facebook,
          ProvidersTypes.google,
          ProvidersTypes.email
        ],
      );
    } else {
      return new HomePage();
    }
  }

  void _checkCurrentUser() async {
    _currentUser = await _auth.currentUser();
    _currentUser?.getIdToken(refresh: true);

    if(_currentUser != null)
      FirebaseCalls.saveUser(_currentUser, pushToken);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      setState(() {
        _currentUser = user;
        if(_currentUser != null)
          FirebaseCalls.saveUser(_currentUser, pushToken);
      });
    });
  }
}

